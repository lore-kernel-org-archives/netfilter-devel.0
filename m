From: "Thibaut VARENE" <T-Bone@parisc-linux.org>
Subject: [BUG][PATCH] dst cache overflow/leak in br_netfilter.c with ebtables-brnf-11-2_vs_2.4.31 and linux 2.4.36.6
Date: Fri, 15 Aug 2008 01:49:28 +0200
Message-ID: <7d01f9f00808141649r17a508dct364a4e356ad7e970@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_143846_30249016.1218757768179"
To: netfilter-devel@vger.kernel.org, bdschuym@pandora.be
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:46887 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYHNXt3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:49:29 -0400
Received: by wr-out-0506.google.com with SMTP id 69so781787wri.5
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Aug 2008 16:49:28 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

------=_Part_143846_30249016.1218757768179
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Here's a quick email trying to summarize the issue:

Context:
I recently setup an openvpn bridge between a router and a remote
machine, the router running a patched (grsec, ja1, imq2, a couple from
patch-o-matic-ng and ebtables-brnf taken from
http://prdownloads.sourceforge.net/ebtables/ebtables-brnf-11-2_vs_2.4.31.diff.gz)
2.4.36.6 kernel. (This machine has 192MB RAM, and it had been up and
running for over 400 days before I setup the bridge, with the exact
same kernel / iptables rules). Then I set up a couple ebtables rules
to prevent DHCP contamination across the bridge. Each side of the
bridge has its own default gw to the internet, it happens that on one
side, this gateway is the above mentioned router, which thus sees some
traffic (small LAN NATd on a DSL line).

Issue:
Then after a fairly short while after setting up the bridge (a matter
of hours mostly, the more traffic on the router the quicker -
especially quick when one of the machines behind the router was doing
P2P for instance), the 2.4.36-running router would suddenly disappear
from the network, though the machine was still alive and running.
Trying to ping from the router would yield a "ping: sendto: no buffer
space available", and I noticed in the logs and dmesg a fair amount of
"dst cache overflow" messages.

Forensics:
Simply increasing the value of /proc/sys/net/ipv4/route/max_size
brought the networking back to life, but only for another short while
(mostly depending on the size of the new value). A quick check with
Robur's rtstat utility (fetched from
ftp://robur.slu.se/pub/Linux/net-development/rt_cache_stat/rtstat)
basically showed that the rt cache was steadily growing and
practically never came back down, hitting the max_size value and
eventually effectively killing networking on the machine. It was
anyway totally out of touch with the number of entries as reported by
"ip route show cache". And nothing (echo 1 >
/proc/sys/net/ipv4/route/flush, ip route flush cache, flushing
iptables/ebtables rules, bringing iface down/up, etc) would get it
back to normal. Clearly, there was a leak.

Fix(es):
As I was quite on a hurry (I'm taking off on vacation in a few hours
;) I dug around on google, found a couple related reports and fixes
mostly for linux 2.6. I thus tried to "adapt" them to 2.4.36.6, but as
I said I was on a rush so I didn't really know what I was doing.
Still, the following patch (patching the ip_fragment() function, as I
first thought this was a fragmentation-related leak):

diff -ru linux-2.4.36.6.prev/net/ipv4/ip_output.c linux/net/ipv4/ip_output.c
--- linux-2.4.36.6.prev/net/ipv4/ip_output.c	2008-06-06 18:25:34.000000000 +0200
+++ linux/net/ipv4/ip_output.c	2008-08-14 21:39:23.000000000 +0200
@@ -844,6 +844,7 @@

 		if (skb->sk)
 			skb_set_owner_w(skb2, skb->sk);
+		dst_release(skb2->dst);
 		skb2->dst = dst_clone(skb->dst);
 		skb2->dev = skb->dev;


improved things a little bit. Really not much actually, but the rt
cache size figure did come back down a bit more often than before (or
so it seemed). Though the trend remained toward a steady, unstoppable
growth.

But then, this patch, backported from
http://www.ssi.bg/~ja/brnf_dst-2.6.20-1.diff, patching
br_nf_pre_routing_finish():

diff -ru linux-2.4.36.6.prev/net/bridge/br_netfilter.c
linux/net/bridge/br_netfilter.c
--- linux-2.4.36.6.prev/net/bridge/br_netfilter.c	2008-06-06
18:25:34.000000000 +0200
+++ linux/net/bridge/br_netfilter.c	2008-08-15 00:17:56.000000000 +0200
@@ -216,6 +216,10 @@
 	skb->nf_debug ^= (1 << NF_BR_PRE_ROUTING);
 #endif

+	/* Old skb->dst is not expected, it is lost in all cases */
+	dst_release(skb->dst);
+	skb->dst = NULL;
+
 	if (nf_bridge->mask & BRNF_PKT_TYPE) {
 		skb->pkt_type = PACKET_OTHERHOST;
 		nf_bridge->mask ^= BRNF_PKT_TYPE;


really made the whole issue go away.

Note: as my kernel is quite heavily patched already, the above may not
apply perfectly cleanly.

Anyway, given at least the second patch "fixed" the problem as far as
I'm concerned (the first one might not be necessary, didn't check that
yet), I believe that there's a bug in the current ebtables_brnf 2.4
patch and a nasty one at that, since it DOS the machine fairly
quickly. Hope the above explanation/patch make things clear enough and
are anyhow helpful, again, I don't really know what I'm doing ;-)

(I've attached both patches to this email in case gmail gets too smart
with line wrapping)

HTH

T-Bone

PS: please CC-me on replies, I'm not subscribed, and I'll be offline
for the next 4 days.

-- 
Thibaut VARENE
http://www.parisc-linux.org/~varenet/

------=_Part_143846_30249016.1218757768179
Content-Type: application/octet-stream; name=dst_overflow.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjw0ptjd0
Content-Disposition: attachment; filename=dst_overflow.patch

ZGlmZiAtcnUgbGludXgtMi40LjM2LjYucHJldi9uZXQvYnJpZGdlL2JyX25ldGZpbHRlci5jIGxp
bnV4L25ldC9icmlkZ2UvYnJfbmV0ZmlsdGVyLmMKLS0tIGxpbnV4LTIuNC4zNi42LnByZXYvbmV0
L2JyaWRnZS9icl9uZXRmaWx0ZXIuYwkyMDA4LTA2LTA2IDE4OjI1OjM0LjAwMDAwMDAwMCArMDIw
MAorKysgbGludXgvbmV0L2JyaWRnZS9icl9uZXRmaWx0ZXIuYwkyMDA4LTA4LTE1IDAwOjE3OjU2
LjAwMDAwMDAwMCArMDIwMApAQCAtMjE2LDYgKzIxNiwxMCBAQAogCXNrYi0+bmZfZGVidWcgXj0g
KDEgPDwgTkZfQlJfUFJFX1JPVVRJTkcpOwogI2VuZGlmCiAKKwkvKiBPbGQgc2tiLT5kc3QgaXMg
bm90IGV4cGVjdGVkLCBpdCBpcyBsb3N0IGluIGFsbCBjYXNlcyAqLworCWRzdF9yZWxlYXNlKHNr
Yi0+ZHN0KTsKKwlza2ItPmRzdCA9IE5VTEw7CisKIAlpZiAobmZfYnJpZGdlLT5tYXNrICYgQlJO
Rl9QS1RfVFlQRSkgewogCQlza2ItPnBrdF90eXBlID0gUEFDS0VUX09USEVSSE9TVDsKIAkJbmZf
YnJpZGdlLT5tYXNrIF49IEJSTkZfUEtUX1RZUEU7CmRpZmYgLXJ1IGxpbnV4LTIuNC4zNi42LnBy
ZXYvbmV0L2lwdjQvaXBfb3V0cHV0LmMgbGludXgvbmV0L2lwdjQvaXBfb3V0cHV0LmMKLS0tIGxp
bnV4LTIuNC4zNi42LnByZXYvbmV0L2lwdjQvaXBfb3V0cHV0LmMJMjAwOC0wNi0wNiAxODoyNTow
MC4wMDAwMDAwMDAgKzAyMDAKKysrIGxpbnV4L25ldC9pcHY0L2lwX291dHB1dC5jCTIwMDgtMDgt
MTQgMjE6Mzk6MjMuMDAwMDAwMDAwICswMjAwCkBAIC04NDQsNiArODQ0LDcgQEAKIAogCQlpZiAo
c2tiLT5zaykKIAkJCXNrYl9zZXRfb3duZXJfdyhza2IyLCBza2ItPnNrKTsKKwkJZHN0X3JlbGVh
c2Uoc2tiMi0+ZHN0KTsKIAkJc2tiMi0+ZHN0ID0gZHN0X2Nsb25lKHNrYi0+ZHN0KTsKIAkJc2ti
Mi0+ZGV2ID0gc2tiLT5kZXY7CiAK
------=_Part_143846_30249016.1218757768179--
