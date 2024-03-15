Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0B814280
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488070; cv=none; b=OF6f/hy40Xz97Ig5YZo4vmwdjtKWFrkmEEbJ0VOBf2b+OaA4Nir5nKvyHCUceOyDe6aM/b7L4M+2IeWDuwmBq9AC7oaH+vGZ7HDK2Fj5Il6oLBdwm8kkGgPumMYtWznWrKefCe49jgy61+NBJ48yqo0zlXNokOu5HkWcGzO/Uq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488070; c=relaxed/simple;
	bh=ckKVNMrwmZ/g2k54KXhmbFRO5ut6Se73OlEu9OuM29g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oF1J7ixe/G17C+4ZYoKa1n4RGI1GLYRRjoi4HDHpkkPSx2yDDuOdpr/ivegNeZZAq4Qn/M9XU0QC5dfl7A6kQRUorbLIgAvEqCQD5uhuLjW/TuWvmAk4dBjVELpagtaMETOzjaD71bf1mlOYjVi6EXTfMSQTd8Eiz9V2vr4TozE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OOOCHRXa; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OOOCHRXa"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dc29f1956cso12446995ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488068; x=1711092868; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=warmzOFMCniHxy4s6tk6438UhHvqirjCdgxP+FmQs0A=;
        b=OOOCHRXakuP4KjVfsKPt1TNafarn5iWj3AxH1KsBZ1/KPnSwWDdmPGuXWnohU9lUV2
         VFBHYsvXLhGoXFyaMF+7ybrtNHzVvnCfyDJaXwLGpI/XBbEnvQMgIb+w5qsdhl0D9BGz
         zF5er0mitiQhF/5nZxestF08TRCEYXdr84GQpvRq6L5bw4lrDJPpX5ZiwMi75wl7/xv1
         QwGroLR8D8h8Ng9fS0MlNY1HyniHRut/1jyR5cjbfCon+uxpBC97ejX/nr1+vhXJuShS
         Vj4mMT/A72VTHf0MmgsMGNBptgSAmpg+fbmeN5MIOlQQWX0EObgntHB80cB0dpfzTqsf
         g4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488068; x=1711092868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=warmzOFMCniHxy4s6tk6438UhHvqirjCdgxP+FmQs0A=;
        b=bPAtZnMoSQcxW6IR9HLU49f4kWW0ZkzZPQBu/3KCL+nhTGMqpDmdVSl4FOMGxifoHB
         +uUmEUcEQxpaHQtqWI8+fb88SFw1E8rBXaVEX7AWqkMNjBDa33ZuO22WKOgEBqm9u//x
         T3LoDe0mJRCkSVEOmtx5LY3kUfhmr3v6FZkWwFuBhX1eed/3xch6HsfW9sVkheeFsdbe
         TpW4DkWKQ8gu/G44l7xGXEfFUbT7NF4iO7/3xXEC0OXQXi4gJL2Fezy55wNoN6w7LI30
         P/O6OMaCP7zF5TqASr4kVvTQktsA6wy3zetrhXdYkfCYXcyh51Jv8mpqKeY4zdxEqr0A
         HCIA==
X-Gm-Message-State: AOJu0Yy6OiF89Jcl65m3h2wuDVBmbH7bMOsLv5Do2MDAhEnJxuUgnYbc
	6wUGZZx+Euizi5HDYZKE9ykELJT5Q5VNj/zYpaBSUiB2LUINMy6Z0FEY1fbC
X-Google-Smtp-Source: AGHT+IGjALKzeS4yWvYQwm/5+3eEKNjmxchaLj3hHxeMz7ZoR+P9skRDpl0OrtrhtUNbMSJqZ/HIYA==
X-Received: by 2002:a17:903:22cb:b0:1dd:66d1:a62b with SMTP id y11-20020a17090322cb00b001dd66d1a62bmr2660664plg.5.1710488067855;
        Fri, 15 Mar 2024 00:34:27 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:27 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 20/32] src: Delete rtnl.c
Date: Fri, 15 Mar 2024 18:33:35 +1100
Message-Id: <20240315073347.22628-21-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZcyaQvJ1SvnYgakf@calendula>
References: <ZcyaQvJ1SvnYgakf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rtnl.c was copied from libnfnetlink for reference: it has now served its
purpose.
Without rtnl.c, doxygen again runs warning-free.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/rtnl.c | 283 -----------------------------------------------------
 1 file changed, 283 deletions(-)
 delete mode 100644 src/rtnl.c

diff --git a/src/rtnl.c b/src/rtnl.c
deleted file mode 100644
index dff3bef..0000000
--- a/src/rtnl.c
+++ /dev/null
@@ -1,283 +0,0 @@
-/* rtnl - rtnetlink utility functions
- *
- * (C) 2004 by Astaro AG, written by Harald Welte <hwelte@astaro.com>
- *
- * Adapted to nfnetlink by Eric Leblond <eric@inl.fr>
- *
- * This software is free software and licensed under GNU GPLv2+.
- *
- */
-
-/* rtnetlink - routing table netlink interface */
-
-#include <unistd.h>
-#include <stdlib.h>
-#include <string.h>
-#include <errno.h>
-#include <time.h>
-#include <sys/types.h>
-#include <sys/uio.h>
-
-#include <netinet/in.h>
-
-#include <linux/types.h>
-#include <sys/socket.h>
-#include <linux/netlink.h>
-#include <linux/rtnetlink.h>
-
-#include "rtnl.h"
-
-#define rtnl_log(x, ...)
-
-static inline struct rtnl_handler *
-find_handler(struct rtnl_handle *rtnl_handle, uint16_t type)
-{
-	struct rtnl_handler *h;
-	for (h = rtnl_handle->handlers; h; h = h->next) {
-		if (h->nlmsg_type == type)
-			return h;
-	}
-	return NULL;
-}
-
-static int call_handler(struct rtnl_handle *rtnl_handle,
-			uint16_t type,
-			struct nlmsghdr *hdr)
-{
-	struct rtnl_handler *h = find_handler(rtnl_handle, type);
-
-	if (!h) {
-		rtnl_log(LOG_DEBUG, "no registered handler for type %u", type);
-		return 0;
-	}
-
-	return (h->handlefn)(hdr, h->arg);
-}
-
-/**
- * \defgroup rtnetlink Functions in rtnl.c [DEPRECATED]
- * This documentation is provided for the benefit of maintainers of legacy code.
- *
- * New applications should use
- * [libmnl](https://netfilter.org/projects/libmnl/doxygen/html/).
- * @{
- */
-
-/**
- * rtnl_handler_register - register handler for given nlmsg type
- * \param: rtnl_handle: Handler ftom rtnl_open()
- * \param: hdlr: callback handler structure
- */
-int rtnl_handler_register(struct rtnl_handle *rtnl_handle,
-			  struct rtnl_handler *hdlr)
-{
-	rtnl_log(LOG_DEBUG, "registering handler for type %u",
-		 hdlr->nlmsg_type);
-	hdlr->next = rtnl_handle->handlers;
-	rtnl_handle->handlers = hdlr;
-	return 1;
-}
-
-/**
- * rtnl_handler_unregister - unregister handler for given nlmst type
- * \param: hdlr: callback handler structure
- * \param: hdlr:	handler structure
- */
-int rtnl_handler_unregister(struct rtnl_handle *rtnl_handle,
-			    struct rtnl_handler *hdlr)
-{
-	struct rtnl_handler *h, *prev = NULL;
-
-	rtnl_log(LOG_DEBUG, "unregistering handler for type %u",
-		 hdlr->nlmsg_type);
-
-	for (h = rtnl_handle->handlers; h; h = h->next) {
-		if (h == hdlr) {
-			if (prev)
-				prev->next = h->next;
-			else
-				rtnl_handle->handlers = h->next;
-			return 1;
-		}
-		prev = h;
-	}
-	return 0;
-}
-
-int rtnl_parse_rtattr(struct rtattr *tb[], int max, struct rtattr *rta, int len)
-{
-	memset(tb, 0, sizeof(struct rtattr *) * max);
-
-	while (RTA_OK(rta, len)) {
-		if (rta->rta_type <= max)
-			tb[rta->rta_type] = rta;
-		rta = RTA_NEXT(rta,len);
-	}
-	if (len)
-		return -1;
-	return 0;
-}
-
-/* rtnl_dump_type - ask rtnetlink to dump a specific table
- * \param: type:	type of table to be dumped
- */
-int rtnl_dump_type(struct rtnl_handle *rtnl_handle, unsigned int type)
-{
-	struct {
-		struct nlmsghdr nlh;
-		struct rtgenmsg g;
-	} req;
-	struct sockaddr_nl nladdr;
-
-	memset(&nladdr, 0, sizeof(nladdr));
-	memset(&req, 0, sizeof(req));
-	nladdr.nl_family = AF_NETLINK;
-
-	req.nlh.nlmsg_len = sizeof(req);
-	req.nlh.nlmsg_type = type;
-	req.nlh.nlmsg_flags = NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST;
-	req.nlh.nlmsg_pid = 0;
-	req.nlh.nlmsg_seq = rtnl_handle->rtnl_dump = ++(rtnl_handle->rtnl_seq);
-	req.g.rtgen_family = AF_INET;
-
-	return sendto(rtnl_handle->rtnl_fd, &req, sizeof(req), 0,
-		      (struct sockaddr*)&nladdr, sizeof(nladdr));
-}
-
-/* rtnl_receive - receive netlink packets from rtnetlink socket */
-int rtnl_receive(struct rtnl_handle *rtnl_handle)
-{
-	int status;
-	char buf[8192];
-	struct sockaddr_nl nladdr;
-	struct iovec iov = { buf, sizeof(buf) };
-	struct nlmsghdr *h;
-
-	struct msghdr msg = {
-		.msg_name    = &nladdr,
-		.msg_namelen = sizeof(nladdr),
-		.msg_iov     = &iov,
-		.msg_iovlen  = 1,
-	};
-
-	status = recvmsg(rtnl_handle->rtnl_fd, &msg, 0);
-	if (status < 0) {
-		if (errno == EINTR)
-			return 0;
-		rtnl_log(LOG_NOTICE, "OVERRUN on rtnl socket");
-		return -1;
-	}
-	if (status == 0) {
-		rtnl_log(LOG_ERROR, "EOF on rtnl socket");
-		return -1;
-	}
-	if (msg.msg_namelen != sizeof(nladdr)) {
-		rtnl_log(LOG_ERROR, "invalid address size");
-		return -1;
-	}
-
-	h = (struct nlmsghdr *) buf;
-	while (NLMSG_OK(h, status)) {
-#if 0
-		if (h->nlmsg_pid != rtnl_local.nl_pid ||
-		    h->nlmsg_seq != rtnl_dump) {
-			goto skip;
-		}
-#endif
-
-		if (h->nlmsg_type == NLMSG_DONE) {
-			rtnl_log(LOG_NOTICE, "NLMSG_DONE");
-			return 0;
-		}
-		if (h->nlmsg_type == NLMSG_ERROR) {
-			struct nlmsgerr *err = NLMSG_DATA(h);
-			if (h->nlmsg_len>=NLMSG_LENGTH(sizeof(struct nlmsgerr)))
-				errno = -err->error;
-			rtnl_log(LOG_ERROR, "NLMSG_ERROR, errnp=%d",
-				 errno);
-			return -1;
-		}
-
-		if (call_handler(rtnl_handle, h->nlmsg_type, h) == 0)
-			rtnl_log(LOG_NOTICE, "unhandled nlmsg_type %u",
-				 h->nlmsg_type);
-		h = NLMSG_NEXT(h, status);
-	}
-	return 1;
-}
-
-int rtnl_receive_multi(struct rtnl_handle *rtnl_handle)
-{
-	while (1) {
-		if (rtnl_receive(rtnl_handle) <= 0)
-			break;
-	}
-	return 1;
-}
-
-/* rtnl_open - constructor of rtnetlink module */
-struct rtnl_handle *rtnl_open(void)
-{
-	socklen_t addrlen;
-	struct rtnl_handle *h;
-
-	h = calloc(1, sizeof(struct rtnl_handle));
-	if (!h)
-		return NULL;
-
-	addrlen = sizeof(h->rtnl_local);
-
-	h->rtnl_local.nl_pid = getpid();
-	h->rtnl_fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
-	if (h->rtnl_fd < 0) {
-		rtnl_log(LOG_ERROR, "unable to create rtnetlink socket");
-		goto err;
-	}
-
-	memset(&h->rtnl_local, 0, sizeof(h->rtnl_local));
-	h->rtnl_local.nl_family = AF_NETLINK;
-	h->rtnl_local.nl_groups = RTMGRP_LINK;
-	if (bind(h->rtnl_fd, (struct sockaddr *) &h->rtnl_local, addrlen) < 0) {
-		rtnl_log(LOG_ERROR, "unable to bind rtnetlink socket");
-		goto err_close;
-	}
-
-	if (getsockname(h->rtnl_fd,
-			(struct sockaddr *) &h->rtnl_local,
-			&addrlen) < 0) {
-		rtnl_log(LOG_ERROR, "cannot gescockname(rtnl_socket)");
-		goto err_close;
-	}
-
-	if (addrlen != sizeof(h->rtnl_local)) {
-		rtnl_log(LOG_ERROR, "invalid address size %u", addr_len);
-		goto err_close;
-	}
-
-	if (h->rtnl_local.nl_family != AF_NETLINK) {
-		rtnl_log(LOG_ERROR, "invalid AF %u", h->rtnl_local.nl_family);
-		goto err_close;
-	}
-
-	h->rtnl_seq = time(NULL);
-
-	return h;
-
-err_close:
-	close(h->rtnl_fd);
-err:
-	free(h);
-	return NULL;
-}
-
-/* rtnl_close - destructor of rtnetlink module */
-void rtnl_close(struct rtnl_handle *rtnl_handle)
-{
-	close(rtnl_handle->rtnl_fd);
-	free(rtnl_handle);
-	return;
-}
-
-/**
- * @}
- */
-- 
2.35.8

