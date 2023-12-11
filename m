Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RscdmSRk"
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325A5EB
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2023 16:56:43 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id 006d021491bc7-58de42d0ff7so2042623eaf.0
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2023 16:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702256202; x=1702861002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xyQ6noDAtbK4FWBfT5LBGmNFMwx9PdALU0cZBanl/L4=;
        b=RscdmSRkEXAGPZsA6ZiqEYquf3zrATjTP1P4bzD/VajDmeV/uN9+70Bil+6fNiiZT2
         gs2SwAKYMpWpsM1QFUqjnwOKuhm4NTOi5ZTJOSKvxaBUkyE0Dg2IRbi1zW/OObuh7lAS
         WLKDgv4AkfB+2ABHaUXutRZ4gUoYIWP2DyNZ/Jn5sFMGzJs2NFb6LLKiQMREOkbLU2Wz
         Tik4MWVTLAAyKz+Hy8GgV1FTKz5zHdPsqQ4oirTWqFJ3plkwI1vr1Zff/x4NzcwxcTbx
         l3kR0307ywbv9v524rExVuHaY46qjG98sv7S9GnnviovEhPqJKmFCdyKvlSgHL0NcdBz
         1OMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702256202; x=1702861002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xyQ6noDAtbK4FWBfT5LBGmNFMwx9PdALU0cZBanl/L4=;
        b=GtZ5SfK2AI56JDUYoR11e+LL4wE3Qr9W0SEMllszDO2r2lwZATSp97QCaHhgfCRL3/
         Ny2WDZl9YQZrNtSKKPoasuY5zWpW7yebW+QbMWOE2q49uHAbSl1052Gq6extUKL3dy//
         bKtt5wRuxU/212RBnwJbwiBX6QqUWzf7AK4eufn/STky83WrkaVCA36d3kcmP82RBzW+
         BrP/nUDTjaYdFO5Ma17d2Bj42GpZ7Tl157lWj0sXE4OI0Ej0r7qngIuMSgdMCGe6pQC8
         eALAVGvdg9yu+U5VFVvm7hzGRz+Wo9QiXb15sk8qSnssNwTgk1Zyq+h22wSVe7HXJZhl
         h9Cg==
X-Gm-Message-State: AOJu0YxUrDwb0JAb1X/3UsnJHAyemKtlsKr+DLvQ7VxUFyyzSBeVYWab
	Q4wflDTmonKLWZEyCllettwMQ0aP/hM=
X-Google-Smtp-Source: AGHT+IEp+32KYOzAXvJ5Yy09hp06VKzuQcyJ94K5/k0BWAJFZrsF8HzbsTOWeHmVys4JTXoQ0MZwWg==
X-Received: by 2002:a05:6808:114f:b0:3b8:b063:5d69 with SMTP id u15-20020a056808114f00b003b8b0635d69mr4237223oiu.80.1702256202287;
        Sun, 10 Dec 2023 16:56:42 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id z20-20020aa785d4000000b006cbb83adc1bsm5063767pfn.44.2023.12.10.16.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Dec 2023 16:56:42 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] src: add nfq_socket_sendto() - send config request and check response
Date: Mon, 11 Dec 2023 11:56:35 +1100
Message-Id: <20231211005635.7566-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20231211005635.7566-1-duncan_roe@optusnet.com.au>
References: <20231211005635.7566-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Classic convenience function to complement nfq_nlmsg_put2().

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .../libnetfilter_queue/libnetfilter_queue.h   |  2 +
 src/nlmsg.c                                   | 54 +++++++++++++------
 2 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index f7e68d8..724789a 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -15,6 +15,7 @@
 
 #include <sys/time.h>
 #include <libnfnetlink/libnfnetlink.h>
+#include <libmnl/libmnl.h>
 
 #include <libnetfilter_queue/linux_nfnetlink_queue.h>
 
@@ -152,6 +153,7 @@ void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t p
 int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
 struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num);
 struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num, uint16_t flags);
+int nfq_socket_sendto(struct mnl_socket *nl, struct nlmsghdr *nlh, char *buf, unsigned int portid);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 39fd12d..d605da8 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -336,29 +336,16 @@ struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num)
  * \n
  * This code snippet demonstrates reading these responses:
  * \verbatim
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-
 	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, queue_num,
 			     NLM_F_ACK);
 	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, NFQA_CFG_F_SECCTX);
 	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, NFQA_CFG_F_SECCTX);
 
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
-		exit(EXIT_FAILURE);
-	}
-
-	ret = mnl_socket_recvfrom(nl, buf, sizeof buf);
-	if (ret == -1) {
-		perror("mnl_socket_recvfrom");
-		exit(EXIT_FAILURE);
-	}
-
-	ret = mnl_cb_run(buf, ret, 0, portid, NULL, NULL);
-	if (ret == -1)
+	if (nfq_socket_sendto(nl, nlh, buf, portid == -1)
 		fprintf(stderr, "This kernel version does not allow to "
 				"retrieve security context.\n");
 \endverbatim
+ * \sa __nfq_socket_sendto__(3)
  *
  */
 
@@ -377,6 +364,43 @@ struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num,
 
 	return nlh;
 }
+/**
+ * nfq_socket_sendto - send a netlink message and read response from kernel
+ * \param nl Netlink socket obtained via \b mnl_socket_open()
+ * \param nlh Pointer to Netlink message to be sent
+ * \param buf Pointer to memory buffer of at least MNL_SOCKET_BUFFER_SIZE bytes
+ * \param portid Netlink PortID that we expect to receive
+ * \note \b nlh and \b buf may refer to the same memory location.
+ *
+ * Use nfq_socket_sendto() instead of \b mnl_socket_sendto() after
+ * nfq_nlmsg_put2() has set the NLM_F_ACK flag in *<b>nlh</b>.
+ *
+ * \return 0 or -1 on failure with \b errno set
+ * \par Errors
+ * __EOPNOTSUPP__ the kernel cannot action a facility requested by an
+ * NFQA_CFG_F_-prefixed flag.
+ * If there were several such flags, none have been actioned.
+ * \par
+ * Other errors from underlying libmnl calls are possible.
+ *
+ * \sa __nfq_nlmsg_put2__(3), __mnl_socket_sendto__(3),
+ * __mnl_socket_recvfrom__(3), __mnl_cb_run__(3)
+ *
+ */
+
+EXPORT_SYMBOL
+int nfq_socket_sendto(struct mnl_socket *nl, struct nlmsghdr *nlh, char *buf,
+		      unsigned int portid)
+{
+	int ret;
+
+	ret = mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
+	if (ret != -1)
+		ret = mnl_socket_recvfrom(nl, buf, MNL_SOCKET_BUFFER_SIZE);
+	if (ret != -1)
+		ret = mnl_cb_run(buf, ret, 0, portid, NULL, NULL);
+	return ret == -1 ? -1 : 0;
+}
 
 /**
  * @}
-- 
2.35.8

