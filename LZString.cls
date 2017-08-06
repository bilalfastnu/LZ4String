/**
 * Created by bilalnazir on 11/29/16.
 */

public without sharing class LZString {

    static String keyStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';

    public static String compress(String uncompressed) {

        if (uncompressed == null)
            return '';

        Integer value;
        Map<String, Integer> context_dictionary = new Map<String, Integer>();
        Set<String> context_dictionaryToCreate = new Set<String>();

        String context_c = '';
        String context_wc = '';
        String context_w = '';
        double context_enlargeIn = 2; // Compensate for the first entry which
        // should not count
        Integer context_dictSize = 3;
        Integer context_numBits = 2;
        String context_data_string = '';
        Integer context_data_val = 0;
        Integer context_data_position = 0;


        for (Integer ii = 0; ii < uncompressed.length(); ii += 1) {
            context_c = String.fromCharArray(new Integer[]{uncompressed.charAt(ii)});
            if (!context_dictionary.containsKey(context_c)) {
                context_dictionary.put(context_c, context_dictSize++);
                context_dictionaryToCreate.add(context_c);
            }

            context_wc = context_w + context_c;
//            System.debug('Context_W ==> ' + context_w);
//            System.debug('Context_C ==> ' + context_c);
//            System.debug('Context_WC ==> ' + context_wc);

            if (context_dictionary.containsKey(context_wc)) {
                context_w = context_wc;
            } else {
                if (context_dictionaryToCreate.contains(context_w)) {

                    if (context_w.charAt(0) < 256) {
                        for (Integer i = 0; i < context_numBits; i++) {
                            context_data_val = (context_data_val << 1);
                            if (context_data_position == 15) {
                                context_data_position = 0;
                                //context_data_string += (char) context_data_val;
                                context_data_string += String.fromCharArray(new Integer[]{context_data_val});
//                                System.debug('Context data ==>' + context_data_val);
//                                System.debug('Context ==> ' + context_data_string);
                                context_data_val = 0;
                            } else {
                                context_data_position++;
                            }
                        }
                        value = context_w.charAt(0);
                        for (Integer i = 0; i < 8; i++) {
                            context_data_val = (context_data_val << 1) | (value & 1);
                            if (context_data_position == 15) {
                                context_data_position = 0;
                                //context_data_string += (char) context_data_val;
                                context_data_string += String.fromCharArray(new Integer[]{context_data_val});
//                                System.debug('Context data ==>' + context_data_val);
//                                System.debug('Context ==> ' + context_data_string);
                                context_data_val = 0;
                            } else {
                                context_data_position++;
                            }
                            value = value >> 1;
                        }
                    } else {
                        value = 1;
                        for (Integer i = 0; i < context_numBits; i++) {
                            context_data_val = (context_data_val << 1) | value;
                            if (context_data_position == 15) {
                                context_data_position = 0;
                                //context_data_string += (char) context_data_val;
                                context_data_string += String.fromCharArray(new Integer[]{context_data_val});
//                                System.debug('Context data ==>' + context_data_val);
//                                System.debug('Context ==> ' + context_data_string);
                                context_data_val = 0;
                            } else {
                                context_data_position++;
                            }
                            value = 0;
                        }
                        value = context_w.charAt(0);
                        for (Integer i = 0; i < 16; i++) {
                            context_data_val = (context_data_val << 1) | (value & 1);
                            if (context_data_position == 15) {
                                context_data_position = 0;
                                context_data_string += String.fromCharArray(new Integer[]{context_data_val});
//                                System.debug('Context data ==>' + context_data_val);
//                                System.debug('Context ==> ' + context_data_string);
                                context_data_val = 0;
                            } else {
                                context_data_position++;
                            }
                            value = value >> 1;
                        }
                    }
                    context_enlargeIn--;

                    if (Double.valueOf(context_enlargeIn).intValue() == 0) {
                        context_enlargeIn = Math.pow(2, context_numBits);
                        context_numBits++;
                    }
                    context_dictionaryToCreate.remove(context_w);
                } else {
                    value = context_dictionary.get(context_w);
                    for (Integer i = 0; i < context_numBits; i++) {
                        context_data_val = (context_data_val << 1) | (value & 1);
                        if (context_data_position == 15) {
                            context_data_position = 0;
                            //context_data_string += (char) context_data_val;
                            context_data_string += String.fromCharArray(new Integer[]{context_data_val});
//                            System.debug('Context data ==>' + context_data_val);
//                            System.debug('Context ==> ' + context_data_string);
                            context_data_val = 0;
                        } else {
                            context_data_position++;
                        }
                        value = value >> 1;
                    }

                }
                context_enlargeIn--;
                if (Double.valueOf(context_enlargeIn).intValue() == 0) {
                    context_enlargeIn = Math.pow(2, context_numBits);
                    context_numBits++;
                }
                // Add wc to the dictionary.
                context_dictionary.put(context_wc, context_dictSize++);

                String newstring = context_c;
                context_w = String.valueOf(newstring);
            }
        }

        // Output the code for w.
        if (!''.equals(context_w)) {
            if (context_dictionaryToCreate.contains(context_w)) {
                if (((Integer) context_w.charAt(0)) < 256) {
                    for (Integer i = 0; i < context_numBits; i++) {
                        context_data_val = (context_data_val << 1);
                        if (context_data_position == 15) {
                            context_data_position = 0;
                            //context_data_string += (char) context_data_val;
                            context_data_string += String.fromCharArray(new Integer[]{context_data_val});
//                            System.debug('Context data ==>' + context_data_val);
//                            System.debug('Context ==> ' + context_data_string);
                            context_data_val = 0;
                        } else {
                            context_data_position++;
                        }
                    }
                    value = (Integer) context_w.charAt(0);
                    for (Integer i = 0; i < 8; i++) {
                        context_data_val = (context_data_val << 1) | (value & 1);
                        if (context_data_position == 15) {
                            context_data_position = 0;
                            //context_data_string += (char) context_data_val;
                            context_data_string += String.fromCharArray(new Integer[]{context_data_val});
//                            System.debug('Context data ==>' + context_data_val);
//                            System.debug('Context ==> ' + context_data_string);
                            context_data_val = 0;
                        } else {
                            context_data_position++;
                        }
                        value = value >> 1;
                    }
                } else {
                    value = 1;
                    for (Integer i = 0; i < context_numBits; i++) {
                        context_data_val = (context_data_val << 1) | value;
                        if (context_data_position == 15) {
                            context_data_position = 0;
                            //context_data_string += (char) context_data_val;
                            context_data_string += String.fromCharArray(new Integer[]{context_data_val});
//                            System.debug('Context data ==>' + context_data_val);
//                            System.debug('Context ==> ' + context_data_string);
                            context_data_val = 0;
                        } else {
                            context_data_position++;
                        }
                        value = 0;
                    }
                    value = context_w.charAt(0);
                    for (Integer i = 0; i < 16; i++) {
                        context_data_val = (context_data_val << 1) | (value & 1);
                        if (context_data_position == 15) {
                            context_data_position = 0;
                            //context_data_string += (char) context_data_val;
                            context_data_string += String.fromCharArray(new Integer[]{context_data_val});
//                            System.debug('Context data ==>' + context_data_val);
//                            System.debug('Context ==> ' + context_data_string);
                            context_data_val = 0;
                        } else {
                            context_data_position++;
                        }
                        value = value >> 1;
                    }
                }
                context_enlargeIn--;
                if (Double.valueOf(context_enlargeIn).intValue() == 0) {
                    context_enlargeIn = Math.pow(2, context_numBits);
                    context_numBits++;
                }
                context_dictionaryToCreate.remove(context_w);
            } else {
                value = context_dictionary.get(context_w);
                for (Integer i = 0; i < context_numBits; i++) {
                    context_data_val = (context_data_val << 1) | (value & 1);
                    if (context_data_position == 15) {
                        context_data_position = 0;
                        //context_data_string += (char) context_data_val;
                        context_data_string += String.fromCharArray(new Integer[]{context_data_val});
//                        System.debug('Context data ==>' + context_data_val);
//                        System.debug('Context ==> ' + context_data_string);
                        context_data_val = 0;
                    } else {
                        context_data_position++;
                    }
                    value = value >> 1;
                }

            }
            context_enlargeIn--;
            if (Double.valueOf(context_enlargeIn).intValue() == 0) {
                context_enlargeIn = Math.pow(2, context_numBits);
                context_numBits++;
            }
        }

        // Mark the end of the stream
        value = 2;
        for (Integer i = 0; i < context_numBits; i++) {
            context_data_val = (context_data_val << 1) | (value & 1);
            if (context_data_position == 15) {
                context_data_position = 0;
                //context_data_string += (char) context_data_val;
                context_data_string += String.fromCharArray(new Integer[]{context_data_val});
//                System.debug('Context data ==>' + context_data_val);
//                System.debug('Context ==> ' + context_data_string);
                context_data_val = 0;
            } else {
                context_data_position++;
            }
            value = value >> 1;
        }

        // Flush the last char
        while (true) {
            context_data_val = (context_data_val << 1);
            if (context_data_position == 15) {
                //context_data_string += (char) context_data_val;
                context_data_string += String.fromCharArray(new Integer[]{context_data_val});
//                System.debug('Context data ==>' + context_data_val);
//                System.debug('Context ==> ' + context_data_string);
                break;
            } else
                    context_data_position++;
        }
        return context_data_string;
    }

    public static String decompress(String compressed){
        if (compressed == null)
            return '';
        if (compressed == '')
            return null;

        System.debug('Input Compressed ==>' + compressed);

        List<String> dictionary = new String[200];
//        for(integer j = 0; j < dictionary.size(); j++)
//            dictionary.set(j, '');

        double enlargeIn = 4;
        Integer dictSize = 4;
        Integer numBits = 3;
        Integer next;
        String entry = '';

        String result = '';

        String w;
        Integer bits;
        Integer resb;
        double maxpower;
        Integer power;
        String c = '';
        Integer d;

        Data data = LZString.getNewDataInsance();

        data.dataString = compressed;
        data.val = (Integer) compressed.charAt(0);
        data.position = 32768;
        data.index = 1;

        for (Integer i = 0; i < 3; i += 1) {
            dictionary.add(i, String.valueOf(i));
        }

        bits = 0;
        maxpower = Math.pow(2, 2);
        power = 1;

        while (power != Double.valueOf(maxpower).intValue()) {
            resb = data.val & data.position;
            data.position >>= 1;
            if (data.position == 0) {
                data.position = 32768;
                data.val = (Integer) data.dataString.charAt(data.index++);
            }
            bits |= (resb > 0 ? 1 : 0) * power;
            power <<= 1;
        }

        System.debug('Bits ==>' + bits);
        next = bits;
        if(next == 0){
            bits = 0;
            maxpower = Math.pow(2, 8);
            power = 1;
            while (power != Double.valueOf(maxpower).intValue()) {
                resb = data.val & data.position;
                data.position >>= 1;
                if (data.position == 0) {
                    data.position = 32768;
                    data.val = (Integer) data.dataString.charAt(data.index++);
                }
                bits |= (resb > 0 ? 1 : 0) * power;
                power <<= 1;
            }
            //c += (char) bits;
            c += String.fromCharArray(new Integer[]{bits});
        }
        else if(next == 1){
            bits = 0;
            maxpower = Math.pow(2, 16);
            power = 1;
            while (power != Double.valueOf(maxpower).intValue()) {
                resb = data.val & data.position;
                data.position >>= 1;
                if (data.position == 0) {
                    data.position = 32768;
                    data.val = (Integer) data.dataString.charAt(data.index++);
                }
                bits |= (resb > 0 ? 1 : 0) * power;
                power <<= 1;
            }
            //c += (char) bits;

            c += String.fromCharArray(new Integer[]{bits});
        }
        else if(next == 2)
            return '';

        dictionary.add(3, c);
//        System.debug('Dictionary before while-true ==>' + dictionary);
        w = c;
        //result = new StringBuilder(200);
        //result = '';

        //result.append(c);
        result += c;
//        System.debug('result before while-true ==>' + result);
//        System.debug('Data ==>' + data);

        // w = result = c;

        while(true){
            if (data.index > data.dataString.length()) {
                return '';
            }

            bits = 0;
            maxpower = Math.pow(2, numBits);
            power = 1;
            while (power != Double.valueOf(maxpower).intValue()) {
                resb = data.val & data.position;
                data.position >>= 1;
                if (data.position == 0 && data.index < data.dataString.length()) {
                    data.position = 32768;
                    data.val = (Integer) data.dataString.charAt(data.index++);
                }
                bits |= (resb > 0 ? 1 : 0) * power;
                power <<= 1;
            }
//            System.debug('Data Position 0 ==>' + data.position);
//            System.debug('Bits 0 ==>' + bits);
            d = bits;

            if(d == 0){
                bits = 0;
                maxpower = Math.pow(2, 8);
                power = 1;

//                System.debug('Data 0 ==> String='+ EncodingUtil.base64Encode(Blob.valueOf(data.dataString)) +
//                ',position='+data.position+
//                ',val='+data.val+
//                ',index='+data.index
//                );

                while (power != Double.valueOf(maxpower).intValue()) {
                    resb = data.val & data.position;
                    data.position >>= 1;
                    if (data.position == 0) {
                        data.position = 32768;
                        data.val = (Integer) data.dataString.charAt(data.index++);
                    }
                    bits |= (resb > 0 ? 1 : 0) * power;
                    power <<= 1;
                }

                //temp += (char) bits;
                String temp = String.fromCharArray(new Integer[]{bits});

//                if(dictSize > 15)
//                    System.debug('d-15:' + dictionary.get(15));
                dictionary.add(dictSize++, String.fromCharArray(new Integer[]{bits}));

//                System.debug('Data Position 1 ==>' + data.position);
//                System.debug('Bits 1 ==>' + bits);
//                System.debug('Temp 1 ==>' + temp);

                d = dictSize - 1;

                enlargeIn--;
            }
            else if(d == 1){
                bits = 0;
                maxpower = Math.pow(2, 16);
                power = 1;
                while (power != Double.valueOf(maxpower).intValue()) {
                    resb = data.val & data.position;
                    data.position >>= 1;
                    if (data.position == 0) {
                        data.position = 32768;
                        data.val = (Integer) data.dataString.charAt(data.index++);
                    }
                    bits |= (resb > 0 ? 1 : 0) * power;
                    power <<= 1;
                }

                //temp='';
                //temp += (char) bits;
                String temp = String.fromCharArray(new Integer[]{bits});

//                if(dictSize > 15)
//                    System.debug('d-15:' + dictionary.get(15));
                dictionary.add(dictSize++, String.fromCharArray(new Integer[]{bits}));

//                System.debug('Data Position 2 ==>' + data.position);
//                System.debug('Bits 2 ==>' + bits);
//                System.debug('Temp 2 ==>' + temp);

                d = dictSize - 1;
                enlargeIn--;
            }
            else if(d == 2){
                return String.valueOf(result);
            }


            if (Double.valueOf(enlargeIn).intValue() == 0) {
                enlargeIn = Math.pow(2, numBits);
                numBits++;
            }

            if (d < dictionary.size() && dictionary.get(d) != null) {
                entry = dictionary.get(d);
//                System.debug('d-index ==>' + d);
//                System.debug('Entry 0 ==>' + entry);
            } else {
                if (d == dictSize) {
                    //entry = w + w.charAt(0);
                    entry = w + String.fromCharArray(new Integer[]{w.charAt(0)});
//                    System.debug('Entry 1 ==>' + entry);
                } else {
//                    System.debug('Entry Failed d ==>' + d);
//                    System.debug('Entry Failed dictSize ==>' + dictSize);
                    return null;
                }
            }


            System.debug('Entry 2 ==>' + entry);
            result += entry;

            // Add w+entry[0] to the dictionary.

            //integer new_W = w.charAt(0) + entry.charAt(0);
            //dictionary.add(dictSize++, w + String.fromCharArray(new Integer[]{entry.charAt(0)}));
            dictionary.add(dictSize++, w + String.fromCharArray(new Integer[]{entry.charAt(0)}));
            enlargeIn--;

            w = entry;

            if (Double.valueOf(enlargeIn).intValue() == 0) {
                enlargeIn = Math.pow(2, numBits);
                numBits++;
            }
        }

        return result;
    }

    public static String decompressHexString(String hexString) {

        if (hexString == null) {
            return '';
        }

        if (Math.mod(hexString.length(), 2) != 0) {
            //throw new RuntimeException('Input string length should be divisible by two');
        }

        Integer []intArr = new Integer[hexString.length() / 2];

        Integer i = 0, k = 0;
        for (i = 0; i < hexString.length(); i += 2) {
            //intArr[k] = Integer.parseInt('' + hexString.charAt(i) + hexString.charAt(i + 1), 16);
            String hexaInt = EncodingUtil.convertToHex(Blob.valueOf('' + hexString.charAt(i) + hexString.charAt(i + 1)));
            intArr[k] = Integer.valueOf(hexaInt);
            k++;
        }

        String sb = '';
        for (Integer j = 0; j < intArr.size(); j += 2) {
            //sb.append(Character.toChars(intArr[j] | intArr[j + 1] << 8));
            integer intVal = intArr[j] | intArr[j + 1] << 8;
            sb += String.fromCharArray(new Integer[]{
                    intVal
            });
        }


        return decompress(sb) ;
    }

    public static String compressToUTF16(String input) {
        if (input == null)
            return '';
        String output = '';
        integer c;
        integer current = 0;
        integer status = 0;


        input = LZString.compress(input);

        for (integer i = 0; i < input.length(); i++) {
            c = (integer) input.charAt(i);
            status++;

            if(status == 0) {
                output += getASCIIValue(((c >> 1) + 32));
                current = (c & 1) << 14;
            }
            else if(status == 1) {
                output += getASCIIValue(((current + (c >> 2)) + 32));
                current = (c & 3) << 13;
            }
            else if(status == 2) {
                output += getASCIIValue(((current + (c >> 3)) + 32));
                current = (c & 7) << 12;
            }
            else if(status == 3) {
                output += getASCIIValue(((current + (c >> 4)) + 32));
                current = (c & 15) << 11;
            }
            else if(status == 4) {
                output += getASCIIValue(((current + (c >> 5)) + 32));
                current = (c & 31) << 10;
            }
            else if(status == 5) {
                output += getASCIIValue(((current + (c >> 6)) + 32));
                current = (c & 63) << 9;
            }
            else if(status == 6) {
                output += getASCIIValue(((current + (c >> 7)) + 32));
                current = (c & 127) << 8;
            }
            else if(status == 7) {
                output += getASCIIValue(((current + (c >> 8)) + 32));
                current = (c & 255) << 7;
            }
            else if(status == 8) {
                output += getASCIIValue(((current + (c >> 9)) + 32));
                current = (c & 511) << 6;
            }
            else if(status == 9) {
                output += getASCIIValue(((current + (c >> 10)) + 32));
                current = (c & 1023) << 5;
            }
            else if(status == 10) {
                output += getASCIIValue(((current + (c >> 11)) + 32));
                current = (c & 2047) << 4;
            }
            else if(status == 11) {
                output += getASCIIValue(((current + (c >> 12)) + 32));
                current = (c & 4095) << 3;
            }
            else if(status == 12) {
                output += getASCIIValue(((current + (c >> 13)) + 32));
                current = (c & 8191) << 2;
            }
            else if(status == 13) {
                output += getASCIIValue(((current + (c >> 14)) + 32));
                current = (c & 16383) << 1;
            }
            else if(status == 14) {
                output += getASCIIValue(((current + (c >> 15)) + 32));
                output += getASCIIValue(((c & 32767) + 32));

                status = 0;
            }else {

            }
        }

        output += getASCIIValue(current + 32);

        return output;
    }

    public static String decompressFromUTF16(String input) {
        if (input == null)
            return '';

        String output = '';
        Integer current = 0, c, status = 0, i = 0;
        while (i < input.length()) {
            c = (((Integer) input.charAt(i)) - 32);

            status++;
            if (status == 0) {
                current = c << 1;
            } else if (status == 1) {
                output += getASCIIValue((current | (c >> 14)));
                current = (c & 16383) << 2;
            } else if (status == 2) {
                output += getASCIIValue((current | (c >> 13)));
                current = (c & 8191) << 3;
            } else if (status == 3) {
                output += getASCIIValue((current | (c >> 12)));
                current = (c & 4095) << 4;
            } else if (status == 4) {
                output += getASCIIValue((current | (c >> 11)));
                current = (c & 2047) << 5;
            } else if (status == 5) {
                output += getASCIIValue((current | (c >> 10)));
                current = (c & 1023) << 6;
            } else if (status == 6) {
                output += getASCIIValue((current | (c >> 9)));
                current = (c & 511) << 7;
            } else if (status == 7) {
                output += getASCIIValue((current | (c >> 8)));
                current = (c & 255) << 8;
            } else if (status == 8) {
                output += getASCIIValue((current | (c >> 7)));
                current = (c & 127) << 9;
            } else if (status == 9) {
                output += getASCIIValue((current | (c >> 6)));
                current = (c & 63) << 10;
            } else if (status == 10) {
                output += getASCIIValue((current | (c >> 5)));
                current = (c & 31) << 11;
            } else if (status == 11) {
                output += getASCIIValue((current | (c >> 4)));
                current = (c & 15) << 12;
            } else if (status == 12) {
                output += getASCIIValue((current | (c >> 3)));
                current = (c & 7) << 13;
            } else if (status == 13) {
                output += getASCIIValue((current | (c >> 2)));
                current = (c & 3) << 14;
            } else if (status == 14) {
                output += getASCIIValue((current | (c >> 1)));
                current = (c & 1) << 15;
            } else if (status == 15) {
                output += getASCIIValue((current | c));
                status = 0;
            }

            i++;
        }

        System.debug('UTF16' + output);
        return LZString.decompress(output);
    }

    private static String getASCIIValue(integer cInteger){
        return String.fromCharArray(new Integer[]{cInteger});
    }

    public static String compressToBase64(String input) {
        return encode64(compress(input));
    }

    public static String decompressFromBase64(String input) {
        return LZString.decompress(decode64(input));
    }

    public static String decode64(String input) {

        //return String.valueOf(EncodingUtil.base64Decode(EncodingUtil.urlEncode(input, 'utf-8')).toString());
        String str = '';

        integer ol = 0;
        integer output_1=0;
        integer chr1, chr2, chr3;
        integer enc1, enc2, enc3, enc4;
        integer i = 0;
        integer j=0;

        while (i < input.length()) {

            enc1 = keyStr.indexOf(String.fromCharArray(new Integer[]{input.charAt(i++)}));
            enc2 = keyStr.indexOf(String.fromCharArray(new Integer[]{input.charAt(i++)}));
            enc3 = keyStr.indexOf(String.fromCharArray(new Integer[]{input.charAt(i++)}));
            enc4 = keyStr.indexOf(String.fromCharArray(new Integer[]{input.charAt(i++)}));

            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;

            if (Math.mod(ol, 2)==0) {
                output_1 = chr1 << 8;

                if (enc3 != 64) {
                    //str.append((char) (output_1 | chr2));
                    str += String.fromCharArray(new Integer[]{output_1 | chr2});
                }
                if (enc4 != 64) {
                    output_1 = chr3 << 8;
                }
            } else {
                //str.append((char) (output_1 | chr1));
                str +=  String.fromCharArray(new Integer[]{output_1 | chr1});

                if (enc3 != 64) {
                    output_1 = chr2 << 8;
                }
                if (enc4 != 64) {
                    str += String.fromCharArray(new Integer[]{output_1 | chr3});
                }
            }
            ol+=3;
        }

        return str;
    }

    public static String encode64(String input) {
        return EncodingUtil.base64Encode(Blob.valueOf(input));
    }


    class Data {
        public integer val;
        public String dataString;
        public integer position;
        public integer index;
    }
    private static Data getNewDataInsance(){
        return new Data();
    }
}