Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DFFHwDH2"
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88CD110
	for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 17:53:59 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id 5614622812f47-3b2e330033fso1954169b6e.3
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Nov 2023 17:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700963639; x=1701568439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUQIm/lHy/pZgno+nJQbWs30z0O/h1asrKRO9YjUsd0=;
        b=DFFHwDH2ArRBj+sdev3/+tjR5gB2kUPqpKUoLp/ljZmwc4IL6jpEkBc3jrGojGiUSa
         egtoZGmIhZq6X0TdQZ98IGfyeddHWA9jayyn1rVVJPdFyBXdTX5BVHnFJvN21beOcVbX
         zpCyzVHad9bizUD3b0XxZj1x42RRTrMLwYBozGTm8AiBTMmTfrPzrscue7m0wprAO1Ar
         dtsBVq69Y128s+VXBWj2HGrAF9AGKZA6/X7x/ErUr5EImFhIHZ8Dzv1CcnPuaoP5Fzxt
         PzTlX+yq6V7yWGUMN3oVygCTxefAtLDbiqh1UuOE8FqR1PvRT+zDX9XcmcVPVtMEhuNT
         l4CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700963639; x=1701568439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TUQIm/lHy/pZgno+nJQbWs30z0O/h1asrKRO9YjUsd0=;
        b=a8SbVIFZqSyD047x7kOMDszQ9ZdGXwXeW2mStxR+l/M3PT9TtI33qCWETLc9BbVijs
         J3ho/wYMIQmBrkOpU2w/+LSLR8nzGJBipl6w3XRcKF0ESEWN7e6gI7g4h3r1ZBLvThoo
         p9eNOUpyjIJUUeysPHi/e9bkEMokDsNlif7TsbSMNE4UK52G52x8C6imTrdGTLC7F/bv
         ZdJ35rwhwE68ecMJTWCTyqzZCLUSVMmon/qbRK7PmYa+CZTv551RClh4IsueTxjNQfvk
         /WjjreYda0xTJqR35a3Ios1+QZx/8rWae8FMpfkg55urNBl68F39beoUkq33wnXERz8b
         +dlw==
X-Gm-Message-State: AOJu0Yzv6KFWA8T24XINx2mlC2HlYc5szwZTdS/7JFg81RfHtzhf2Hif
	zUlhuaD78U6AsJbJBRk3eojLxwdkgpg=
X-Google-Smtp-Source: AGHT+IHyoY6E3xPfyRucM+L2muec/dUMs9FgALQVipWKtR9ET8avih2QqQj6ADx0ggS8Qtl8gRJ7yw==
X-Received: by 2002:a05:6808:2381:b0:3b2:db24:6384 with SMTP id bp1-20020a056808238100b003b2db246384mr10035084oib.38.1700963639178;
        Sat, 25 Nov 2023 17:53:59 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id s23-20020aa78d57000000b006cbb18865a7sm4893136pfe.154.2023.11.25.17.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Nov 2023 17:53:58 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v5 1/1] src: Add nfq_nlmsg_put2() - user specifies header flags
Date: Sun, 26 Nov 2023 12:53:52 +1100
Message-Id: <20231126015352.17136-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZWBhH235ou6RhYFn@calendula>
References: <ZWBhH235ou6RhYFn@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable mnl programs to check whether a config request was accepted.
(nfnl programs do this already).

v5: documentation tweaks

v4: other requested changes

v3: force on NLM_F_REQUEST

v2: take flags as an arg (Pablo request)
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .../libnetfilter_queue/libnetfilter_queue.h   |  1 +
 src/nlmsg.c                                   | 57 ++++++++++++++++++-
 2 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 3d8e444..f254984 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -151,6 +151,7 @@ void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t p
 
 int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
 struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num);
+struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num, uint16_t flags);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 5400dd7..af7fb67 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -309,10 +309,65 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
  */
 EXPORT_SYMBOL
 struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num)
+{
+	return nfq_nlmsg_put2(buf, type, queue_num, 0);
+}
+
+/**
+ * nfq_nlmsg_put2 - Set up a netlink header with user-specified flags
+ *                  in a memory buffer
+ * \param *buf Pointer to memory buffer
+ * \param type One of NFQNL_MSG_CONFIG, NFQNL_MSG_VERDICT
+ *             or NFQNL_MSG_VERDICT_BATCH
+ * \param queue_num Queue number
+ * \param flags additional NLM_F_xxx flags to put in message header. These are
+ *              defined in /usr/include/linux/netlink.h. nfq_nlmsg_put2() always
+ *              sets NLM_F_REQUEST
+ * \returns Pointer to netlink header
+ *
+ * For most applications, the only sensible flag will be NLM_F_ACK.
+ * Use it before performing an action that might fail, e.g.
+ * attempt to configure NFQA_CFG_F_SECCTX on a system not running SELinux.
+ * \n
+ * The kernel always sends a message in response to a failed command.
+ * NLM_F_ACK instructs the kernel to also send a message in response
+ * to a successful command.
+ * \n
+ * This code snippet demonstrates reading these responses:
+ * \verbatim
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, queue_num,
+			     NLM_F_ACK);
+	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, NFQA_CFG_F_SECCTX);
+	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, NFQA_CFG_F_SECCTX);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof buf);
+	if (ret == -1) {
+		perror("mnl_socket_recvfrom");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_cb_run(buf, ret, 0, portid, NULL, NULL);
+	if (ret == -1)
+		fprintf(stderr, "This kernel version does not allow to "
+				"retrieve security context.\n");
+\endverbatim
+ *
+ */
+
+EXPORT_SYMBOL
+struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num,
+				uint16_t flags)
 {
 	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | type;
-	nlh->nlmsg_flags = NLM_F_REQUEST;
+	nlh->nlmsg_flags = NLM_F_REQUEST | flags;
 
 	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
 	nfg->nfgen_family = AF_UNSPEC;
-- 
2.35.8

