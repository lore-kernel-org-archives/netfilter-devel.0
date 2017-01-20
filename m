From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [nft PATCH] payload: use explicit network ctx assignation for
 icmp/icmp6 in inet family
Date: Fri, 20 Jan 2017 13:20:11 +0100
Message-ID: <148491481186.20302.13599222282579510532.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43818 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751875AbdATMsF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Jan 2017 07:48:05 -0500
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id AD23F51F3AA
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2017 12:20:18 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KHAq3v8XvdC2 for <netfilter-devel@vger.kernel.org>;
        Fri, 20 Jan 2017 13:20:12 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id D128051F398
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2017 13:20:12 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In the inet family, we can add rules like these:

% nft add rule inet t c ip protocol icmp icmp type echo-request
% nft add rule inet t c ip6 nexthdr icmpv6 icmpv6 type echo-request

However, when we print the ruleset:

% nft list ruleset
table inet t {
	chain c {
		icmpv6 type echo-request
		icmp type echo-request
	}
}

These rules we obtain can't be added again:

% nft add rule inet t c icmp type echo-request
<cmdline>:1:19-27: Error: conflicting protocols specified: inet-service vs. icmp
add rule inet t c icmp type echo-request
                  ^^^^^^^^^

% nft add rule inet t c icmpv6 type echo-request
<cmdline>:1:19-29: Error: conflicting protocols specified: inet-service vs. icmpv6
add rule inet t c icmpv6 type echo-request
                  ^^^^^^^^^^^

Since I wouldn't expect an IP packet carrying ICMPv6, or IPv6 packet
carrying ICMP, if the link layer is inet, the network layer protocol context
can be safely update to 'ip' or 'ip6'.

Moreover, nft currently generates a 'meta nfproto ipvX' depedency when
using icmp or icmp6 in the inet family.

Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1073
Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 src/payload.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index af533b2..9cca838 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -284,7 +284,12 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				desc = &proto_inet;
 				break;
 			case PROTO_BASE_TRANSPORT_HDR:
-				desc = &proto_inet_service;
+				if (expr->payload.desc == &proto_icmp)
+					desc = &proto_ip;
+				else if (expr->payload.desc == &proto_icmp6)
+					desc = &proto_ip6;
+				else
+					desc = &proto_inet_service;
 				break;
 			default:
 				break;

