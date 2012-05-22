From: Jagdish Motwani <jagdish.motwani@elitecore.com>
Subject: [PATCH] netfilter conntrack helper: nf_ct_h323: fix bug in rtcp natting
Date: Tue, 22 May 2012 11:30:27 +0530
Message-ID: <4FBB2B7B.6060907@elitecore.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060200060603060308070607"
Cc: netfilter-devel@vger.kernel.org
To: 'Patrick McHardy' <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:41414 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014Ab2EVGCR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 May 2012 02:02:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060200060603060308070607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The nat_rtp_rtcp hook takes two separate parameters port and rtp_port.

port is expected to be the real h245 address(found inside the packet).
rtp_port is the even number closest to port  (RTP ports are even and 
RTCP ports are odd)

However currently, both port and rtp_port are having same value(both are 
rounded to nearest even numbers).

This works well in case of openlogicalchannel with media (RTP/even) port.

But in case of openlogicalchannel for media control (RTCP/odd) port, 
h245 address in the packet is wrongly modified to have an even port.

I am attaching a pcap demonstrating the problem, for any further analysis.

This behavior was introduced around v2.6.19 while rewriting the helper.



Signed-off-by: Jagdish Motwani <jagdish.motwani@elitecore.com>
Signed-off-by: Sanket Shah <sanket.shah@elitecore.com>

--
diff --git a/net/netfilter/nf_conntrack_h323_main.c 
b/net/netfilter/nf_conntrack_h323_main.c
index 46d69d7..7f0de36 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -270,9 +270,8 @@ static int expect_rtp_rtcp(struct sk_buff *skb, 
struct nf_conn *ct,
                 return 0;

         /* RTP port is even */
-       port &= htons(~1);
-       rtp_port = port;
-       rtcp_port = htons(ntohs(port) + 1);
+       rtp_port = port & htons(~1);
+       rtcp_port = htons(ntohs(rtp_port) + 1);

         /* Create expect for RTP */
         if ((rtp_exp = nf_ct_expect_alloc(ct)) == NULL)


--------------060200060603060308070607
Content-Type: application/x-pcap;
 name="rtcp_nat_bug.pcap"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rtcp_nat_bug.pcap"

1MOyoQIABAAAAAAAAAAAAP//AABxAAAAKJhYTg/wDQC+AAAAvgAAAAAAAAEABkSH/E6xEAAA
CABFAACuHbhAAIAGDgMKFBYFrBACZga4D6blwiZKt0uWTFAYgCSSMwAAAwAAhggCy0sHBASI
GIalKBFyYW5ha3VtYXIuc2hhcm1hAH4AYQUiwAYACJFKAAYAChQWBQ+jIsBZAERMD0R5bG9n
aWMgTWlyaWFsAAAHNy4wLjUxAAAAxJuD3/sEGRCFQfRtBNRpfxcMIBEAxJuD3/sEGRCFQPRt
BNRpfwEAAQABAAKAAQAomFhOy/INAL4AAAC+AAAAAAQAAQAGABDzCYlKAAAIAEUAAK4duEAA
fwaAqawQAmKsEAJmBrgPpuXCJkq3S5ZMUBiAJHWAAAADAACGCALLSwcEBIgYhqUoEXJhbmFr
dW1hci5zaGFybWEAfgBhBSLABgAIkUoABgCsEAJiD6MiwFkAREwPRHlsb2dpYyBNaXJpYWwA
AAc3LjAuNTEAAADEm4Pf+wQZEIVB9G0E1Gl/FwwgEQDEm4Pf+wQZEIVA9G0E1Gl/AQABAAEA
AoABACiYWE7yZw4AUgAAAFIAAAAAAAABAAZEh/xOsRAAAAgARQAAQh3CQACABg5lChQWBawQ
AmYPow+nWNz/il0V7mRQGIASKV0AAAMAABoDAABmEGNAGQCACwxA4AAKFBYFD7fwKJhYTlNo
DgBSAAAAUgAAAAAEAAEABgAQ8wmJSgAACABFAABCHcJAAH8GgQusEAJirBACZg+jD6dY3P+K
XRXuZFAYgBJCdQAAAwAAGgMAAGYQY0AZAIALDEDgAKwQAmIPtvA=
--------------060200060603060308070607--
