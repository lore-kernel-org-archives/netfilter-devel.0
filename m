From: "zhangxiliang" <zhangxiliang@cn.fujitsu.com>
Subject: The "value" of "-m dscp -dscp" for iptables command
Date: Thu, 23 Aug 2007 13:17:09 +0800
Message-ID: <029301c7e544$daf47860$3f8da70a@zhangxiliang>
To: <netfilter-devel@lists.netfilter.org>
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

Hello,

    I find a bug in the manpage of iptables:
    The description for the value in option "-m dscp -dscp" should be
modified to 0~63.

    The option can match 6 bit DSCP field within the TOS field in the IP
header.
    So the range for the option should be 0~(2^6-1)£¬that is 0~63.

    1) use "iptables -m dscp --dscp 63" :
         1. iptables -A INPUT -m dscp --dscp 63
         2. iptables -L INPUT | grep "DSCP match 0x3f"

    I have made a patch for the manpage of the iptables-1.3.5-1.2.1.

    The content of the patch:

diff -ru iptables-1.3.5.org/extensions/libipt_dscp.man 
iptables-1.3.5/extensions/libipt_dscp.man
--- iptables-1.3.5.org/extensions/libipt_dscp.man 2007-08-01 
20:29:03.000000000 +0800
+++ iptables-1.3.5/extensions/libipt_dscp.man 2007-08-01 20:30:09.000000000 
+0800
@@ -2,7 +2,7 @@
 IP header.  DSCP has superseded TOS within the IETF.
 .TP
 .BI "--dscp " "value"
-Match against a numeric (decimal or hex) value [0-32].
+Match against a numeric (decimal or hex) value [0-63].
 .TP
 .BI "--dscp-class " "\fIDiffServ Class\fP"
 Match the DiffServ class. This value may be any of the

 Regards
 Zhang Xiliang



begin 666 iptables_dscp.patch
M9&EF9B M<G4@:7!T86)L97,M,2XS+C4N;W)G+V5X=&5N<VEO;G,O;&EB:7!T
M7V1S8W N;6%N(&EP=&%B;&5S+3$N,RXU+V5X=&5N<VEO;G,O;&EB:7!T7V1S
M8W N;6%N"BTM+2!I<'1A8FQE<RTQ+C,N-2YO<F<O97AT96YS:6]N<R]L:6)I
M<'1?9'-C<"YM86X),C P-RTP."TP,2 R,#HR.3HP,RXP,# P,# P,# @*S X
M,# **RLK(&EP=&%B;&5S+3$N,RXU+V5X=&5N<VEO;G,O;&EB:7!T7V1S8W N
M;6%N"3(P,#<M,#@M,#$@,C Z,S Z,#DN,# P,# P,# P("LP.# P"D! ("TR
M+#<@*S(L-R! 0 H@25 @:&5A9&5R+B @1%-#4"!H87,@<W5P97)S961E9"!4
M3U,@=VET:&EN('1H92!)151&+@H@+E10"B N0DD@(BTM9'-C<" B(")V86QU
M92(*+4UA=&-H(&%G86EN<W0@82!N=6UE<FEC("AD96-I;6%L(&]R(&AE>"D@
M=F%L=64@6S M,S)=+@HK36%T8V@@86=A:6YS="!A(&YU;65R:6,@*&1E8VEM
M86P@;W(@:&5X*2!V86QU92!;,"TV,UTN"B N5% *("Y"22 B+2UD<V-P+6-L
M87-S("(@(EQF241I9F9397)V($-L87-S7&90(@H@36%T8V@@=&AE($1I9F93
H97)V(&-L87-S+B!4:&ES('9A;'5E(&UA>2!B92!A;GD@;V8@=&AE"@``
`
end
