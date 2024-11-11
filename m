Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF01D13AA38
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2024 02:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731293776; cv=none; b=IrkXxI8HTjoSxgA1yU1ctNxhxM7H5yzzcaP6z5UQsWD6ksn1hGcYgPdyDSW0pj4Ai4N/nHPzySgNciw3qCHZJliCGPVN92UjzqUNofsBKnKCh7mWua4s5WdQ1ttjJZFARiYuM4ALPn+Z+uYqpjBU5W55MO4Baoo8cPGAbICRhz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731293776; c=relaxed/simple;
	bh=9vMYhTGwxZigWPW2lz5Q3zBZvgtUn3cz1zx35sQq6rE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YbuKYsySJsduDza3akhLb8AdZXnoaDzkqas0Zsdy8QZ+ihH1OgVU0WOj/oxwwJdjkR+LTzrowGtGzUkNx9SV8OhsbGbm66e9WmfHG/k5bz9y0wtnfvmLWClIQboEC7yJK8yQW2+V5yToUuw4GIWqxVuywo8XGQySKlJNxTYnBNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ClW8Jrhb; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ClW8Jrhb"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3e5f9712991so1871354b6e.2
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Nov 2024 18:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731293774; x=1731898574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=2diC79ik6CJBwZXHFlP0PRY0Q2Hef89MjOtDBTUBWo8=;
        b=ClW8Jrhb67yyvqQbcbSSyHlKsZiQ5L/RRG6jWs4QtI5N7I8uRhV3Tu0sSDrVBOYK0C
         nkxJonrDflPMxagfZ+ZwHE0icaYyEE8ag7J8sOIxjhZymVVjQ0o+2KoYsaOSQ2lMG0ci
         6b4JJCpREfebN3tGyXRykEi9eJi84wiwutkxvzCFT+mWRNR7/TEKwvfTe19SVyAqOsVO
         UhuYIY3F5bDys22XlPcxhUnTzBs7LnvPRaL+XikrqQS9S6JODJ+6m/NA9wmJ/GWrIWtl
         XOjRfkP3dPEOp7ju2eYLNFe2v833cAfdlOf4qVmY/r4Gz2LhQ0u3/KoSp4AQKVAN9hzu
         jOaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731293774; x=1731898574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2diC79ik6CJBwZXHFlP0PRY0Q2Hef89MjOtDBTUBWo8=;
        b=IxmwxnqlX63C0iEyWV6Wn5VPxVWbF04rNymAlMtFE1zafGLvPp2twjztCdX+ZMbour
         Gk/UmcA8e013HeOftT66wXC66iZI7lL3rxZ8GCeuuKCKMMaxkZVwKpWvfqxm5Ck+Y59R
         cKsnfihfUshAZHA2rQa2biYP+iwKDohq+/ZOuSJTCcUE2byJ4mPrCnGCScY4eBFlLum4
         0wns5COVYS3reEStkDOCmMMN+wifvreGTYGAWSHtSW14mZeiwB7gPNxmJGE5VLxviXUN
         0GMQWDod9GYO6BTTdpfuGKntkB3xSvOeB6OdtZzmyO5kuMGyzunzP23KC4M13fly2dWa
         vPsQ==
X-Gm-Message-State: AOJu0YyrgSDX5mgeDBKHFxp5K1W2pd1mujDp7KiDvtGxTr18h93cOgbE
	g8pa2kfmfnd+5e6NarHs9JbXxKDea0pIIAKQ1W5ayL+OozvX3Uhs/rjM8A==
X-Google-Smtp-Source: AGHT+IFHAz9Lqa4xYuuBNmhNVUksNuN02brxFmU83tDWqaN/hzJIhAwuUHk7PQvUe0QQi9zH+PbjaA==
X-Received: by 2002:a05:6808:f13:b0:3e6:769:354e with SMTP id 5614622812f47-3e7946ab754mr9628847b6e.25.1731293773757;
        Sun, 10 Nov 2024 18:56:13 -0800 (PST)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f41f643e9asm7422237a12.59.2024.11.10.18.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 18:56:13 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libmnl] whitespace: remove spacing irregularities
Date: Mon, 11 Nov 2024 13:56:08 +1100
Message-Id: <20241111025608.8683-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two distinct actions:
 1. Remove trailing spaces and tabs.
 2. Remove spaces that are followed by a tab, inserting extra tabs
    as required.
Action 2 is only performed in the indent region of a line.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/linux/netlink.h | 6 +++---
 src/callback.c          | 4 ++--
 src/socket.c            | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index ced0e1a..7c26175 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -14,7 +14,7 @@
 #define NETLINK_SELINUX		7	/* SELinux event notifications */
 #define NETLINK_ISCSI		8	/* Open-iSCSI */
 #define NETLINK_AUDIT		9	/* auditing */
-#define NETLINK_FIB_LOOKUP	10	
+#define NETLINK_FIB_LOOKUP	10
 #define NETLINK_CONNECTOR	11
 #define NETLINK_NETFILTER	12	/* netfilter subsystem */
 #define NETLINK_IP6_FW		13
@@ -29,13 +29,13 @@
 
 #define NETLINK_INET_DIAG	NETLINK_SOCK_DIAG
 
-#define MAX_LINKS 32		
+#define MAX_LINKS 32
 
 struct sockaddr_nl {
 	__kernel_sa_family_t	nl_family;	/* AF_NETLINK	*/
 	unsigned short	nl_pad;		/* zero		*/
 	__u32		nl_pid;		/* port ID	*/
-       	__u32		nl_groups;	/* multicast groups mask */
+	__u32		nl_groups;	/* multicast groups mask */
 };
 
 struct nlmsghdr {
diff --git a/src/callback.c b/src/callback.c
index f5349c3..703ae80 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -21,7 +21,7 @@ static int mnl_cb_error(const struct nlmsghdr *nlh, void *data)
 	const struct nlmsgerr *err = mnl_nlmsg_get_payload(nlh);
 
 	if (nlh->nlmsg_len < mnl_nlmsg_size(sizeof(struct nlmsgerr))) {
-		errno = EBADMSG; 
+		errno = EBADMSG;
 		return MNL_CB_ERROR;
 	}
 	/* Netlink subsystems returns the errno value with different signess */
@@ -73,7 +73,7 @@ static inline int __mnl_cb_run(const void *buf, size_t numbytes,
 		}
 
 		/* netlink data message handling */
-		if (nlh->nlmsg_type >= NLMSG_MIN_TYPE) { 
+		if (nlh->nlmsg_type >= NLMSG_MIN_TYPE) {
 			if (cb_data){
 				ret = cb_data(nlh, data);
 				if (ret <= MNL_CB_STOP)
diff --git a/src/socket.c b/src/socket.c
index 85b6bcc..60ba2cd 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -206,7 +206,7 @@ EXPORT_SYMBOL int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups,
 
 	addr_len = sizeof(nl->addr);
 	ret = getsockname(nl->fd, (struct sockaddr *) &nl->addr, &addr_len);
-	if (ret < 0)	
+	if (ret < 0)
 		return ret;
 
 	if (addr_len != sizeof(nl->addr)) {
@@ -226,7 +226,7 @@ EXPORT_SYMBOL int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups,
  * \param buf buffer containing the netlink message to be sent
  * \param len number of bytes in the buffer that you want to send
  *
- * On error, it returns -1 and errno is appropriately set. Otherwise, it 
+ * On error, it returns -1 and errno is appropriately set. Otherwise, it
  * returns the number of bytes sent.
  */
 EXPORT_SYMBOL ssize_t mnl_socket_sendto(const struct mnl_socket *nl,
@@ -235,7 +235,7 @@ EXPORT_SYMBOL ssize_t mnl_socket_sendto(const struct mnl_socket *nl,
 	static const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
 	};
-	return sendto(nl->fd, buf, len, 0, 
+	return sendto(nl->fd, buf, len, 0,
 		      (struct sockaddr *) &snl, sizeof(snl));
 }
 
-- 
2.46.2

