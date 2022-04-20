Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD1DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Apr 2022 18:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381513AbiDTS57 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 14:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381635AbiDTS5n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 14:57:43 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A3A6309
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Apr 2022 11:54:55 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id bn33so2984721ljb.6
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Apr 2022 11:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E7G9R2PIGnQv9ScLNOIpTEo8fhdxq6w1p4kDGreBme4=;
        b=SXhbt3B5dpqyViYmaYk1ynC3NkSbYi/L1MqS1RDIx/DJog0BBnhQHtvHRlw0AEoM/B
         Lxc9qwvlhHeHG6QWi51Kd97NlIp95HJMAnzwq8iu+CUnxn1dj9Kq59qo4D9tE/dp3fYd
         pbBa5o+pCYCx11enpDpIJROqFkSKRaoba4F7fZPDwx0nmu8GkVkJNJJzaTsTB43WbfVi
         8VKNEwRZLXLODqVrocfRgSU7E/0Pp02BG06OIfsFuykz8jM3LvqO3Sm3J2lur2NsiYpY
         kPbgvbFvSxZIO3MHea0xLWPp6ObPv6YIm8314lzMbn2y4eOsn8QCEI6XCcTIvj39n4fv
         2ssQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E7G9R2PIGnQv9ScLNOIpTEo8fhdxq6w1p4kDGreBme4=;
        b=jbpUynHJzOPM+O0Xyx2i4I7EU6eg5fBlx/hK9Np2xwX52ZpZ1u7Zslw/4p9KgTqWbC
         qxha+zRuphYtKhx/pWDTBZ7uJM3AEB/NkXrKesulavvfydje1J5DyBfle/CgtmDLnXwX
         OV3VX25QGhro7b3KUEHs5EQ8ogfDOWSuOPiXNd19nd4u9Q0Ekwc4wwNebRIKCoi6uyuZ
         rGmAnWU7r0rI6nMiqTdXkjot+hwWtEzILG8kntONAYsPOajAd7G+tE3vW1iD7alPMMp3
         4Im7r/1IDcm9QW9s3nPt7BHRB3DtLejjDYKApDSTb4ATldcmLRgYeXFuthkay/N0cAZP
         uObA==
X-Gm-Message-State: AOAM531b4HE6dzRB4TRnrcbMdZlBZ2w805FhXMt6R1lYIZbvksgVCTj/
        Pe2ZtzrIvlOzcmtF9c/AxFufXrFkVtvlJw==
X-Google-Smtp-Source: ABdhPJzEr3+swdiBoWOLxqcE+pBleWTwNJZk2tmQCq8LW9u95gggZ9KA+rE80vVNHqIEFXWmGoaoIg==
X-Received: by 2002:a2e:bf08:0:b0:247:f79c:5794 with SMTP id c8-20020a2ebf08000000b00247f79c5794mr13670215ljr.398.1650480893214;
        Wed, 20 Apr 2022 11:54:53 -0700 (PDT)
Received: from localhost.localdomain (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id p25-20020a2e9a99000000b0024dc3ccff47sm702932lji.32.2022.04.20.11.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 11:54:52 -0700 (PDT)
From:   Topi Miettinen <toiwoton@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Topi Miettinen <toiwoton@gmail.com>
Subject: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Date:   Wed, 20 Apr 2022 21:54:47 +0300
Message-Id: <20220420185447.10199-1-toiwoton@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add socket expressions for checking GID or UID of the originating
socket. These work also on input side, unlike meta skuid/skgid.

Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nft_socket.c               | 28 ++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 466fd3f4447c..b3c09c67d13a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1040,12 +1040,16 @@ enum nft_socket_attributes {
  * @NFT_SOCKET_MARK: Value of the socket mark
  * @NFT_SOCKET_WILDCARD: Whether the socket is zero-bound (e.g. 0.0.0.0 or ::0)
  * @NFT_SOCKET_CGROUPV2: Match on cgroups version 2
+ * @NFT_SOCKET_GID: Match on GID of socket owner
+ * @NFT_SOCKET_GID: Match on UID of socket owner
  */
 enum nft_socket_keys {
 	NFT_SOCKET_TRANSPARENT,
 	NFT_SOCKET_MARK,
 	NFT_SOCKET_WILDCARD,
 	NFT_SOCKET_CGROUPV2,
+	NFT_SOCKET_GID,
+	NFT_SOCKET_UID,
 	__NFT_SOCKET_MAX
 };
 #define NFT_SOCKET_MAX	(__NFT_SOCKET_MAX - 1)
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index b8f011145765..2f0fe9d886f3 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -113,6 +113,32 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		}
 		break;
 #endif
+	case NFT_SOCKET_GID:
+		if (sk_fullsock(sk)) {
+			struct socket *sock;
+
+			sock = sk->sk_socket;
+			if (sock && sock->file)
+				*dest = from_kgid_munged(sock_net(sk)->user_ns,
+							 sock->file->f_cred->fsgid);
+		} else {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
+		break;
+	case NFT_SOCKET_UID:
+		if (sk_fullsock(sk)) {
+			struct socket *sock;
+
+			sock = sk->sk_socket;
+			if (sock && sock->file)
+				*dest = from_kuid_munged(sock_net(sk)->user_ns,
+							 sock->file->f_cred->fsuid);
+		} else {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
+		break;
 	default:
 		WARN_ON(1);
 		regs->verdict.code = NFT_BREAK;
@@ -156,6 +182,8 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 		len = sizeof(u8);
 		break;
 	case NFT_SOCKET_MARK:
+	case NFT_SOCKET_GID:
+	case NFT_SOCKET_UID:
 		len = sizeof(u32);
 		break;
 #ifdef CONFIG_CGROUPS
-- 
2.35.1

