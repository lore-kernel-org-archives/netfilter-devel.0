From: Junnu <puska@netics.fi>
Subject: Very strange problems with some websites (kernel 2.4.19 .. 2.4.20pre9)
Date: Mon, 21 Oct 2002 22:17:49 +0300 (EEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200210211917.g9LJHo323518@netics.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello developers!

Have you been heard, that using kernel 2.4.19 - 2.4.20pre9 with all the netfilter
modules compiled (with several different hardware combination and ISP's) you cannot
connect to these web sites:

www.sas.se
www.nvidia.com
www.echelon.com

and some others, but those I have been used as "test sites".

If I look all the packets generated, it looks like normal, but nothing are returning.

Feel free and try, I use lynx on tests.

It does not give any kind of reasonable explanations, even if I don't load
any iptables commands or if I am using computer behind firewall (NATed).

For example www.sas.se (my computer is 10.100.3.10 and it is located behind the fw)

1) name from dns, two packets:
dns question
0000  00 01 02 e8 74 a0 00 01  02 fa 42 04 08 00 45 00   ....t... ..B...E.
0010  00 38 10 90 40 00 40 11  d6 b6 0a 64 03 0a c2 fb   .8..@.@. ...d....
0020  83 05 80 00 00 35 00 24  00 df e2 d7 01 00 00 01   .....5.$ ........
0030  00 00 00 00 00 00 03 77  77 77 03 73 61 73 02 73   .......w ww.sas.s
0040  65 00 00 01 00 01                                  e.....           

and dns reply
0000  00 01 02 fa 42 04 00 01  02 e8 74 a0 08 00 45 00   ....B... ..t...E.
0010  00 bd e7 40 00 00 7c 11  03 81 c2 fb 83 05 0a 64   ...@..|. .......d
0020  03 0a 00 35 80 00 00 a9  b0 60 e2 d7 81 80 00 01   ...5.... .`......
0030  00 02 00 03 00 02 03 77  77 77 03 73 61 73 02 73   .......w ww.sas.s
0040  65 00 00 01 00 01 c0 0c  00 05 00 01 00 00 01 2c   e....... .......,
0050  00 0d 04 68 6f 6d 65 03  73 61 73 02 64 6b 00 c0   ...home. sas.dk..
0060  28 00 01 00 01 00 00 01  2c 00 04 c2 b6 f9 71 c0   (....... ,.....q.
0070  2d 00 02 00 01 00 00 01  2c 00 0c 03 73 61 73 03   -....... ,...sas.
0080  73 61 73 02 6e 6f 00 c0  2d 00 02 00 01 00 00 01   sas.no.. -.......
0090  2c 00 06 03 73 61 73 c0  10 c0 2d 00 02 00 01 00   ,...sas. ..-.....
00a0  00 01 2c 00 06 03 73 61  73 c0 2d c0 51 00 01 00   ..,...sa s.-.Q...
00b0  01 00 01 15 b8 00 04 c1  d7 f2 82 c0 69 00 01 00   ........ ....i...
00c0  01 00 00 17 1c 00 04 c3  a3 8c 56                  ........ ..V 

2) then my computer sends question to home.sas.dk

0000  00 01 02 e8 74 a0 00 01  02 fa 42 04 08 00 45 00   ....t... ..B...E.
0010  00 3c 7b 1a 40 00 40 06  f6 0b 0a 64 03 0a c2 b6   .<{.@.@. ...d....
0020  f9 71 80 37 00 50 08 2e  6b 89 00 00 00 00 a0 c2   .q.7.P.. k.......
0030  16 d0 62 0c 00 00 02 04  05 b4 04 02 08 0a 00 03   ..b..... ........
0040  10 93 00 00 00 00 01 03  03 00                     ........ ..      

but, that's all, it does not never get any reply? If I change kernel to version
2.2.19 all works ok. Also any other site works ok. So if you have any kind of glue
or whatever, I will be happy to open this very tricky situation!!!!

I am not anymore on this list, so if someone have any kind of information about it
please mail direct to me!

Kernel was 2.4.20pre9, and I have quite normal PIII/700 with IDE disks etc, network card
is 3C905, but it did not change the situation. I have another server, which has PIII/1.3G
and 1GB network cards, and the result is the same.

Also kernel has every netfilter module, but no ipchains stuff.
--
	-junnu

PS This might be kernel problem, but I am not sure. If you know who might know more, please
tell me!
