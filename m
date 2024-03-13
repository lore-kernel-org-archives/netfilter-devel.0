Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DEA81798C
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 09:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710322814; cv=none; b=KaW8Qto/T/ePNILH1Mk8vhI1gVgN/RI7/c3l2OrvcWgbdYbblkMUFr/s8M/2H/Cnlc6XOGkOuNrAuz0mK0NwkSyzgDNVkmi3I2JLLuzvW+c9K1Hy/Hk5e/Zyd+uVyKROtrPyclAM7MbTP3iRFKmxzHcZwVjLUUYTZXxeRGigzxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710322814; c=relaxed/simple;
	bh=30xatZam48wpTSsHlzX7ubhzIs083odCkjivBGYjhxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soBtyaXSf0FSKWmZS/ELGyKpCPOQmr6AUDsn6LD/q1zSCsljlRK6LPMYKPkGB/VUwyhjeB9m4BET9lNOqGyEuX09umocyyhAPeK8ESjTWCN9klvsvirxpNggVAiNMCHK5CpwoSaKMBxLxZqG1wWRn0ZelcV3bbHRwP75b1e3JU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 13 Mar 2024 10:40:05 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Quan Tian <tianquan23@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kadlec@netfilter.org
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <ZfF0dQTCdg1z0-b5@calendula>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
 <20240312122758.GB2899@breakpoint.cc>
 <ZfBO8JSzsdeDpLrR@calendula>
 <20240312130134.GC2899@breakpoint.cc>
 <ZfBmCbGamurxXE5U@ubuntu-1-2>
 <20240312143300.GF1529@breakpoint.cc>
 <ZfDV_AedKO-Si4-_@calendula>
 <ZfECzgo/mYkMvHXA@ubuntu-1-2>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfECzgo/mYkMvHXA@ubuntu-1-2>

On Wed, Mar 13, 2024 at 09:35:10AM +0800, Quan Tian wrote:
> On Tue, Mar 12, 2024 at 11:23:56PM +0100, Pablo Neira Ayuso wrote:
[...]
> > I don't have a use-case for this table userdata myself, this is
> > currently only used to store comments by userspace, why someone would
> > be willing to update such comment associated to a table, I don't know.
> 
> There was a use-case in kube-proxy that we wanted to use comment to
> store version/compatibility information so we could know whether it
> has to recreate the whole table when upgrading to a new version due to
> incompatible chain/rule changes (e.g. a chain's hook and priority is
> changed). The reason why we wanted to avoid recreating the whole table
> when it doesn't have to is because deleting the table would also
> destory the dynamic sets in the table, losing some data.

There is a generation number which gets bumped for each ruleset
update which is currently global.

Would having such generation ID per table help or you need more
flexibility in what needs to be stored in the userdata area?

> Another minor reason is that the comments could be used to store
> human-readable explanation for the objects. And they may be change when
> the objects' functions change. It would be great if they could be
> updated via the "add" operation, otherwise "delete+add" would always be
> needed to keep comments up-to-date.
> 
> However, I don't know a use-case for back-to-back comment updates, I
> will check which one is more complex and risky: rejecting it or
> supporting it.

We have these back-to-back update everywhere. The original idea was to
allow for robots to place all commands in a batch and send it to the
kernel, if the robot adds objects and then, while the same batch is
being collected, another update on such object happens, including one
that cancels the object that was just added, this is accepted since
this nonsense is valid according to the transactional model.

In this transactional model, batch processing also continues on
errors, rather than stopping on the first error, error unwinding is
special in that sense because objects remain in place and are just
marked are deleted. This allows for getting all errors to userspace at
once.

It is harder than classic netdev interfaces in the kernel.

Florian has concerns on this transactional model as too hard because
of the recent bug reports. If the direction is to tigthen this, then
I think all should be revised, not just reject this userdata update
while everything else still allows for back-to-back updates.

This is of course not related to your patch.

> > I would like to know if there are plans to submit similar patches for
> > other objects. As for sets, this needs to be careful because userdata
> > contains the set description.
> 
> As explained above, I think there is some value in supporting comment
> update for other objects, especially when the objects contain dynamic
> data. But I understand there are risks like you mentioned and it would
> need to be more careful than tables. I would volunteer to take a try
> for other objects, starting with objects similiar to tables first, if
> it doesn’t sound bad to you. Please let me know if you feel it's not
> worth.

I am not saying it is not worth, and I am trying to understand your
requirements in case there is a chance to provide an alternative path
to using _USERDATA for this.

Thanks for explaining.
