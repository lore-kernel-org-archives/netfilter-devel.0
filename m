Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABC239B498
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 16:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783616202; cv=none; b=NGI6DR+60sz5/75dT+qLsEPr5H6rFd+TKdi2WdJk+4n0HptlxtgjNfGUcNgL0gIESKOBJwqq88QG3jV6yZyql7TVvyAY3V8C+RG71ClMWQCrYcNVq5687Q2S7LkBGGwWcIpBDkf2b5PWQPgCpttGMEAq9Cs9i/5TYqPTvlW7Z3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783616202; c=relaxed/simple;
	bh=HWtcENamuzYoyb1pUbzBaGSqQ+/bJld5FsA9r1e0mI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XuZBbFIsj4RtgLsBgoifIo2aIVFQcJN4TRjgYWJizikgBUFNMv5VPCz3ZEmnMdPdPRW9STJGoyb5EkjGs/o35VH1P8bH3+TzYWr8/nEoeYG1LId1+gMLqtZKpgz9ubUat7Z87ofHB6lOwbfhaMEex4d/hSxfC1flXMUjZ6mk3m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mirantis.com; spf=pass smtp.mailfrom=mirantis.com; dkim=pass (1024-bit key) header.d=mirantis.com header.i=@mirantis.com header.b=W4KCNzBY; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mirantis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mirantis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mirantis.com header.i=@mirantis.com header.b="W4KCNzBY"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8e9c9d63815so520666d6.2
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jul 2026 09:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mirantis.com; s=google; t=1783616200; x=1784221000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F78ZpsZOfyDMYnUXUuJ5w9ov9EoR4IHoCr/Ny6ZXTaY=;
        b=W4KCNzBYCocH7mfjMYOUaJ47RufCuKA+n7+Zu2xUFA5Gdr7rDox3puWlHeZ+1uoBn7
         LEbtKZYyAPfnJGlEijsxWXVyH3Ukqav5R7r8OZE4m4BguR7KB8xvjXMNUNDiNLQMjhXB
         o10lznaMds3h1pHLQHFAbKMBN4XIFzSU+k75o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783616200; x=1784221000;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F78ZpsZOfyDMYnUXUuJ5w9ov9EoR4IHoCr/Ny6ZXTaY=;
        b=gUFbymrn6+jNVQW9fqDNM03bASiPOxPDsL8Vskdw1FDv0232RRrTla2CgScCIvQOtx
         L+m6FceMrU/OJ9bai3a7tVyuzus/SHI5e7XKgfFcZir7e/Rapx00/K1e7YMYzXxPsJTJ
         Z7JhSbr9IW/qiyMYTMGvBoaOWbGy50l2HXRMq0EB9HN5FSKqfUUAeSFO6ixLipdylWrS
         sZQu4k+RXOXFxSkymipaYaFkBOQhZF2d5a9LuKOxW19mL1DNoG+Jbm0U/EV5PnCxmkNm
         kZvkWjMT9XAPEppdfh/ucOIgL0PzxS6qJoBTsNSt+hbQVVZKDsgfgmXM4odwi63tSIlD
         AadA==
X-Gm-Message-State: AOJu0YxTJdz24GtFnOAciWfT4gxjv/+Gma4TZvw8D+qyY1FvATWdwqTN
	rk0IMkbj04OSbLhkeC7MzUqM8OikWOzs2AQ+h4Jt2OQQ6xqP5ytYWq9KDXEuBTDs74xeEPr8WxC
	FM/pE
X-Gm-Gg: AfdE7cmadX+SfSAo+l1NVu7AJ+pwTxzgeUSzvQ+UkhOcn99EHpWLlxfjg9w+qcysNZT
	QLQ0EeeuosIOFJHmda/bM74TrPgg3VuYYvx4ePRUnmvtnbxJx3WSwXO5T/0icEdm4jFCV4pbKyq
	t9RZ2+GugfB5YukUklNmtHARVMBXq0d5XDP3VUbBOQ8vIfEO3EgsRYCEsN/y5oQ+X0ivCp4w/bh
	yWk5Lfmsx0gDLdWaagornCEo1B/QVZZcEd8UimwUDDctDWmrAJqHVlnxvpVHk+VyYVyUpb9A7UG
	VZHNFW/veDiRbVso7jqCq8FzqgZNmRzMPZ+G8zvIkhfF2PoLe5FGlC/UOBYKakh/LMSD5YCuBoP
	o6EFjV6e+Qwb87K8/sZknoufZdQDtjAnWNONsX1WEpF/TeZJP+1S7L33MsV13VhYVf+gbhCsa2s
	ncfe6TzJ1/Rncpd4rbcd8eLeQwZsRbTz7SNMXadCFAbzmLStQZB0x+M6P9ut899NmTN+9m62U2j
	FR3e8kWNg==
X-Received: by 2002:a05:6214:2f85:b0:8cc:e14:9594 with SMTP id 6a1803df08f44-8fec3522fc9mr107558416d6.33.1783616199952;
        Thu, 09 Jul 2026 09:56:39 -0700 (PDT)
Received: from localhost.localdomain (209-227-162-251.cpe.distributel.net. [209.227.162.251])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd87c9500sm21268516d6.46.2026.07.09.09.56.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 09 Jul 2026 09:56:39 -0700 (PDT)
From: Cory Snider <csnider@mirantis.com>
To: netfilter-devel@vger.kernel.org
Cc: Cory Snider <csnider@mirantis.com>
Subject: [nft PATCH] mnl: support RLIMIT_NOFILE soft limit > FD_SETSIZE
Date: Thu,  9 Jul 2026 12:53:13 -0400
Message-ID: <20260709165550.16259-1-csnider@mirantis.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use poll(2) instead of select(2) to poll the netlink socket so processes
which raise their file descriptor soft limit beyond FD_SETSIZE can use
libnftables without risk of the process aborting when too many files are
open.

Signed-off-by: Cory Snider <csnider@mirantis.com>
---
The use of select(2) is preventing us from integrating libnftables into
Docker as its RLIMIT_NOFILE soft limit is raised to the hard limit.
See also https://github.com/moby/moby/issues/52873.

 src/mnl.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index b9efd3cf..d9abbb72 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -34,6 +34,7 @@
 #include <intervals.h>
 #include <net/if.h>
 #include <sys/socket.h>
+#include <poll.h>
 #include <arpa/inet.h>
 #include <fcntl.h>
 #include <errno.h>
@@ -406,14 +407,13 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 	const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
 	};
-	struct timeval tv = {
-		.tv_sec		= 0,
-		.tv_usec	= 0
-	};
 	struct iovec iov[iov_len];
 	struct msghdr msg = {};
 	unsigned int rcvbufsiz;
-	fd_set readfds;
+	struct pollfd pfd = {
+		.fd = fd,
+		.events = POLLIN,
+	};
 	static mnl_cb_t cb_ctl_array[NLMSG_MIN_TYPE] = {
 	        [NLMSG_ERROR] = mnl_batch_extack_cb,
 	};
@@ -440,14 +440,11 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 
 	/* receive and digest all the acknowledgments from the kernel. */
 	while (true) {
-		FD_ZERO(&readfds);
-		FD_SET(fd, &readfds);
-
-		ret = select(fd + 1, &readfds, NULL, NULL, &tv);
+		ret = poll(&pfd, 1, 0);
 		if (ret == -1)
 			return -1;
 
-		if (!FD_ISSET(fd, &readfds))
+		if (ret == 0)
 			break;
 
 		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
@@ -2436,7 +2433,16 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
 	int fd = mnl_socket_get_fd(nf_sock);
 	char buf[NFT_NLMSG_MAXSIZE];
 	int sigfd = get_signalfd();
-	fd_set readfds;
+	struct pollfd pfd[2] = {
+		{
+			.fd = fd,
+			.events = POLLIN,
+		},
+		{
+			.fd = sigfd,
+			.events = POLLIN,
+		},
+	};
 	int ret;
 
 	ret = mnl_set_rcvbuffer(nf_sock, bufsiz);
@@ -2445,19 +2451,14 @@ int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
 			  NFTABLES_NLEVENT_BUFSIZ, bufsiz);
 
 	while (1) {
-		FD_ZERO(&readfds);
-		FD_SET(fd, &readfds);
-		if (sigfd != -1)
-			FD_SET(sigfd, &readfds);
-
-		ret = select(max(fd, sigfd) + 1, &readfds, NULL, NULL, NULL);
+		ret = poll(pfd, array_size(pfd), -1);
 		if (ret < 0)
 			return -1;
 
-		if (sigfd >= 0 && FD_ISSET(sigfd, &readfds))
+		if (sigfd >= 0 && (pfd[1].revents & POLLIN))
 			check_signalfd(sigfd);
 
-		if (FD_ISSET(fd, &readfds)) {
+		if (pfd[0].revents & POLLIN) {
 			ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
 			if (ret < 0) {
 				if (errno == ENOBUFS) {
-- 
2.47.0

