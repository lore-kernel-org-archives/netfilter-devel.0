Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794917254;
	b=FFaKwCFiqzyIz6duliy9iDQfY0D/XwrUXN1PlbgvUHHZRDnDrUJJ0cn+H8yJ9W7M1TJd
	 ro/0ZQLFvhnVVvhY5fempjHXHsuOuwKNOVSEUpAvu1fvvWH2eWJa4MFeO6AWZfhSB8o9L
	 634UarGjgQV9sv270VpzLeE8P8WE3tSm/BvvDqHUVu24sYrrjMudN1JugzaHDRPA4yxvJ
	 pJGmF5nHsshf/dqAIIX4Rr1ilx6FLJqwqjvYaD6z3zUM1eVKocE/AwwHh+7+B8sihDarz
	 FO2hTHcfIvovJRiPfZekFHXu9snQKNbk9VfMXbUAIhADD7eFH1kk4Odopujn+R4lTog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794917254;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=r96zn6Ugua0efvf7vdqVfaaNOKeHy+IWe2AglZncXAg=;
	b=wXH7bto1n7dxSx8K5BttHJgKtdNaAbuz+LV/WGvEtnESW5NesBA4zIsTQdxRgf1nYnVZ
	 yLkXQyLIWiZTji/3e4QbTqNSurDQMW7YPSytERyWs2E1s3TDSZVgg/jC8J0Y0OHo26Dv+
	 45AGiqIL4Fwc3Q0tfe1SfNUOkOAIHimletbG1g0hAgluH0PE15uRmf6kfZp/iNMy3cH6O
	 8kK9ez0K1rYwXeX+6Fw0FG8EXuvTcQ5khcM6YJRWj+6BblSKfEWyGyIs5Ze/Op8XnyuXE
	 kqf+FKfjvKVvdCHSW5nqdQ083MuqvgbWOLqiqes7kC66n/rsxmGuEgtRqXia5pZ/uhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Mcuej6B6;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B29AA606A334
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 12:07:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B29AA606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Mcuej6B6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794917251;
	bh=r96zn6Ugua0efvf7vdqVfaaNOKeHy+IWe2AglZncXAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mcuej6B6P0byfbaqVGRHZb+MrMHLaDZeFhBqhPv9DdQiU5wF973WX5syLD1YbbxlT
	 JAIFn8y93sbVXoSr4pFgRbCZy2H3D48yNJWOg2yHaZPNTl7RA966FCCBoLBwg/Bh2p
	 e6D48j0GqgsFDf/HAZxHYwykbqitXsoYZk8bEe5l7x7E6oe4Voucvm6EHg7ninewl2
	 6jct+2UqBA/UwXBOaGKlhf6Rrqqiy97NF1hJiKqyXDxswwFV4DKV4bW+tn80BIaVaD
	 HEIefc5UGMn7kRDIWqhzlq41c07BLzD7mxfjPjZSR8qYpKOWFbubPRPmnYnXMV/KcT
	 4G78PQUlVpXPg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3D11A60076;
	Tue, 17 Nov 2026 13:07:31 +0100 (CET)
Date: Tue, 17 Nov 2026 13:07:28 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v10 0/6] ipset: replace internal hash table with
 rhashtable
Message-ID: <avxDgC9R8INTs0oT@chamomile>
References: <20261112143818.30638-1-fw@strlen.de>
 <9a882426-58aa-c14d-fe99-64538c98d293@netfilter.org>
 <avXuJ0GBdzyxK-_w@strlen.de>
 <bbc263cd-5ceb-f183-439b-44909adef4ed@netfilter.org>
 <avbGlZBumFgTJyVY@strlen.de>
 <4075f44d-baca-ce2c-3892-81652ef19ce7@netfilter.org>
 <avn3d1TtvftVLoDc@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <avn3d1TtvftVLoDc@strlen.de>

Hi,

On Sun, Nov 15, 2026 at 07:18:31PM +0100, Florian Westphal wrote:
> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > > > I pushed a few of the test updates to ipset.git, but not this 
> > > > > 3-part-series:
> > > > > 
> > > > > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20261111101603.22698-1-fw@strlen.de/
> > > > > 
> > > > > First one passes on either rhashtable branch or main, but I'm not sure
> > > > > it should :-)
> > > > > 
> > > > > Resp. I'm not sure what the contract/expected behavior of net,iface set 
> > > > > type is when the address matches the net/mask entry, but the interface 
> > > > > doesn't.  I followed existing behaviour, so that test would enshrine 
> > > > > that: it stops matching more candidates.
> > > > 
> > > > Hm, it shouldn't. The expected behaviour is as follows: if the net/mask 
> > > > entry matches but the interface not, then the code should continue trying 
> > > > to find matching entries but just with the same mask value and not with 
> > > > other ones. That way the same net/mask entry behind multiple interfaces is 
> > > > supported and matched.
> > > 
> > > In that case a v11 might be needed; the conversion follows the observed
> > > behavior.
> > 
> > This is strange because the current code does return the expected 
> > behaviour. I have just updated the tests with a case which checks it.
> 
> Thanks, passes for me both with main and rhashtable_v10, I just
> mis-parsed what you wrote...

Just for the record, I'm collecting this batch for the next nf-next PR.
