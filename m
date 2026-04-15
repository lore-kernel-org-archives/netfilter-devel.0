Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ED231D372;
	Wed, 15 Apr 2026 20:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776284735; cv=none; b=n6djdQE4NxOCApdwspXKa59xvlxhVoUSIEGO6v0lA5nLJpqy983FqBdRI7lmYVTpkZMM8MZ+I4veBoNPt4e6u2bpdlSfGmF0pycfCY+aRNqGRwc7uh5dnbT5563qHThlzWIxLTpCFTQfn7n06JB72+7LcULWguyLLWkFVFLlvXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776284735; c=relaxed/simple;
	bh=lTDSEfgLiPb6Zc6xiCp9O+PQaNg/usqGgZY7lpdsvjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XI/Dm+l0VFXHYn3wxDzK4NqVP32925+06MXB9KM5ntzW/eYQTaQ5Blka38wvWsxwXYTw8wVK/v0h7zZXVEk6yBy1ukDS0KffSahpuQyvnD10HQdopdm16CJE9diH1L1YQngieC7E/gAISOTotA/lWwS4ljHStg0iZ1QLovuwgFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QL9cHMuZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QL9cHMuZ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 392A0600B9;
	Wed, 15 Apr 2026 22:25:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776284730;
	bh=05tOkxOHaDMCzwX9o+tLfnCgbcASN3tKZPZ703Z0qLA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QL9cHMuZ7P9f/cOcS15BsGu1PaFGWrUUs0WXR/eAkKBrimFL5yZ/dDV0vqjSGO7WM
	 83e5Ilv4mfAWq35SWajTqRAbXA9UzcfM2+yTi0gMQsRHB8j5cp4tnirCu5oGvRHWEy
	 3wtnXH1joB67pNU0P6SqgzMHUQkJ0X/YBW3j7Vlrccm85wDmUs1gJymHQDtNP9MeLY
	 Jfw1NXqHrDAs4O6ferznZw6drjnWm+F79XG6cBJAohsVzVsv9/Ik4XbIN/ASVrItZo
	 6nO+Y5fxjmhtLRoEIZShNiH4vpgx5RSaKXMcz6FHTl5KtLUNve4U3G4PDdUW5R0nmp
	 sfnbdTlZfpHPQ==
Date: Wed, 15 Apr 2026 22:25:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de, horms@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, boqun@kernel.org,
	urezki@gmail.com, rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH nf,v2 1/3] rculist: add list_splice_rcu() for private
 lists
Message-ID: <ad_0N6yAOenXeXR7@chamomile>
References: <20260415170844.41355-1-pablo@netfilter.org>
 <9210a276-8158-40f4-b3b5-6431f5f13541@paulmck-laptop>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9210a276-8158-40f4-b3b5-6431f5f13541@paulmck-laptop>

On Wed, Apr 15, 2026 at 10:39:33AM -0700, Paul E. McKenney wrote:
> On Wed, Apr 15, 2026 at 07:08:44PM +0200, Pablo Neira Ayuso wrote:
> > This patch adds a helper function, list_splice_rcu(), to safely splice
> > a private (non-RCU-protected) list into an RCU-protected list.
> > 
> > The function ensures that only the pointer visible to RCU readers
> > (prev->next) is updated using rcu_assign_pointer(), while the rest of
> > the list manipulations are performed with regular assignments, as the
> > source list is private and not visible to concurrent RCU readers.
> > 
> > This is useful for moving elements from a private list into a global
> > RCU-protected list, ensuring safe publication for RCU readers.
> > Subsystems with some sort of batching mechanism from userspace can
> > benefit from this new function.
> > 
> > The function __list_splice_rcu() has been added for clarity and to
> > follow the same pattern as in the existing list_splice*() interfaces,
> > where there is a check to ensure that that the list to splice is not
> > empty. Note that __list_splice_rcu() has no documentation for this
> > reason.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: including comments by Paul McKenney.
> > 
> >     Except, I have deliberately keep back the suggestion to squash
> >     __list_splice_rcu() into list_splice_rcu(), I instead removed
> >     the documentation for __list_splice_rcu(). I am looking
> >     at other existing list_splice*() function in list.h and rculist.h
> >     to get this aligned with __list_splice(), which also has no users
> >     in the tree and no documentation. I find it easier to read with
> >     __list_splice(), but if this explaination is not sound so...
> > 
> >     @Paul: I can post v3 squashing __list_splice_rcu(), just let me
> >            know.
> 
> Removing the comment addresses most of my concerns.  I do have a slight
> but not overwhelming preference for the squashed version, but either way:
> 
> Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> 
> Or if you want this to go in via RCU, please let us know.  My guess is
> that it would be easier for you to take it in with the code using it.

I'd prefer to take it through nf.git, I need this as a fix for an
invalid use of list_splice() on a RCU-protected list.

Thanks for your quick review Paul!
