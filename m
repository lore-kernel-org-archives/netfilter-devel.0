Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAA612D753
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2024 10:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474466; cv=none; b=YI/xAC21Txk4HJwPecTXPBaxh9Mlbv3s6zTZbzVCYYK4LA8760bZmCmsUcW6UFqPNb7w8c9gzdluAfDkFLy4PO758G3uef+PliScaoZTBen4kJTXpS4007AR9DvGIylL7Q7bgryh8jXKXrJGleyZRhuBBFeWuZTu9DqGU5DK5lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474466; c=relaxed/simple;
	bh=hu2KQZl56CsZQOoVvQiKAbgcl84xb8mGdb4CgLSE0Tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4YnXoELyV25UAzHULHagl4RLZDuGyvOmwN+1s57h8eG+BlfMgF8YL++4eopqEz5qpucMmp6HxK9Ksb+k/Y+KaKfKegJG1BjKC0jmTGNcL++gO2rjPczK4Thl3rH+cJlJAQ/KDNxO4x321/nEQIrNUsG/zq1afAEiT3TvvTsQFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bA4SqkKx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bA4SqkKx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hu2KQZl56CsZQOoVvQiKAbgcl84xb8mGdb4CgLSE0Tk=; b=bA4SqkKxqZPhIQqKWLaCJXCgF3
	KHQirwaC6AyPbaTy+nQzY8OmCIt4MYiykrN+DHM15MDegOG52+S7ZcLytH1K9mYsflc4lK2k2SqVv
	FFZs2oKY40xFH7jRuOGlOHa36VPZsS3636Fj+sll471zq6DJVe0SmiePjZPfrxsXIuYBTPINlSU7T
	bcIvtJY+IRKvkCC2tG/KTiZQgiX9U6oXMXVjSiv1fIXqoTC2ic7idN6wjK6AnOzV3NeZhxx5T+XKj
	HUDWfqw5gJsIn0bh2a8PxbqK34p+lrYQM43ODx5/yUdfJFxKlm0TONH7+B6WENHBzuEy+yG8fGe00
	YHvXCi9A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s1l7o-00000000161-1KuD;
	Tue, 30 Apr 2024 12:54:16 +0200
Date: Tue, 30 Apr 2024 12:54:16 +0200
From: Phil Sutter <phil@nwl.cc>
To: Evgen Bendyak <jman.box@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnetfilter_log] fix bug in race condition of calling
 nflog_open from different threads at same time
Message-ID: <ZjDN2DNJNmbEv68p@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Evgen Bendyak <jman.box@gmail.com>, netfilter-devel@vger.kernel.org
References: <CAM9G1EADHBYk9Y-Y9RBHbAhqOPOMab41DOEh+PZZa6XKGm8drA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9G1EADHBYk9Y-Y9RBHbAhqOPOMab41DOEh+PZZa6XKGm8drA@mail.gmail.com>

Evgen,

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

Patch looks sane, but I fear formatting won't do. Are you able to turn
this into a git commit and use git-format-patch/git-send-email to submit
it?

Thanks, Phil
