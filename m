Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C3AC77B7E
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 19:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjE1TPN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 15:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjE1TPM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 15:15:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9114DA2;
        Sun, 28 May 2023 12:15:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 240346197E;
        Sun, 28 May 2023 19:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414CEC433EF;
        Sun, 28 May 2023 19:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1685301310;
        bh=YJEINVjHXav0HLqcmNQGE/KV/xKH+xvCjdy/dQUhkzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIyF3FVkxqOeJv61pCjf6GKk+nMx3D5T5u+APRPrrYfxVn/mufbgGG4M+NvUl1IKf
         gWxZRRXzi5QSJbu6jWUMnRW/YzFNhTFP5ipESvPOPz0J74CK8GA61CodltmXYM86bq
         6WLHdYojhdJdizQAGFeyNeroEgtsGfi01Jkl5eZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Hugues ANGUELKOV <hanguelkov@randorisec.fr>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 66/86] netfilter: nf_tables: stricter validation of element data
Date:   Sun, 28 May 2023 20:10:40 +0100
Message-Id: <20230528190831.087932516@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ 7e6bc1f6cabcd30aba0b11219d8e01b952eacbb6 ]

Make sure element data type and length do not mismatch the one specified
by the set declaration.

Fixes: 7d7402642eaf ("netfilter: nf_tables: variable sized set element keys / data")
Reported-by: Hugues ANGUELKOV <hanguelkov@randorisec.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3959,13 +3959,20 @@ static int nft_setelem_parse_data(struct
 				  struct nft_data *data,
 				  struct nlattr *attr)
 {
+	u32 dtype;
 	int err;
 
 	err = nft_data_init(ctx, data, NFT_DATA_VALUE_MAXLEN, desc, attr);
 	if (err < 0)
 		return err;
 
-	if (desc->type != NFT_DATA_VERDICT && desc->len != set->dlen) {
+	if (set->dtype == NFT_DATA_VERDICT)
+		dtype = NFT_DATA_VERDICT;
+	else
+		dtype = NFT_DATA_VALUE;
+
+	if (dtype != desc->type ||
+	    set->dlen != desc->len) {
 		nft_data_release(data, desc->type);
 		return -EINVAL;
 	}


