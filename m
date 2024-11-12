Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDC71DFF7
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2024 00:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731372349; cv=none; b=nEIs/+2QwjteQs0c4D59dzx/EN/if0URTerYtkRYwuslqtcjlJOymdlU2vCbaHMa1IcWcEnF58DlxQSb5pbQZGuuqlMaJGKhfYTdTvsqkbvFNSOU2brxxE4ZUn1g3sX3SzP3jHGQEoByfnpQMwjQKyo+GjBpEy8+vfyCc6DBrcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731372349; c=relaxed/simple;
	bh=ZcRhGpuYJH/APsfLXnp3e7+A2rNh+7qwGhjq9+Y/YS8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rdoN1/THqfHsfrI6heISWDIHY7FaOUXrNupEi+AU7YYDP/1QO/Ny6Gnohjfwc1Du2gvP+so/438Aq1mCTNdzjbywzvgf1cAlTJSamJUkQMVDibQgCiDJlV4NLcg88Yrdw9W9FnPECSdV6o211xPZ9CD2mVcOBqpojHsStGEnaSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IjM90eS3; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IjM90eS3"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20cbcd71012so58889435ad.3
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2024 16:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731372346; x=1731977146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=wYkujrytwNUKVB23EM/6vCUv8MuVYXkQsyrGljFDvN4=;
        b=IjM90eS3JBaaxSqyUyH48tTmI6bue7V8cnQI7aERnWnqi6Dq/V08Z4iEId8KX2qXFG
         HBKQjnrqna039JbtkfyPXofG68ABPDWHuaoACMyvFiZVyyWy30v79IRjfD6TLjaCj1NN
         ztpDZW8D59HIuIKC57TU0/aK7V2s1xh8IR1J54CfNHEW9nO+QOMwHApMYMEL8sC2p3ml
         VwfTQdrDbRj08S7Za99y+NQWXylNriJWHXkZfl9DAnp1RclhbnwQhTYRgcYyWr4tSdHS
         hP27zxY8aqrCm2bLsEaz/wHqcRwQQbuLUdjqpHFrs1lUXRjo0ZdF1w3RpNYl2gUizdFX
         UuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731372346; x=1731977146;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYkujrytwNUKVB23EM/6vCUv8MuVYXkQsyrGljFDvN4=;
        b=xVEnLlJYl+UXvFwb02GIgvbyC18hmBa2egNDTqaRnO2AM15ImAbosimOhdPef3aPFJ
         KPpJSHj9Q9sX+ohyfT807tP3zitgRXQwAhPSW2k6Ots3DNfP8BXUOtvCkXEgC5ZzseAj
         SfqLZpa+O6899TOvonCsaMDUaFQwUgJJB/zA/cFkSteDAvYDSncd6p8lgrabYsbUgE+Z
         0mLYR+XswiVnKZ31NfDlt9IHi9axZ1dI9ya7ri9tEDWSKjKkz9XEA+ROzWAxKo15GVOs
         lnLzY2ba9yAO3eolZZL4WvzOICwerqcYLXXqSfS2pLtPBHOKO7ezBT7UtdDEILU8ppQ3
         qPQA==
X-Gm-Message-State: AOJu0YzznAp1gp33jkcNGrx+7043YhG8S/Bcbr3FiUG8mCkyW0uRMd14
	XVrwjEA7fu33MsPSyIFP4s+g3eTW6Kqm96MvSNc63iYrc26RIXcwTqi1pA==
X-Google-Smtp-Source: AGHT+IFnHCi1BTiAPqFwCXbIsPMaH7W3YafSUA1iKB5xEJQheNgcaWtO4Zj9GixvKgJWj6bZp+BGWg==
X-Received: by 2002:a17:902:f549:b0:20c:92ce:359d with SMTP id d9443c01a7336-2118358a9c9mr185408195ad.45.1731372346095;
        Mon, 11 Nov 2024 16:45:46 -0800 (PST)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177e41717sm80109375ad.122.2024.11.11.16.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 16:45:45 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libmnl v2] whitespace: remove spacing irregularities
Date: Tue, 12 Nov 2024 11:45:40 +1100
Message-Id: <20241112004540.9589-1-duncan_roe@optusnet.com.au>
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
v2: Only fix spacing in .c files
 src/callback.c          | 4 ++--
 src/socket.c            | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

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

