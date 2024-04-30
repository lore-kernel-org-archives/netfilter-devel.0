Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E89A143725
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2024 14:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714488389; cv=none; b=XIoTEzMu0sfdppQG81qLaCNeqnxOR8XImA/qSoy2to/4dYSd5dUjmJA6aWsd1pOputesDI/u2KReaZzWnnpxDE8w7NR3g0gmmf77hC69r+5PbiiITwL0IY3A9A5/BuBP4Jvb7VODZB4egQ//K/0H7ikINV+fumCf321lG4t9rsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714488389; c=relaxed/simple;
	bh=+N/J+jQhBbfDjC3qMlhxMI3qeUftbTK3Ypj44nNejSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GhwdhYyakt+/U32Xxaap0wuLFjTqv8YEFX6uWqj7bQzsCC2kFVzjhA304shllspGHk0yN1fMuj69nj4Dyep4L0QgWK/5N1R7YcBfOeBpFXQzIaGz9pn6cAi7KTzGeLigVW3OfeYget5C1F4wvAr8Hi2XYZPfDuPRaelch1VvlNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 30 Apr 2024 16:46:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Evgen Bendyak <jman.box@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnetfilter_log] fix bug in race condition of calling
 nflog_open from different threads at same time
Message-ID: <ZjEEOLOJX8bE6p1O@calendula>
References: <CAM9G1EADHBYk9Y-Y9RBHbAhqOPOMab41DOEh+PZZa6XKGm8drA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAM9G1EADHBYk9Y-Y9RBHbAhqOPOMab41DOEh+PZZa6XKGm8drA@mail.gmail.com>

On Tue, Apr 30, 2024 at 01:18:29PM +0300, Evgen Bendyak wrote:
> This patch addresses a bug that occurs when the nflog_open function is
> called concurrently from different threads within an application. The
> function nflog_open internally invokes nflog_open_nfnl. Within this
> function, a static global variable pkt_cb (static struct nfnl_callback
> pkt_cb) is used. This variable is assigned a pointer to a newly
> created structure (pkt_cb.data = h;) and is passed to
> nfnl_callback_register. The issue arises with concurrent execution of
> pkt_cb.data = h;, as only one of the simultaneously created
> nflog_handle structures is retained due to the callback function.
> Subsequently, the callback function __nflog_rcv_pkt is invoked for all
> the nflog_open structures, but only references one of them.
> Consequently, the callbacks registered by the end-user of the library
> through nflog_callback_register fail to trigger in sessions where the
> incorrect reference was recorded.
> This patch corrects this behavior by creating the structure locally on
> the stack for each call to nflog_open_nfnl. Since the
> nfnl_callback_register function simply copies the data into its
> internal structures, there is no need to retain pkt_cb beyond this
> point.

Out of curiosity: How do you use this?

There is a fanout feature to distribute packets between consumer
threads to scale up.

And I suspect you don't want packets that belong to the same flow be
handled by different threads.
