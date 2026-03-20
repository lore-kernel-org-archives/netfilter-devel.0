Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B63C36BCC2
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 12:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774008596; cv=none; b=C9B2uQG1Q7/SYQzBszNYWVH9ydKOndeK8396m2efJOINPgJznXOnhOhjLgnH1Wml9R1MiNoN2Y2toZhtfFqxBBc3FYpzAiIuzYMCzVaE8XO8vk7dPGDjh7YpGlYVA2Ab5qLftJa49ikbVyW040V5v8QBLMPqc7u6/TE6yjapeVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774008596; c=relaxed/simple;
	bh=11c3yNRB3iTgY/Pcm3RqEpQho3C8adaRaN7YbBbRZts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fyBIfOH92zq82jTTebBvuRApK9tg99a32X343oTP7ruHVSKTfvVHyjlNdsx3OIQDZEmi7SrQ8sqppx4E0N9tXTky2lKDZ8JJnibR2wWKDk9doK8q7CjTgrTkYWl/2pikpNME1uFVyFdyLlDyO3hkL55nEwGE92kQ3j1PRaYaf3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cmZmh6/U; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cmZmh6/U"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9CE8960179;
	Fri, 20 Mar 2026 13:09:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774008593;
	bh=Gyc7vqlq5gQ9Jwz3/xMIHatWWURCzucgyP4zAltdtGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cmZmh6/UrY0FQTTd8Wc8WU0+ggzsKQjJ5Togy0wdL9ThLivqcF7Orfo+vN0RWK7r9
	 1SjGRtAe/jIWPquwTxki8DybqBrIqLkE+/Kb9swwwVi4argUzagQEL6tGjUPM6RLCe
	 SEAiMN2jsisafERIVJcXRrJn+GjjTHbMgJoYsZGK4GpIPTcgp7x7ashcX0w19CaHXo
	 apB1n8MgY46jHpjsW/DKlZpAu4CgYZ0KDrKb5+cZ6kFwaRqf+1JHSEg5opGyHYUvtq
	 xXuZJSswf0gfZXb33HbfKA8ikAjaI4H7tYcnMZaoYGb7Ro9/czOGCgtjrd4yCJvaX8
	 QHouYwSNtK2uQ==
Date: Fri, 20 Mar 2026 13:09:50 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/1] netfilter: ipset: Fix data race between add and list
 header
Message-ID: <ab05DjDyx_ZOksqY@chamomile>
References: <20260320114041.3486273-1-kadlec@netfilter.org>
 <ab03vtQI7WWq9puC@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ab03vtQI7WWq9puC@strlen.de>

On Fri, Mar 20, 2026 at 01:04:14PM +0100, Florian Westphal wrote:
> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > Hi Pablo,
> > 
> > Please consider applying the next patch:
> > 
> > * Fix data race between add and list header commands in all hash types 
> >   by protecting the list header dumping part as well.
> 
> Thanks Jozsef for the quick fix.
> Just to be sure, is this nf-next or nf material?

I think this is nf material, to deal with the KCSAN report from
syzbot.

> And, what do you make of:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260313180132.75655-1-davidbaum461@gmail.com/
> and
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20250722153205.4626-1-phil@nwl.cc/
> 
> ?
> 
> Thanks!
