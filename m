Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E3C1D5CEB
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 21:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730843698; cv=none; b=H2yjn26cRRe3iN9TWrR+R2IKZRblcDEbHuF7GUAFzTeDAeSzoNpvpPLXfFSl5r61t+cxpC9ayKFLOZLMygLeUJX+4N6sJG3eE4jXQkW6vgNz4Ak9auR70sW/p1TnAf9OZqCeUCXadqdBNk6WITRwgBYunnKm1LFm2v/IiydWe2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730843698; c=relaxed/simple;
	bh=YLWnRe8+C3qPYWzxrbYd0TFA3h3VpFgJGI4xqW1fPIE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iJuy4v4uZj9plRpbSOkozDR5R77rmL7Hfr6QpJE8zVD6CbIFvlcqA4bp3Bj7iCOowqTTfK4hJkYP5+k5370HxgaFbgcEhy80K5gB+3oeEG8C7tsevb4IDOa8h/oFnYIYKQ+cv87BEtd87wg07x/HS4EOsmfw6CEok81tRq63XhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=K/zjfRF7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="K/zjfRF7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KzjgDunzNQHD9py2XQF6bRhwu74hfuwPzUdDZhSLWJ0=; b=K/zjfRF7zioVg7P4s8MCIjEvX5
	FLrnBfPt5UJhhTvhmCaW7XuMCR1Ct5S0qp8neF96JdOhc9IiDl34elrKjzzwL+Vc3LdelQh0h2YZF
	sECoEeYSuNrPcWLl7LW8t3255xZHPJgT28kxzs2ZMyL+mLd5mTMI1kzkkKqRQffqRjkLObLKMVIxr
	2VglK8DAX3IZZhVuPRmF940UEvYzwK0uh3eeG6um30u529p9z35/eNz22k+pFjfME6WHfDtSiXXzJ
	CIwPMmwChnGsYbWcp1IbzVcunBZ1w/qOjdqW+4NiGkP0g5R4gMo+qDo/xPgToSH35i7cOR7ro/Ubk
	k1JMzCLw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8RVm-000000004EB-0m37;
	Tue, 05 Nov 2024 22:54:54 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH] src: Eliminate warnings with -Wcalloc-transposed-args
Date: Tue,  5 Nov 2024 22:54:50 +0100
Message-ID: <20241105215450.6122-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

calloc() expects the number of elements in the first parameter, not the
second. Swap them and while at it drop one pointless cast (the function
returns a void pointer anyway).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/channel.c       | 4 ++--
 src/channel_mcast.c | 2 +-
 src/channel_tcp.c   | 2 +-
 src/channel_udp.c   | 2 +-
 src/fds.c           | 4 ++--
 src/filter.c        | 2 +-
 src/multichannel.c  | 2 +-
 src/origin.c        | 2 +-
 src/process.c       | 2 +-
 src/queue.c         | 2 +-
 src/tcp.c           | 4 ++--
 src/udp.c           | 4 ++--
 src/vector.c        | 2 +-
 13 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/src/channel.c b/src/channel.c
index acbfa7da5ebe6..0b89391e46fc1 100644
--- a/src/channel.c
+++ b/src/channel.c
@@ -56,7 +56,7 @@ channel_buffer_open(int mtu, int headersiz)
 {
 	struct channel_buffer *b;
 
-	b = calloc(sizeof(struct channel_buffer), 1);
+	b = calloc(1, sizeof(struct channel_buffer));
 	if (b == NULL)
 		return NULL;
 
@@ -94,7 +94,7 @@ channel_open(struct channel_conf *cfg)
 	if (cfg->channel_flags >= CHANNEL_F_MAX)
 		return NULL;
 
-	c = calloc(sizeof(struct channel), 1);
+	c = calloc(1, sizeof(struct channel));
 	if (c == NULL)
 		return NULL;
 
diff --git a/src/channel_mcast.c b/src/channel_mcast.c
index 35801d71d48ac..9c9dc62aaf48d 100644
--- a/src/channel_mcast.c
+++ b/src/channel_mcast.c
@@ -19,7 +19,7 @@ static void
 	struct mcast_channel *m;
 	struct mcast_conf *c = conf;
 
-	m = calloc(sizeof(struct mcast_channel), 1);
+	m = calloc(1, sizeof(struct mcast_channel));
 	if (m == NULL)
 		return NULL;
 
diff --git a/src/channel_tcp.c b/src/channel_tcp.c
index a84603cec0509..173c47ac1d732 100644
--- a/src/channel_tcp.c
+++ b/src/channel_tcp.c
@@ -21,7 +21,7 @@ static void
 	struct tcp_channel *m;
 	struct tcp_conf *c = conf;
 
-	m = calloc(sizeof(struct tcp_channel), 1);
+	m = calloc(1, sizeof(struct tcp_channel));
 	if (m == NULL)
 		return NULL;
 
diff --git a/src/channel_udp.c b/src/channel_udp.c
index a46a2b1c89296..3b3d754552904 100644
--- a/src/channel_udp.c
+++ b/src/channel_udp.c
@@ -19,7 +19,7 @@ static void
 	struct udp_channel *m;
 	struct udp_conf *c = conf;
 
-	m = calloc(sizeof(struct udp_channel), 1);
+	m = calloc(1, sizeof(struct udp_channel));
 	if (m == NULL)
 		return NULL;
 
diff --git a/src/fds.c b/src/fds.c
index 0b95437da44ff..d2c8b59615efb 100644
--- a/src/fds.c
+++ b/src/fds.c
@@ -30,7 +30,7 @@ struct fds *create_fds(void)
 {
 	struct fds *fds;
 
-	fds = (struct fds *) calloc(sizeof(struct fds), 1);
+	fds = calloc(1, sizeof(struct fds));
 	if (fds == NULL)
 		return NULL;
 
@@ -60,7 +60,7 @@ int register_fd(int fd, void (*cb)(void *data), void *data, struct fds *fds)
 	if (fd > fds->maxfd)
 		fds->maxfd = fd;
 
-	item = calloc(sizeof(struct fds_item), 1);
+	item = calloc(1, sizeof(struct fds_item));
 	if (item == NULL)
 		return -1;
 
diff --git a/src/filter.c b/src/filter.c
index ee316e7a3ca84..e863ea98c150b 100644
--- a/src/filter.c
+++ b/src/filter.c
@@ -77,7 +77,7 @@ struct ct_filter *ct_filter_create(void)
 	int i;
 	struct ct_filter *filter;
 
-	filter = calloc(sizeof(struct ct_filter), 1);
+	filter = calloc(1, sizeof(struct ct_filter));
 	if (!filter)
 		return NULL;
 
diff --git a/src/multichannel.c b/src/multichannel.c
index 952b5674585f0..25a9908ecc898 100644
--- a/src/multichannel.c
+++ b/src/multichannel.c
@@ -21,7 +21,7 @@ multichannel_open(struct channel_conf *conf, int len)
 	if (len <= 0 || len > MULTICHANNEL_MAX)
 		return NULL;
 
-	m = calloc(sizeof(struct multichannel), 1);
+	m = calloc(1, sizeof(struct multichannel));
 	if (m == NULL)
 		return NULL;
 
diff --git a/src/origin.c b/src/origin.c
index 3c65f3da3f3e9..e44ffa050e354 100644
--- a/src/origin.c
+++ b/src/origin.c
@@ -31,7 +31,7 @@ int origin_register(struct nfct_handle *h, int origin_type)
 {
 	struct origin *nlp;
 
-	nlp = calloc(sizeof(struct origin), 1);
+	nlp = calloc(1, sizeof(struct origin));
 	if (nlp == NULL)
 		return -1;
 
diff --git a/src/process.c b/src/process.c
index 08598eeae84de..47f14da272493 100644
--- a/src/process.c
+++ b/src/process.c
@@ -37,7 +37,7 @@ int fork_process_new(int type, int flags, void (*cb)(void *data), void *data)
 			}
 		}
 	}
-	c = calloc(sizeof(struct child_process), 1);
+	c = calloc(1, sizeof(struct child_process));
 	if (c == NULL)
 		return -1;
 
diff --git a/src/queue.c b/src/queue.c
index e94dc7c45d1fd..cab754bd482c1 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -33,7 +33,7 @@ queue_create(const char *name, int max_objects, unsigned int flags)
 {
 	struct queue *b;
 
-	b = calloc(sizeof(struct queue), 1);
+	b = calloc(1, sizeof(struct queue));
 	if (b == NULL)
 		return NULL;
 
diff --git a/src/tcp.c b/src/tcp.c
index 91fe524542013..dca0e09a3dff1 100644
--- a/src/tcp.c
+++ b/src/tcp.c
@@ -31,7 +31,7 @@ struct tcp_sock *tcp_server_create(struct tcp_conf *c)
 	struct tcp_sock *m;
 	socklen_t socklen = sizeof(int);
 
-	m = calloc(sizeof(struct tcp_sock), 1);
+	m = calloc(1, sizeof(struct tcp_sock));
 	if (m == NULL)
 		return NULL;
 
@@ -209,7 +209,7 @@ struct tcp_sock *tcp_client_create(struct tcp_conf *c)
 {
 	struct tcp_sock *m;
 
-	m = calloc(sizeof(struct tcp_sock), 1);
+	m = calloc(1, sizeof(struct tcp_sock));
 	if (m == NULL)
 		return NULL;
 
diff --git a/src/udp.c b/src/udp.c
index d0a7f5b546e6b..6102328c649f2 100644
--- a/src/udp.c
+++ b/src/udp.c
@@ -25,7 +25,7 @@ struct udp_sock *udp_server_create(struct udp_conf *conf)
 	struct udp_sock *m;
 	socklen_t socklen = sizeof(int);
 
-	m = calloc(sizeof(struct udp_sock), 1);
+	m = calloc(1, sizeof(struct udp_sock));
 	if (m == NULL)
 		return NULL;
 
@@ -97,7 +97,7 @@ struct udp_sock *udp_client_create(struct udp_conf *conf)
 	struct udp_sock *m;
 	socklen_t socklen = sizeof(int);
 
-	m = calloc(sizeof(struct udp_sock), 1);
+	m = calloc(1, sizeof(struct udp_sock));
 	if (m == NULL)
 		return NULL;
 
diff --git a/src/vector.c b/src/vector.c
index 92a54367d108a..29e8fbe4fdb52 100644
--- a/src/vector.c
+++ b/src/vector.c
@@ -35,7 +35,7 @@ struct vector *vector_create(size_t size)
 {
 	struct vector *v;
 
-	v = calloc(sizeof(struct vector), 1);
+	v = calloc(1, sizeof(struct vector));
 	if (v == NULL)
 		return NULL;
 
-- 
2.47.0

