Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3012C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Feb 2022 18:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237841AbiBPS7g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Feb 2022 13:59:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbiBPS7g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Feb 2022 13:59:36 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D058E2AD677
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Feb 2022 10:59:23 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id w3so5549306edu.8
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Feb 2022 10:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ezDXhINB/KKshn9ITSxyzD+XWXuqozahXogrATu5Vas=;
        b=TRlX/FJu5QRYSFchdfIywqGOj3wAbGvB5OFnxN34acx7ZZV1/UXgwT/Hb5qAX/N0LY
         NgDa52X+dmLcsHNJgulH835dhupK259pzqWwA/nQYBcBufZVwqlOo3c2lcgXCSwyicCT
         p5V+TPdime/okAdBmq07r+0T8W5XHlhPfP3vmbytb/l/2pQ5Sd2KFFGuzTrJqpp+wBfN
         /yh8lY+d+tPxGfbq56pf1UYO06bxo7MB1HrsO+IcOs3IAr8MJys3YL8lEcPGGk5gExaw
         BuEepu3BhYzNFEB4BgaVnQ7+Cg+qdV0fod5gqUdFOYWtQ76Kdiv4SjZMVowKKs9Nrmox
         aVeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ezDXhINB/KKshn9ITSxyzD+XWXuqozahXogrATu5Vas=;
        b=kOrf87BeFrTmh21ZfWgm34F3qvSX+2wQX8Z0kYe0zoqQ+L8Hr9tDqQi3/vyteIb4ZI
         XTH1Q9ShMoUgilkhIzPZkhJie5/UH7g4u9Uh6p2Q7Vo0XCU0uQRRpgrN2vWZiD3oVrYv
         Tc6939vhblREJC0x39IBAZL9DMXzVipanZAprm9UUfpd0B7rb80wixYM2EhG6Xbl2Wv0
         5k4iljwi/Y483bdVnOiVEzFAJZHYg98vF8p9IN0wjH2NPEJeZf0uBFnuFgL2uJOsWVLi
         I7FHv/Lfr3SWpgQGMPayN7PUGEc8u85gINiqHShCKI2HwsLIatRT6e1aKdotiblEHT29
         UzQg==
X-Gm-Message-State: AOAM5325cptvnQ73BCdTeoBsi6kdbqJsXqtanrYY8UG0lw1sj/oiF0K/
        EF0IGYHminCrZDEL8u055LfX36widbD4jQ==
X-Google-Smtp-Source: ABdhPJy1Y28iGw1Yq07zgi1ulPfHTfakiykeU/PTqvVectIFGn8+NVIK4pUkaP0NQSVM2OmEjysoNA==
X-Received: by 2002:a05:6402:d05:b0:410:ba9e:de0c with SMTP id eb5-20020a0564020d0500b00410ba9ede0cmr4577615edb.278.1645037961990;
        Wed, 16 Feb 2022 10:59:21 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf784.dynamic.kabel-deutschland.de. [95.91.247.132])
        by smtp.gmail.com with ESMTPSA id dz8sm2156167edb.96.2022.02.16.10.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 10:59:21 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 3/3] conntrack: use libmnl for flushing conntrack table
Date:   Wed, 16 Feb 2022 19:58:26 +0100
Message-Id: <20220216185826.48218-4-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216185826.48218-1-mikhail.sennikovskii@ionos.com>
References: <20220216185826.48218-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use libmnl and libnetfilter_conntrack mnl helpers to flush the conntrack
table entries.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 8cd760b..d20ccff 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2417,6 +2417,20 @@ nfct_mnl_set_ct(struct nfct_mnl_socket *sock,
 	return nfct_mnl_talk(sock, nlh, NULL);
 }
 
+static int
+nfct_mnl_set(struct nfct_mnl_socket *sock,
+	      uint16_t subsys, uint16_t type, uint8_t family)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type,
+				    NLM_F_ACK,
+					family);
+
+	return nfct_mnl_talk(sock, nlh, NULL);
+}
+
 static int
 nfct_mnl_request(struct nfct_mnl_socket *sock,
 		uint16_t subsys, uint16_t type, const struct nf_conntrack *ct,
@@ -3522,11 +3536,15 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case CT_FLUSH:
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-		res = nfct_query(cth, NFCT_Q_FLUSH_FILTER, &cmd->family);
-		nfct_close(cth);
+		res = nfct_mnl_socket_open(sock, 0);
+		if (res < 0)
+			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
+
+		res = nfct_mnl_set(sock,
+			           NFNL_SUBSYS_CTNETLINK,
+			           IPCTNL_MSG_CT_DELETE,
+			           cmd->family);
+		nfct_mnl_socket_close(sock);
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"connection tracking table has been emptied.\n");
 		break;
-- 
2.25.1

