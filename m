From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: ip_tables.c: mark_source_chains: bad negative verdict
Date: Fri, 20 Jul 2007 17:25:50 +0200
Message-ID: <200707201725.50459.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_+PNoGim3p+WBLCl"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--Boundary-00=_+PNoGim3p+WBLCl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello there,

I've upgraded to kernel 2.6.21.6 / iptables 1.3.7 and now a big firewall table 
fails to load. The error message from the iptables command is
"iptables: Too many levels of symbolic links", so I've enabled debugging in 
net/ipv4/netfilter/ip_tables.c. Here's the debug output from it
after trying to run "iptables -A C70 -j forward_ok":

Jul 20 17:11:12 intratest2 kernel: t->private->number = 1425
Jul 20 17:11:12 intratest2 kernel: translate_table: size 282700
Jul 20 17:11:12 intratest2 kernel: Jump rule 148 -> 241392
Jul 20 17:11:12 intratest2 kernel: Jump rule 241392 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 249836 -> 219892
Jul 20 17:11:12 intratest2 kernel: Jump rule 241620 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 241848 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 193672 -> 67868
Jul 20 17:11:12 intratest2 kernel: Jump rule 193968 -> 109528
Jul 20 17:11:12 intratest2 kernel: Jump rule 112796 -> 33232
Jul 20 17:11:12 intratest2 kernel: Jump rule 112944 -> 33232
Jul 20 17:11:12 intratest2 kernel: Jump rule 113092 -> 33232
Jul 20 17:11:12 intratest2 kernel: Jump rule 113240 -> 33232
Jul 20 17:11:12 intratest2 kernel: Jump rule 113388 -> 33232
Jul 20 17:11:12 intratest2 kernel: Jump rule 113536 -> 33232
Jul 20 17:11:12 intratest2 kernel: Jump rule 113684 -> 33232
Jul 20 17:11:12 intratest2 kernel: Jump rule 113832 -> 33232
Jul 20 17:11:12 intratest2 kernel: Jump rule 241996 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 248980 -> 219892
Jul 20 17:11:12 intratest2 kernel: Jump rule 636 -> 237532
Jul 20 17:11:12 intratest2 kernel: Jump rule 237720 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 237948 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 238176 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 238436 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 238696 -> 250692
Jul 20 17:11:12 intratest2 kernel: Jump rule 250692 -> 219892
Jul 20 17:11:12 intratest2 kernel: Jump rule 239088 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 239236 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 239384 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 239532 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 239680 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 239828 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 239976 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 240124 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 240272 -> 134440
Jul 20 17:11:12 intratest2 kernel: Jump rule 240488 -> 137860
Jul 20 17:11:12 intratest2 kernel: Jump rule 240704 -> 147036
Jul 20 17:11:12 intratest2 kernel: Jump rule 240920 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 852 -> 235384
Jul 20 17:11:12 intratest2 kernel: Jump rule 235768 -> 252404
Jul 20 17:11:12 intratest2 kernel: Jump rule 253588 -> 237532
Jul 20 17:11:12 intratest2 kernel: Jump rule 235984 -> 242468
Jul 20 17:11:12 intratest2 kernel: Jump rule 242468 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 242696 -> 249836
Jul 20 17:11:12 intratest2 kernel: Jump rule 242924 -> 248656
Jul 20 17:11:12 intratest2 kernel: Jump rule 243072 -> 217916
Jul 20 17:11:12 intratest2 kernel: Jump rule 243300 -> 4712
Jul 20 17:11:12 intratest2 kernel: Jump rule 4712 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 4860 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 243448 -> 5332
Jul 20 17:11:12 intratest2 kernel: Jump rule 5332 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 5480 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 243596 -> 12152
Jul 20 17:11:12 intratest2 kernel: Jump rule 12152 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 12300 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 243744 -> 18972
Jul 20 17:11:12 intratest2 kernel: Jump rule 18972 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 19120 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 243892 -> 25792
Jul 20 17:11:12 intratest2 kernel: Jump rule 25792 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 25940 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 244040 -> 32612
Jul 20 17:11:12 intratest2 kernel: Jump rule 32612 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 32760 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 244188 -> 49692
Jul 20 17:11:12 intratest2 kernel: Jump rule 49692 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 49840 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 244336 -> 69672
Jul 20 17:11:12 intratest2 kernel: Jump rule 69672 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 69820 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 244484 -> 88388
Jul 20 17:11:12 intratest2 kernel: Jump rule 88388 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 88536 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 244632 -> 107104
Jul 20 17:11:12 intratest2 kernel: Jump rule 107104 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 107252 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 244780 -> 5952
Jul 20 17:11:12 intratest2 kernel: Jump rule 5952 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 6100 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 244928 -> 6572
Jul 20 17:11:12 intratest2 kernel: Jump rule 6572 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 6720 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 245076 -> 7192
Jul 20 17:11:12 intratest2 kernel: Jump rule 7192 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 7340 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 245224 -> 7812
Jul 20 17:11:12 intratest2 kernel: Jump rule 7812 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 7960 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 245372 -> 8432
Jul 20 17:11:12 intratest2 kernel: Jump rule 8432 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 8580 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 245520 -> 9052
Jul 20 17:11:12 intratest2 kernel: Jump rule 9052 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 9200 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 245668 -> 9672
Jul 20 17:11:12 intratest2 kernel: Jump rule 9672 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 9820 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 245816 -> 10292
Jul 20 17:11:12 intratest2 kernel: Jump rule 10292 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 10440 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 245964 -> 10912
Jul 20 17:11:12 intratest2 kernel: Jump rule 10912 -> 109528
Jul 20 17:11:12 intratest2 kernel: Jump rule 11060 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 246112 -> 11532
Jul 20 17:11:12 intratest2 kernel: Jump rule 11532 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 11680 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 246260 -> 12772
Jul 20 17:11:12 intratest2 kernel: Jump rule 12772 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 12920 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 246408 -> 13392
Jul 20 17:11:12 intratest2 kernel: Jump rule 13392 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 13540 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 246556 -> 14012
Jul 20 17:11:12 intratest2 kernel: Jump rule 14012 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 14160 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 246704 -> 14632
Jul 20 17:11:12 intratest2 kernel: Jump rule 14632 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 14780 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 246852 -> 15252
Jul 20 17:11:12 intratest2 kernel: Jump rule 15252 -> 193132
Jul 20 17:11:12 intratest2 kernel: Jump rule 15400 -> 248980
Jul 20 17:11:12 intratest2 kernel: Jump rule 247000 -> 109528
Jul 20 17:11:12 intratest2 kernel: Jump rule 247148 -> 109528
Jul 20 17:11:12 intratest2 kernel: Jump rule 247296 -> 109528
Jul 20 17:11:12 intratest2 kernel: Jump rule 247444 -> 109528
Jul 20 17:11:12 intratest2 kernel: Jump rule 247592 -> 109528
Jul 20 17:11:12 intratest2 kernel: Jump rule 247740 -> 109528
Jul 20 17:11:12 intratest2 kernel: Jump rule 247888 -> 109528
Jul 20 17:11:12 intratest2 kernel: Jump rule 248036 -> 109528
Jul 20 17:11:13 intratest2 kernel: Jump rule 248184 -> 248980
Jul 20 17:11:13 intratest2 kernel: Jump rule 1000 -> 237532
Jul 20 17:11:13 intratest2 kernel: Jump rule 1216 -> 248980
Jul 20 17:11:13 intratest2 kernel: Finished chain 1
Jul 20 17:11:13 intratest2 kernel: Jump rule 1512 -> 224536
Jul 20 17:11:13 intratest2 kernel: Jump rule 224536 -> 249836
Jul 20 17:11:13 intratest2 kernel: Jump rule 249836 -> 219892
Jul 20 17:11:13 intratest2 kernel: Jump rule 224764 -> 249836
Jul 20 17:11:13 intratest2 kernel: Jump rule 224992 -> 194440
Jul 20 17:11:13 intratest2 kernel: Jump rule 194440 -> 70292
Jul 20 17:11:13 intratest2 kernel: Jump rule 71624 -> 232340
Jul 20 17:11:13 intratest2 kernel: Jump rule 232340 -> 232960
Jul 20 17:11:13 intratest2 kernel: Jump rule 232960 -> 215940
Jul 20 17:11:13 intratest2 kernel: Jump rule 233176 -> 215940
Jul 20 17:11:13 intratest2 kernel: mark_source_chains: bad negative verdict 
(-2140522486)

How can the "bad negative verdict" code be triggered?
How can it be fixed? :-)

I was unable to cook up a minimalistic test case,
so I've attached the complete firewall ruleset.

Any help is appreciated.

Thanks in advance,
Thomas

--Boundary-00=_+PNoGim3p+WBLCl
Content-Type: application/x-gzip;
  name="iptables.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="iptables.gz"

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

--Boundary-00=_+PNoGim3p+WBLCl--
