From: Ulrich Weber <uweber@astaro.com>
Subject: [RFC PATCH] nfqueue: nf_conntrack_confirm race condition
Date: Fri, 19 Nov 2010 10:58:50 +0100
Message-ID: <4CE64A5A.4010707@astaro.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020204080408020404010007"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exsmtpd002-2.dex002.intermedia.net ([64.78.19.134]:24446 "EHLO
	EXSMTPD002-2.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614Ab0KSKOG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Nov 2010 05:14:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020204080408020404010007
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

Hi,

glibc 2.9 implement parallel IPv4/IPv6 DNS lookup. This caused lots of
trouble
in all kind of implementations, so all major Linux distributions removed
_nss_dns_gethostbyname4_r in their glibc version, except for Debian Squeeze,
see also "options single-request" for more information.

Normally parallel DNS lookups works fine, first packet is received and
forwarded, so conntrack is confirmed before second packet is received.

However in combination with NFQUEUE, the second DNS requests is
received while the first one is still in the queue and both DNS requests
have an unconfirmed conntrack. So the second one will be dropped
in nf_conntrack_confirm, which results in an DNS timeout and retransmit.

Can be reproduced with: adnshost yahoo.com google.com

My first idea was to re-lookup the conntrack in nf_conntrack_confirm,
but at that time the seconds request was already NATed. So I moved
that code to nf_nat_fn(). Of course this only works if nat is loaded...

Any comments or ideas, how to address this problem?

Cheers
Ulrich

-- 
Ulrich Weber | uweber@astaro.com | Software Engineer
Astaro GmbH & Co. KG | www.astaro.com | Phone +49-721-25516-0 | Fax –200
An der RaumFabrik 33a | 76227 Karlsruhe | Germany


--------------020204080408020404010007
Content-Type: text/x-patch;
 name="nat-relookup-unconfirmed-UDP-conntracks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nat-relookup-unconfirmed-UDP-conntracks.patch"

>From 2f23d860cd34a006cf4a118536340d8cfcc0d8fa Mon Sep 17 00:00:00 2001
From: Ulrich Weber <uweber@astaro.com>
Date: Tue, 9 Nov 2010 16:03:08 +0100
Subject: [PATCH] nat: re-lookup unconfirmed UDP conntracks

glibc 2.9 implemented DNS IPv4-IPv6 parallel lookup,
where two DNS requests will be send at once with the
same tuple information.

Due nfqueue the second request will have another conntrack
because the first is not confirmed yet and the second
request will be dropped by conntrack_confirm afterwards.

To avoid an DNS timeout, re-lookup the conntrack
in nf_nat_fn and attach the real one...

Signed-off-by: Ulrich Weber <uweber@astaro.com>
---
 net/ipv4/netfilter/nf_nat_standalone.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 5f41d01..06ef2c5 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -124,6 +124,17 @@ nf_nat_fn(unsigned int hooknum,
 		}
 		/* Fall thru... (Only ICMPs can be IP_CT_IS_REPLY) */
 	case IP_CT_NEW:
+		/* Nasty asynchronous DNS hack: Avoid NAT and conntrack_confirm race */
+		if (!nf_ct_is_confirmed(ct) && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
+		    ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum == IPPROTO_UDP) {
+			struct nf_conntrack_tuple_hash *h = nf_conntrack_find_get(nf_ct_net(ct),
+					&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+			if (h) {
+				ct = nf_ct_tuplehash_to_ctrack(h);
+				nf_conntrack_put(skb->nfct);
+				skb->nfct = &ct->ct_general;
+			}
+		}
 
 		/* Seen it before?  This can happen for loopback, retrans,
 		   or local packets.. */
-- 
1.7.1


--------------020204080408020404010007--
