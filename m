From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
Subject: [PATCH] Out Of Bound Read in Netfilter Conntrack
Date: Mon, 9 Oct 2017 07:01:14 +0200
Message-ID: <804512f5-786b-d4d0-bc8e-299c5c2683bf@x41-dsec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:55738 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751588AbdJIFBY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2017 01:01:24 -0400
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add missing counter decrement to prevent out of bounds memory read.

Signed-off-by: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c
b/net/netfilter/nf_conntrack_h323_asn1.c
index 89b2e46925c4..2a9d1acd0cbd 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -877,6 +877,7 @@ int DecodeQ931(unsigned char *buf, size_t sz, Q931
*q931)
 		if (sz < 1)
 			break;
 		len = *p++;
+		sz--;
 		if (sz < len)
 			break;
 		p += len;

-- 
Eric Sesterhenn (Principal Security Consultant)
X41 D-SEC GmbH, Dennewartstr. 25-27, D-52068 Aachen
T: +49 241 9809418-0, Fax: -9
Unternehmenssitz: Aachen, Amtsgericht Aachen: HRB19989
Geschäftsführer: Markus Vervier
