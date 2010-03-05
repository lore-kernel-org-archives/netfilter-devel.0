From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: libnetfilter_conntrack alignment issue [was Re: [PATCH 1/2] Add new
 input plugin UNIXSOCK]
Date: Fri, 05 Mar 2010 11:25:05 +0100
Message-ID: <4B90DC01.3050306@netfilter.org>
References: <1267217680-22677-1-git-send-email-chifflier@edenwall.com> <1267217680-22677-2-git-send-email-chifflier@edenwall.com> <4B892440.7030002@netfilter.org> <20100228140655.GC16135@piche.inl.fr> <4B8A99B6.5080708@netfilter.org> <20100228180505.GD16135@piche.inl.fr> <4B8C16A4.9010807@netfilter.org> <alpine.LSU.2.01.1003031841130.23267@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010306080808000409080804"
Cc: Pierre Chifflier <chifflier@edenwall.com>,
	netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47962 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab0CEKZS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Mar 2010 05:25:18 -0500
In-Reply-To: <alpine.LSU.2.01.1003031841130.23267@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010306080808000409080804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> On Monday 2010-03-01 20:33, Pablo Neira Ayuso wrote:
> 
>>>>>>> +#define ALIGN_SIZE 8
>>>>>> Minor question: why align this to 64 bits?
>>>>> I originally used an alignment to 32 bits, but Jan noticed it would
>>>>> break if using options/values on 64 bits (and a test confirmed that). I
>>>>> took 64 bits as the biggest allowed value for integers.
>>>> I would need to look into this in more detail, not sure where the
>>>> problem is. I think that you can use something like `struct nlattr' (see
>>>> include/linux/netlink.h) and then nla_put() to add attributes in the TLV
>>>> format (see lib/nlattr.c). Those are align-safe. I'm using something
>>>> similar for conntrackd for the synchronization messages (src/build.c and
>>>> src/parse.c).
> 
> If they are align-safe, what's this? :-)

Could you tell me where did I say that libnetfilter_conntrack is using
those functions that I recommended?

> 18:41 ares:/home/jengelh # conntrack -L
> Bus error
> 18:41 ares:/home/jengelh # file `which conntrack`
> /usr/sbin/conntrack: ELF 32-bit MSB executable, SPARC32PLUS, V8+ Required,
> version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.4,
> not stripped

The following patch should fix the problem that you are reporting. Let
me know if you have more issues.

--------------010306080808000409080804
Content-Type: text/x-patch;
 name="fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix.patch"

parse: fix access to u64 attributes in netlink messages

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch fixes parsing of 64 bits attributes (that are unaligned)
in ctnetlink. It would be better to add nfnl_get_uX() functions
similar to those in include/net/netlink.h to libnfnetlink to avoid
this sort of errors.

Reported-by: Jan Engelhardt <jengelh@medozas.es>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack/parse.c |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/src/conntrack/parse.c b/src/conntrack/parse.c
index 0e0cd58..60dabe4 100644
--- a/src/conntrack/parse.c
+++ b/src/conntrack/parse.c
@@ -276,9 +276,11 @@ static void __parse_protoinfo_dccp(const struct nfattr *attr,
 		set_bit(ATTR_DCCP_ROLE, ct->set);
 	}
 	if (tb[CTA_PROTOINFO_DCCP_SEQ-1]) {
-		ct->protoinfo.dccp.handshake_seq =
-			__be64_to_cpu(*(u_int64_t *)
-				NFA_DATA(tb[CTA_PROTOINFO_DCCP_SEQ-1]));
+		u_int64_t tmp;
+		memcpy(&tmp,
+		       NFA_DATA(tb[CTA_PROTOINFO_DCCP_SEQ-1]),
+		       sizeof(tmp));
+		ct->protoinfo.dccp.handshake_seq = __be64_to_cpu(tmp);
 		set_bit(ATTR_DCCP_HANDSHAKE_SEQ, ct->set);
 	}
 }
@@ -314,10 +316,13 @@ static void __parse_counters(const struct nfattr *attr,
 				= ntohl(*(u_int32_t *)
 					NFA_DATA(tb[CTA_COUNTERS32_PACKETS-1]));
 
-		if (tb[CTA_COUNTERS_PACKETS-1])
-			ct->counters[dir].packets
-				= __be64_to_cpu(*(u_int64_t *)
-					NFA_DATA(tb[CTA_COUNTERS_PACKETS-1]));
+		if (tb[CTA_COUNTERS_PACKETS-1]) {
+			u_int64_t tmp;
+			memcpy(&tmp,
+			       NFA_DATA(tb[CTA_COUNTERS_PACKETS-1]),
+			       sizeof(tmp));
+			ct->counters[dir].packets = __be64_to_cpu(tmp);
+		}
 
 		switch(dir) {
 		case __DIR_ORIG:
@@ -335,10 +340,13 @@ static void __parse_counters(const struct nfattr *attr,
 				= ntohl(*(u_int32_t *)
 					NFA_DATA(tb[CTA_COUNTERS32_BYTES-1]));
 
-		if (tb[CTA_COUNTERS_BYTES-1])
-			ct->counters[dir].bytes
-				= __be64_to_cpu(*(u_int64_t *)
-					NFA_DATA(tb[CTA_COUNTERS_BYTES-1]));
+		if (tb[CTA_COUNTERS_BYTES-1]) {
+			u_int64_t tmp;
+			memcpy(&tmp,
+			       NFA_DATA(tb[CTA_COUNTERS_BYTES-1]),
+			       sizeof(tmp));
+			ct->counters[dir].bytes = __be64_to_cpu(tmp);
+		}
 
 		switch(dir) {
 		case __DIR_ORIG:

--------------010306080808000409080804--
