Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C019C22A4E1
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 10:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762770942; cv=none; b=rXDUQZdOLv2v46WU3/Z9lDLjT/KCmCxAJlzOjYjRFbpS+s0I7XGWK8nblTXwZHPAkBj48/59a4zznaQ/IUFeQ69bAOqGwMxNmjyAutV+5v4aXglRYSOdhiXfvlkJ9E2L1ejEb6NMm/xfyx2bRvuiVN53csfKM1diwAyLiFqmqGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762770942; c=relaxed/simple;
	bh=vIQ+LGQsIT9ReKOaobQz7gdM7yPh+rdCSp4Wo7q9dBg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SlfuBZbkC111io9DIjR9YAEsu2OQezc0ZmOVuutceirKH68Wd2HJLIrl0o9Ag/sDHwGP5bwBePfzKUa93ilkiJMSC6aomjJhjsHVqtGwZ0SiO+1BrgWUpEYk6mqvuZuWG+Ap2TxdyrJN2k/1vr/ECjvstlJy+dIubzpjzH5Hd+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FdtgD1Bw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FdtgD1Bw"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8A56660262
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 11:35:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1762770937;
	bh=e5Xbe+A48v1kuUi61a5e2g0dXwop96ruJjVedFoMfbU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FdtgD1BwZDwYxIp2YARaV9HWe06Lwo4zO9aZ1A0U1RjMccB9m7WOgfZNCjaXmwGoO
	 PasG0zUqZWcFtLlpHB37kQCWk5d8HtaRQ+PlyAWKVST5eB9rA31bLIJAV42KftVDPM
	 35H3g/799Dz3l+ilOB1xclCgzunbDKCq7sFR5uYjJh6ZxxjgnINQ8j0ONBXPRMBdIQ
	 bKGFdWjIssVrVqpOBZcahuoP7NbGt2kd1GoGHIdsE77mwRYW60U48+JrTngecTVyc2
	 GXnjfnYZzQkGfadtgeR21uzDloDNJm5SIfTHn0uiIGLC+4U7h8snVlZQ8eYVpBtifN
	 d/CsXdeU8jg2A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools 2/2] conntrackd: remove double close() in multicast resulting in EBADFD
Date: Mon, 10 Nov 2025 11:35:31 +0100
Message-Id: <20251110103531.2158-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20251110103531.2158-1-pablo@netfilter.org>
References: <20251110103531.2158-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When using multicast for synchronization, misconfiguration results in
misleading EBADFD log errors due to double close() on the file
descriptor from the error path.

The caller of __mcast_client_create_{ipv4,ipv6} already deals with
closing the socket file descriptor.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mcast.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/src/mcast.c b/src/mcast.c
index 88300da32673..9d441e6f0b28 100644
--- a/src/mcast.c
+++ b/src/mcast.c
@@ -135,7 +135,7 @@ void mcast_server_destroy(struct mcast_sock *m)
 	free(m);
 }
 
-static int 
+static int
 __mcast_client_create_ipv4(struct mcast_sock *m, struct mcast_conf *conf)
 {
 	int no = 0;
@@ -143,25 +143,21 @@ __mcast_client_create_ipv4(struct mcast_sock *m, struct mcast_conf *conf)
 	m->addr.ipv4.sin_family = AF_INET;
 	m->addr.ipv4.sin_port = htons(conf->port);
 	m->addr.ipv4.sin_addr = conf->in.inet_addr;
-	m->sockaddr_len = sizeof(struct sockaddr_in); 
+	m->sockaddr_len = sizeof(struct sockaddr_in);
 
 	if (setsockopt(m->fd, IPPROTO_IP, IP_MULTICAST_LOOP, &no,
-		       sizeof(int)) < 0) {
-		close(m->fd);
+		       sizeof(int)) < 0)
 		return -1;
-	}
 
 	if (setsockopt(m->fd, IPPROTO_IP, IP_MULTICAST_IF,
 		       &conf->ifa.interface_addr,
-		       sizeof(struct in_addr)) == -1) {
-		close(m->fd);
+		       sizeof(struct in_addr)) == -1)
 		return -1;
-	}
 
 	return 0;
 }
 
-static int 
+static int
 __mcast_client_create_ipv6(struct mcast_sock *m, struct mcast_conf *conf)
 {
 	int no = 0;
@@ -171,20 +167,16 @@ __mcast_client_create_ipv6(struct mcast_sock *m, struct mcast_conf *conf)
 	memcpy(&m->addr.ipv6.sin6_addr,
 	       &conf->in.inet_addr6,
 	       sizeof(struct in6_addr));
-	m->sockaddr_len = sizeof(struct sockaddr_in6); 
+	m->sockaddr_len = sizeof(struct sockaddr_in6);
 
 	if (setsockopt(m->fd, IPPROTO_IPV6, IPV6_MULTICAST_LOOP, &no,
-		       sizeof(int)) < 0) {
-		close(m->fd);
+		       sizeof(int)) < 0)
 		return -1;
-	}
 
 	if (setsockopt(m->fd, IPPROTO_IPV6, IPV6_MULTICAST_IF,
 		       &conf->ifa.interface_index6,
-		       sizeof(unsigned int)) == -1) {
-		close(m->fd);
+		       sizeof(unsigned int)) == -1)
 		return -1;
-	}
 
 	return 0;
 }
-- 
2.30.2

