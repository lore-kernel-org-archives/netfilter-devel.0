Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55C22EDD57
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 20:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762806612; cv=none; b=bKK5qK6ZHuw1up1/AQO/WqFmmqTJ1olDM3I939o5Ko4Za1YbklTWpq+a+Hc/ybnHfjT+VQdGUCpX+GcJXDgDC5trOOosdSVgMQpyBK+G2BoxlsfJhk3WqBAqIpU7ldN2bcMAu5EZfDuW+sYX/QgtNgCsjQTPfvjhDlB4VIW79hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762806612; c=relaxed/simple;
	bh=dLm/rFayYQOjohUArLumTWMxlcbzUH9UvmPYK0Mw+Uo=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S72g6or/bGvy7zQYt4oqWde/b5GtglHc6hpKAt43HxF3nzaAVgMUy6l2PNqhhwp3IkDwoWhw3IyHIpfDBRH2YkMTdegkULtQbklACYyNSCUcQvEJV5iGWXkBfdwGbf+c7gkiC1XsOkib4OsB5aZ4Hjkw1ZuZOBehxeVZcn/18sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=e89OB1S9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="e89OB1S9"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C1AFA60349
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 21:30:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1762806600;
	bh=gRH9qBM9aVQUzz7pjLtw2Q5Dbk+y6YTGkFM8LRsoPvY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=e89OB1S9xWoOtesn9z5j4y19F+8YeAs8WGaXyS+l1okT1MNA7P+Fs4q2zq9c53NYz
	 poKYmpNhmLn4HqE67DRpyghcYqsVb6fh4XhvlhfOiWs0s2jTzGjPHQU2ApPPm0IfGh
	 PUrqKs0XKt7THU/6JkdZUR04Oq+EJwbkJoo7+vly1rUKlh2r/rR50BtD4AoIVbZtzk
	 4osDnO3W12OcAdQRUzyXyDG/vssPsnlvwVcxJkiM4D2K6qjCV3RdQSp+eM7R4EPemL
	 /rGVTglPV71+zai8Q63ZoVfYcnZhUETcWEKOIdXPV71VNq84PgWGnmBo6KXuMZf9Ki
	 rXgUtgOIGD1xQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools,v2 2/3] conntrackd: remove double close() in multicast resulting in EBADFD
Date: Mon, 10 Nov 2025 21:29:55 +0100
Message-Id: <20251110202956.22523-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20251110202956.22523-1-pablo@netfilter.org>
References: <20251110202956.22523-1-pablo@netfilter.org>
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
v2: no changes.

 src/mcast.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/src/mcast.c b/src/mcast.c
index 912e7623bf15..0e215d2757cb 100644
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

