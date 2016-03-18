From: Guruswamy Basavaiah <guru2018@gmail.com>
Subject: [PATCH] iptables-translate: translate iptables --flush
Date: Sat, 19 Mar 2016 02:05:49 +0530
Message-ID: <20160318203549.GA18494@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35987 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbcCRUfx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2016 16:35:53 -0400
Received: by mail-pf0-f177.google.com with SMTP id u190so182165179pfb.3
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2016 13:35:52 -0700 (PDT)
Received: from localhost.localdomain ([1.23.7.45])
        by smtp.gmail.com with ESMTPSA id f12sm22984452pfd.87.2016.03.18.13.35.50
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Fri, 18 Mar 2016 13:35:51 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

translation for iptables --flush 

Examples: $ sudo
 iptables-translate -F INPUT nft flush chain ip filter INPUT

$ sudo iptables-translate -F -t nat
nft flush table ip nat

Signed-off-by: Guruswamy Basavaiah <guru2018@gmail.com>

---
 iptables/xtables-translate.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 13a0bc7..354357c 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -216,6 +216,14 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 		}
 		break;
 	case CMD_FLUSH:
+		if (p.chain) {
+			printf("flush chain %s %s %s\n",
+				family2str[h->family], p.table, p.chain);
+		} else {
+			printf("flush table %s %s\n",
+				family2str[h->family], p.table);
+		}
+		ret = 1;
 		break;
 	case CMD_ZERO:
 		break;
-- 
2.5.0

