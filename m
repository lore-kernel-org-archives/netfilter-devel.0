Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F568EE49B0
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 19:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjHUTnK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 15:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjHUTnI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 15:43:08 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EBAFB
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 12:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HXpPk7tp49EAf3yeK50PbsLH7ItjT/xbkLlD9wD+qT8=; b=fXCeRPD6us6+Uw20sC0FHzuu1o
        /PtMn9617uLCMsQQw8sbnpvBYHY1A9kTb+VDCJzkkwESTLLkVBXhVyUhARK0VnnFwonMXv5bn+U0s
        6fn/Od6tGwpIyik1vCOaotxVy89SqNo4xe8xaAX40WRuM7orJsQfPJ06p3W8yi+MAQ8orHK9MPTby
        M7lMv9gMpGBKP49pwH6kLNw8kygfSrCyhG4ZFbRoxG1f/61ViloqaDbfiWFcT+1BAevYJwAIaEqAm
        hgM/PFRYXpom5FudYxvYKrqXY22v32OAmlvPxUMN9j1iBJirpwtUQj3mep/z9JJgT3AURdS3ZTj8y
        2RE8o9dw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qYAnn-00909U-2G
        for netfilter-devel@vger.kernel.org;
        Mon, 21 Aug 2023 20:43:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 06/11] ipfix: skip non-ipv4 addresses
Date:   Mon, 21 Aug 2023 20:42:32 +0100
Message-Id: <20230821194237.51139-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230821194237.51139-1-jeremy@azazel.net>
References: <20230821194237.51139-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This plug-in expects ipv4 addresses.  Check the length of the key value
in order to filter out ipv6 addresses.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ipfix/ulogd_output_IPFIX.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output_IPFIX.c
index 4863d008562e..1c0f730b5b7c 100644
--- a/output/ipfix/ulogd_output_IPFIX.c
+++ b/output/ipfix/ulogd_output_IPFIX.c
@@ -426,6 +426,9 @@ static int ipfix_interp(struct ulogd_pluginstance *pi)
 	if (!(GET_FLAGS(pi->input.keys, InIpSaddr) & ULOGD_RETF_VALID))
 		return ULOGD_IRET_OK;
 
+	if (GET_LENGTH(pi->input.keys, InIpSaddr) != sizeof(data->saddr))
+		return ULOGD_IRET_OK;
+
 	oid = oid_ce(pi->config_kset).u.value;
 	mtu = mtu_ce(pi->config_kset).u.value;
 	send_template = send_template_ce(pi->config_kset).u.string;
-- 
2.40.1

