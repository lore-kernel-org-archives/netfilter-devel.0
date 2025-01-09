Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2DC20551B
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2025 12:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736425569; cv=none; b=O/Hcq4xXdfUoSIazGUH+M+/P6mFOJU3myj2M4dAeQ1NU8K9YBh2Rs5g2hqwjPhKqdT/ys6frg9c/zkxSYUHFmVWMC4Z6sEbKJGOIwjtZkYHJbHe4qL0HD4N42JR0tuUDfQ7nd5vh5EU/vg9hUHSveFZKEAgrydvxYD4cbQ7joqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736425569; c=relaxed/simple;
	bh=dK2BiWeGeAMyCr5nda3IDuhW1c/pcyCLSbTxFJwM7Ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A7rHA7RiqSy573zyWl/+CPblNc032zrxH3GBFgbmy3w5sLcDKaDneIPye0uoUQmoD7y4WCDpHfBCMN8oHzx9bvLVJRBoplSHB/IBbZ1qmtYuRmnUkRCslBG21r5iIopJ7AsXaHm+aOxtPRIOPl5tR1+wT+0uW3/74heKw7U5l9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 9 Jan 2025 13:26:01 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] src: switch calloc argument order
Message-ID: <Z3_AWdicuwbAwat2@calendula>
References: <20250109113904.20848-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250109113904.20848-1-fw@strlen.de>

On Thu, Jan 09, 2025 at 12:39:02PM +0100, Florian Westphal wrote:
> Fix following gcc-14.2.1 warnings:
> 
> channel.c: In function 'channel_buffer_open':
> channel.c:59:27: warning: 'calloc' sizes specified with 'sizeof' in the earlier argument and not in the later argument [-Wcalloc-transposed-args]
>    59 |         b = calloc(sizeof(struct channel_buffer), 1);
>       |                           ^~~~~~
> 
> These are harmless, but since there are several of these they generate
> lots of noise.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.

> ---
>  src/channel.c       | 4 ++--
>  src/channel_mcast.c | 2 +-
>  src/channel_tcp.c   | 2 +-
>  src/channel_udp.c   | 2 +-
>  src/fds.c           | 4 ++--
>  src/filter.c        | 2 +-
>  src/multichannel.c  | 2 +-
>  src/origin.c        | 2 +-
>  src/process.c       | 2 +-
>  src/queue.c         | 4 ++--
>  src/tcp.c           | 4 ++--
>  src/udp.c           | 4 ++--
>  src/vector.c        | 2 +-
>  13 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/src/channel.c b/src/channel.c
> index acbfa7da5ebe..0b89391e46fc 100644
> --- a/src/channel.c
> +++ b/src/channel.c
> @@ -56,7 +56,7 @@ channel_buffer_open(int mtu, int headersiz)
>  {
>  	struct channel_buffer *b;
>  
> -	b = calloc(sizeof(struct channel_buffer), 1);
> +	b = calloc(1, sizeof(struct channel_buffer));
>  	if (b == NULL)
>  		return NULL;
>  
> @@ -94,7 +94,7 @@ channel_open(struct channel_conf *cfg)
>  	if (cfg->channel_flags >= CHANNEL_F_MAX)
>  		return NULL;
>  
> -	c = calloc(sizeof(struct channel), 1);
> +	c = calloc(1, sizeof(struct channel));
>  	if (c == NULL)
>  		return NULL;
>  
> diff --git a/src/channel_mcast.c b/src/channel_mcast.c
> index 35801d71d48a..9c9dc62aaf48 100644
> --- a/src/channel_mcast.c
> +++ b/src/channel_mcast.c
> @@ -19,7 +19,7 @@ static void
>  	struct mcast_channel *m;
>  	struct mcast_conf *c = conf;
>  
> -	m = calloc(sizeof(struct mcast_channel), 1);
> +	m = calloc(1, sizeof(struct mcast_channel));
>  	if (m == NULL)
>  		return NULL;
>  
> diff --git a/src/channel_tcp.c b/src/channel_tcp.c
> index a84603cec050..173c47ac1d73 100644
> --- a/src/channel_tcp.c
> +++ b/src/channel_tcp.c
> @@ -21,7 +21,7 @@ static void
>  	struct tcp_channel *m;
>  	struct tcp_conf *c = conf;
>  
> -	m = calloc(sizeof(struct tcp_channel), 1);
> +	m = calloc(1, sizeof(struct tcp_channel));
>  	if (m == NULL)
>  		return NULL;
>  
> diff --git a/src/channel_udp.c b/src/channel_udp.c
> index a46a2b1c8929..3b3d75455290 100644
> --- a/src/channel_udp.c
> +++ b/src/channel_udp.c
> @@ -19,7 +19,7 @@ static void
>  	struct udp_channel *m;
>  	struct udp_conf *c = conf;
>  
> -	m = calloc(sizeof(struct udp_channel), 1);
> +	m = calloc(1, sizeof(struct udp_channel));
>  	if (m == NULL)
>  		return NULL;
>  
> diff --git a/src/fds.c b/src/fds.c
> index 0b95437da44f..d2c8b59615ef 100644
> --- a/src/fds.c
> +++ b/src/fds.c
> @@ -30,7 +30,7 @@ struct fds *create_fds(void)
>  {
>  	struct fds *fds;
>  
> -	fds = (struct fds *) calloc(sizeof(struct fds), 1);
> +	fds = calloc(1, sizeof(struct fds));
>  	if (fds == NULL)
>  		return NULL;
>  
> @@ -60,7 +60,7 @@ int register_fd(int fd, void (*cb)(void *data), void *data, struct fds *fds)
>  	if (fd > fds->maxfd)
>  		fds->maxfd = fd;
>  
> -	item = calloc(sizeof(struct fds_item), 1);
> +	item = calloc(1, sizeof(struct fds_item));
>  	if (item == NULL)
>  		return -1;
>  
> diff --git a/src/filter.c b/src/filter.c
> index ee316e7a3ca8..e863ea98c150 100644
> --- a/src/filter.c
> +++ b/src/filter.c
> @@ -77,7 +77,7 @@ struct ct_filter *ct_filter_create(void)
>  	int i;
>  	struct ct_filter *filter;
>  
> -	filter = calloc(sizeof(struct ct_filter), 1);
> +	filter = calloc(1, sizeof(struct ct_filter));
>  	if (!filter)
>  		return NULL;
>  
> diff --git a/src/multichannel.c b/src/multichannel.c
> index 952b5674585f..25a9908ecc89 100644
> --- a/src/multichannel.c
> +++ b/src/multichannel.c
> @@ -21,7 +21,7 @@ multichannel_open(struct channel_conf *conf, int len)
>  	if (len <= 0 || len > MULTICHANNEL_MAX)
>  		return NULL;
>  
> -	m = calloc(sizeof(struct multichannel), 1);
> +	m = calloc(1, sizeof(struct multichannel));
>  	if (m == NULL)
>  		return NULL;
>  
> diff --git a/src/origin.c b/src/origin.c
> index 3c65f3da3f3e..e44ffa050e35 100644
> --- a/src/origin.c
> +++ b/src/origin.c
> @@ -31,7 +31,7 @@ int origin_register(struct nfct_handle *h, int origin_type)
>  {
>  	struct origin *nlp;
>  
> -	nlp = calloc(sizeof(struct origin), 1);
> +	nlp = calloc(1, sizeof(struct origin));
>  	if (nlp == NULL)
>  		return -1;
>  
> diff --git a/src/process.c b/src/process.c
> index 08598eeae84d..47f14da27249 100644
> --- a/src/process.c
> +++ b/src/process.c
> @@ -37,7 +37,7 @@ int fork_process_new(int type, int flags, void (*cb)(void *data), void *data)
>  			}
>  		}
>  	}
> -	c = calloc(sizeof(struct child_process), 1);
> +	c = calloc(1, sizeof(struct child_process));
>  	if (c == NULL)
>  		return -1;
>  
> diff --git a/src/queue.c b/src/queue.c
> index e94dc7c45d1f..f4437c97172e 100644
> --- a/src/queue.c
> +++ b/src/queue.c
> @@ -33,7 +33,7 @@ queue_create(const char *name, int max_objects, unsigned int flags)
>  {
>  	struct queue *b;
>  
> -	b = calloc(sizeof(struct queue), 1);
> +	b = calloc(1, sizeof(struct queue));
>  	if (b == NULL)
>  		return NULL;
>  
> @@ -102,7 +102,7 @@ struct queue_object *queue_object_new(int type, size_t size)
>  {
>  	struct queue_object *obj;
>  
> -	obj = calloc(sizeof(struct queue_object) + size, 1);
> +	obj = calloc(1, sizeof(struct queue_object) + size);
>  	if (obj == NULL)
>  		return NULL;
>  
> diff --git a/src/tcp.c b/src/tcp.c
> index 91fe52454201..dca0e09a3dff 100644
> --- a/src/tcp.c
> +++ b/src/tcp.c
> @@ -31,7 +31,7 @@ struct tcp_sock *tcp_server_create(struct tcp_conf *c)
>  	struct tcp_sock *m;
>  	socklen_t socklen = sizeof(int);
>  
> -	m = calloc(sizeof(struct tcp_sock), 1);
> +	m = calloc(1, sizeof(struct tcp_sock));
>  	if (m == NULL)
>  		return NULL;
>  
> @@ -209,7 +209,7 @@ struct tcp_sock *tcp_client_create(struct tcp_conf *c)
>  {
>  	struct tcp_sock *m;
>  
> -	m = calloc(sizeof(struct tcp_sock), 1);
> +	m = calloc(1, sizeof(struct tcp_sock));
>  	if (m == NULL)
>  		return NULL;
>  
> diff --git a/src/udp.c b/src/udp.c
> index d0a7f5b546e6..6102328c649f 100644
> --- a/src/udp.c
> +++ b/src/udp.c
> @@ -25,7 +25,7 @@ struct udp_sock *udp_server_create(struct udp_conf *conf)
>  	struct udp_sock *m;
>  	socklen_t socklen = sizeof(int);
>  
> -	m = calloc(sizeof(struct udp_sock), 1);
> +	m = calloc(1, sizeof(struct udp_sock));
>  	if (m == NULL)
>  		return NULL;
>  
> @@ -97,7 +97,7 @@ struct udp_sock *udp_client_create(struct udp_conf *conf)
>  	struct udp_sock *m;
>  	socklen_t socklen = sizeof(int);
>  
> -	m = calloc(sizeof(struct udp_sock), 1);
> +	m = calloc(1, sizeof(struct udp_sock));
>  	if (m == NULL)
>  		return NULL;
>  
> diff --git a/src/vector.c b/src/vector.c
> index 92a54367d108..29e8fbe4fdb5 100644
> --- a/src/vector.c
> +++ b/src/vector.c
> @@ -35,7 +35,7 @@ struct vector *vector_create(size_t size)
>  {
>  	struct vector *v;
>  
> -	v = calloc(sizeof(struct vector), 1);
> +	v = calloc(1, sizeof(struct vector));
>  	if (v == NULL)
>  		return NULL;
>  
> -- 
> 2.45.2
> 
> 
