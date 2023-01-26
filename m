Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40290C05027
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Jan 2023 12:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbjAZMY6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Jan 2023 07:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbjAZMYv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2023 07:24:51 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3516A31A
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2023 04:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VaDkkm2VKTnn3yomvJxquK9kPTOSNtaeu2NmyI2jmE0=; b=AvA1FzOuV4RKqFunAPFTbXwoX/
        NjJN3fpVhDwWEw4XbvE8U+RMzsKrxwHENWVt/BfaPALaqL5NbDC6mZRsotj1+2BR2wbNh1TqzqJ7t
        Qhu04aXuCqjA3FOnmPby3R0IEaRVcbmet+7fneVmARGROsi1BFeEx0gSMjouaIDHw85rm7Jn1Mpfd
        Fh/6sRnygQZrtgdidPI8Z8tyV8wz2Nu+w2C2jz2jObNEYVldrZSkGMkKea8etLI9TLC0xKx42lY/y
        NHCzCAgHZ7Y284sNLifRdyAkq80uT1+FZp7X285hgTUdPWuHSX2tOxTO2nQsv9Vju/7oZgu2QqZcS
        HLtXKEow==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pL1J1-00058S-Ny
        for netfilter-devel@vger.kernel.org; Thu, 26 Jan 2023 13:24:39 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 6/7] ebtables-translate: Print flush command after parsing is finished
Date:   Thu, 26 Jan 2023 13:24:05 +0100
Message-Id: <20230126122406.23288-7-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230126122406.23288-1-phil@nwl.cc>
References: <20230126122406.23288-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise, bad calls like 'ebtables-translate -F -F' produce wrong
output instead of an error message.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb-translate.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index 99347c0c3ee46..da7e5e3dda1f3 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -247,13 +247,6 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 			ret = 1;
 			break;
 		case 'F': /* Flush */
-			if (p.chain) {
-				printf("flush chain bridge %s %s\n", p.table, p.chain);
-			} else {
-				printf("flush table bridge %s\n", p.table);
-			}
-			ret = 1;
-			break;
 		case 'Z': /* Zero counters */
 			if (c == 'Z') {
 				if ((flags & OPT_ZERO) || (flags & OPT_COMMAND && command != 'L'))
@@ -506,6 +499,13 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 
 	if (command == 'P') {
 		return 0;
+	} else if (command == 'F') {
+			if (p.chain) {
+				printf("flush chain bridge %s %s\n", p.table, p.chain);
+			} else {
+				printf("flush table bridge %s\n", p.table);
+			}
+			ret = 1;
 	} else if (command == 'A') {
 		ret = nft_rule_eb_xlate_add(h, &p, &cs, true);
 		if (!ret)
-- 
2.38.0

