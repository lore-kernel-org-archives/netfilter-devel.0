From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: MARK targets all non-terminating
Date: Tue, 2 Jan 2007 18:44:19 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
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

Hi,


I'll keep it terse: why are xt_MARK, xt_CONNMARK and friends all using 
XT_CONTINUE instead of NF_DROP? It makes it particularly hard to write 
classification:

-t mangle -A POSTROUTING -d 134.76.0.0/16 -j CLASSIFY --set-class 1:10
-t mangle -A POSTROUTING -p tcp -j CLASSIFY --set-class 1:11

Will mark all TCP traffic to 134.76.0.0/16 as 1:11 instead of 1:10. 
Instead, one needs to fiddle and fiddle and end up with:

-t mangle -N class10
-t mangle -A class10 -j CLASSIFY --set-class 1:10
-t mangle -N class11
-t mangle -A class11 -j CLASSIFY --set-class 1:11

-t mangle -A POSTROUTING -d 134.76.0.0/16 -g class10
-t mangle -A POSTROUTING -p tcp -g class11

This non-terminating behavior of [file list] is _NOT_ documented in the 
iptables manpage. Is it even intended at all?


[file list:]
18:37 ichi:../net/netfilter > grep XT_CONTINUE *.c
xt_CLASSIFY.c:  return XT_CONTINUE;
xt_CONNMARK.c:  return XT_CONTINUE;
xt_CONNSECMARK.c:       return XT_CONTINUE;
xt_MARK.c:      return XT_CONTINUE;
xt_MARK.c:      return XT_CONTINUE;
xt_NOTRACK.c:           return XT_CONTINUE;
xt_NOTRACK.c:   return XT_CONTINUE;
xt_SECMARK.c:   return XT_CONTINUE;

ipt_TOS.c:    return IPT_CONTINUE;
ipt_TTL.c:    return IPT_CONTINUE;
(and to a certain degree ipt_TCPMSS, possibly others)


	-`J'
-- 
