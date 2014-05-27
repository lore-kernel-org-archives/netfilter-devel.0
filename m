From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH] scanner: Add udplite value for parsing it.
Date: Tue, 27 May 2014 16:30:11 +0200
Message-ID: <1401201011-25109-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:57789 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaE0Oa6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2014 10:30:58 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so9736929wes.13
        for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2014 07:30:57 -0700 (PDT)
Received: from localhost.localdomain (186.169.216.87.static.jazztel.es. [87.216.169.186])
        by mx.google.com with ESMTPSA id fs5sm8764023wic.22.2014.05.27.07.30.54
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 May 2014 07:30:55 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

When we add a udplite rule, we can't because we have forgot
to add this parameter in the scanner and nft doesn't detect it.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/scanner.l |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/scanner.l b/src/scanner.l
index 8371e6f..ff03e2a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -363,6 +363,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "cpi"			{ return CPI; }
=20
 "udp"			{ return UDP; }
+"udplite"		{ return UDPLITE; }
 "sport"			{ return SPORT; }
 "dport"			{ return DPORT; }
=20
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
