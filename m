Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8633E49DE
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jul 2026 16:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784739438; cv=none; b=S0S7YWqKNm8NNX5DtCcU+n3JA1OGVmAttv+HNYo6HOG0YW+Z7ZLjNn+7UB00yZgknMu3fkn2NQt/2eunvSW2hbpuBEpAAJEf9LbBXu+QM4CiHFk19k8SeYTNyFq2iz4ESOyrwG0kfGB4YoKK2wwwNTaH0Qgyic4ir1o6897KBBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784739438; c=relaxed/simple;
	bh=XwwfBjRqVPDpEVNIGSk9MmC+tFrRUKt6b8URKNv64Fs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2IDZzLtDcCw22wkD3idgHBKLblAaPehxSpLbrdvRpGxtRG5A7mbUSIYgq48AdzvtdYgQMp/ATLTV7SR0t8rGklCJLFskrz1pUeN+V4gSoj1iXgLrpLYkPd/+xY55cer/ihtdfenM7Jyqp8VLAOpw7WQwjtFgcbhaDvwTRC6WUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QuHAOrzW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QuHAOrzW"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6A4736019E;
	Wed, 22 Jul 2026 18:57:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784739432;
	bh=HKhPPoFdJU4EossyG8ugJo/9lEiT33unwhpjTnyaEho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QuHAOrzWvr9pO/fCsvibcR6X9J34mXlDt9cQkipmqk3EJksa3tipXxZaak70elGoZ
	 Ypx8PVYOhaalsVofZX+Bume5JcYaV0ybVshtqJz2gJMlxP9Bzy88jz6C5feJlKwCHj
	 MtZ3jrLRrJl62ZoMPNH0vajg+xuBvfFuW8VzZmKDwVfRCBg++GC2Z3ltm67DQiqD07
	 D1y2bVfXtcuSd1RVLjL3BGa6WDM+tKsWnjwdwUmzR9GX0KpwEz2BLdiV6TviPsyxH3
	 ldHeBNLoPQ7XOC0R7qcePdw7AbKNlj+XcBUEzBoRVFiTVjQF7XWsjVQmDmUWilPkTf
	 VKzbV5PUjAJVA==
Date: Wed, 22 Jul 2026 18:57:10 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 6/6] netlink: Call tunnel getters unconditionally
Message-ID: <amD2ZqPDRpu0R4ia@chamomile>
References: <20260603192923.1378815-1-phil@nwl.cc>
 <20260603192923.1378815-7-phil@nwl.cc>
 <aj5oN3PT7_QusykI@chamomile>
 <akeHC8TJrsAJZwkG@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <akeHC8TJrsAJZwkG@orbyte.nwl.cc>

On Fri, Jul 03, 2026 at 11:55:23AM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Fri, Jun 26, 2026 at 01:53:27PM +0200, Pablo Neira Ayuso wrote:
> > Series LGTM, only one nitpick, see below.
> 
> Thanks for your review!
> 
> [...]
> > >  static struct expr *
> > > -netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr)
> > > +netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr, int alt_attr)
> > 
> > Maybe I would suggest:
> > 
> > netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int ipv4_attr, int ipv6_attr)
> > 
> > for easier reading.
> 
> Fine with me! I'll introduce 'int attr' auto-variable then, because the
> code would otherwise conditionally do 'ipv4_attr = ipv6_attr' which is
> more confusing than the original version.

Ok, thanks. Feel free to merge this series once you're done with it.
