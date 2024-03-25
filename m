Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E910181BBC
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2024 09:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711359243; cv=none; b=ZrdMnvUMuvS46pVuQaM8UKrlOPb8Ap1MLf3qMZas8zYKk9Lwsn8KYS2d/GrwGDLK/YRewOYXYUtMHziymN63yjlboIAVoPXh19k5yst5cN1J1TrwRkfOONe7Un+E7HD1RTkeBCs6wqX6f30qeJK8V0wCOFhbeiX/+PAWku1MbUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711359243; c=relaxed/simple;
	bh=JxanuLmeHF3D/SFc6lr+bUlFkcEGhNHQZMz1a7tcNqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bQ0+HDVREtrzjDer1NZ1E/43lxq5AtoKwcXEbG2B7GrXrXy8n/Fmhmzk1ICkwvs+Qr9xDbopbYXBfaF+0hEtoRmqQgDcsL641Upxq0doiY7UBtn95go3UOylguBAJhK0b0FGlmQ4nT3QS7zjKHteeAfOrvVrXUKXfU3hYFKqAw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 25 Mar 2024 10:33:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net-next 0/3] netfilter: use NF_DROP instead of -NF_DROP
Message-ID: <ZgFFBK6M713zwzB0@calendula>
References: <20240325031945.15760-1-kerneljasonxing@gmail.com>
 <ZgFBn1fuSRoDuk1r@calendula>
 <CAL+tcoAfZh7uGp5EsRvrSpe3mDjmWzSg-sT_4_r9es9iU4Xxdw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL+tcoAfZh7uGp5EsRvrSpe3mDjmWzSg-sT_4_r9es9iU4Xxdw@mail.gmail.com>

On Mon, Mar 25, 2024 at 05:31:19PM +0800, Jason Xing wrote:
> On Mon, Mar 25, 2024 at 5:19 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Mon, Mar 25, 2024 at 11:19:42AM +0800, Jason Xing wrote:
> > > From: Jason Xing <kernelxing@tencent.com>
> > >
> > > Just simply replace the -NF_DROP with NF_DROP since it is just zero.
> >
> > Single patch for this should be fine, thanks.
> 
> Okay, I thought every patch should be atomic, so I splitted one into
> three. I will squash them :)

One patch for logical update, patch description is the same for them all.

> > There are spots where this happens, and it is not obvious, such as nf_conntrack_in()
> >
> >         if (protonum == IPPROTO_ICMP || protonum == IPPROTO_ICMPV6) {
> >                 ret = nf_conntrack_handle_icmp(tmpl, skb, dataoff,
> >                                                protonum, state);
> >                 if (ret <= 0) {
> >                         ret = -ret;
> 
> Yep, it's not that obvious.
> 
> >                         goto out;
> >                 }
> >
> > removing signed zero seems more in these cases look more complicated.
> 
> Yes, so I have no intention to touch them all. The motivation of this
> patch is that I traced back to the use of NF_DROP in history and found
> out something strange.

Yes, it looks like something was trying to be fixed not in the right way.

> I will send a v2 patch soon.

Thanks.
