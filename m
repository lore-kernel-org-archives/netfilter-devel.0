From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-utils PATCH r7285 07/11] use size_t
Date: Wed, 23 Jan 2008 13:29:58 +0100
Message-ID: <47973346.9060404@netfilter.org>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <20080122141051.30077.59792.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50355 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753342AbYAWMah (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:30:37 -0500
In-Reply-To: <20080122141051.30077.59792.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> ---
> 
>  include/mcast.h   |    4 ++--
>  include/network.h |    7 ++++---
>  src/build.c       |    2 +-
>  src/local.c       |    4 ++--
>  src/mcast.c       |    8 ++++----
>  src/network.c     |   22 +++++++++++-----------
>  src/sync-alarm.c  |    2 +-
>  src/sync-ftfw.c   |    4 ++--
>  src/sync-mode.c   |   11 ++++++-----
>  9 files changed, 33 insertions(+), 31 deletions(-)

Applied with a minor change.

> --- a/src/sync-mode.c
> +++ b/src/sync-mode.c
> @@ -88,14 +88,15 @@ retry:
>  /* handler for multicast messages received */
>  static void mcast_handler(void)
>  {
> -	int numbytes, remain;
> +	ssize_t numbytes;
> +	size_t remain;
>  	char __net[65536], *ptr = __net; /* XXX: maximum MTU for IPv4 */
>  
>  	numbytes = mcast_recv(STATE_SYNC(mcast_server), __net, sizeof(__net));
>  	if (numbytes <= 0)
>  		return;
>  
> -	remain = numbytes;
> +	remain = (size_t)numbytes;
>  	while (remain > 0) {
>  		struct nethdr *net = (struct nethdr *) ptr;

I have kept remain signed since a malformed header can result in an
overflow.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
