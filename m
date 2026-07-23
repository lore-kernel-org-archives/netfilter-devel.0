Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD81018871F;
	Thu, 23 Jul 2026 10:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801699; cv=none; b=cQrS7J9rz4uBkS5IcalIdyCiBTFOioyzpccvgc/eLabb5lSkD9nnnsOUHH20YJWGS8CVgEWplrdSlaMB46tzlDntP8PpP6OzKBfWRKMGUsnVIjmOpm1w6Cqp2xsYDt2MilHtye8cN3VlZWCAlzjke7vqr9naSCO8t4cugqbCzCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801699; c=relaxed/simple;
	bh=DAKM3zPhPc1mJa0stWofZUFsZ9Jw0eBtP8fpd24dGsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U9HAIzVUrdsUHvGxZFKpQhWQy2FjAfkaapplqEjDV+gOOJSmMR8+JwxBUWHnuMXWtsMHmfSf4Ee9vieEs+hI814hWb+1/areeVweonuj9+MNi79cuqujpyXxzGKp62je6b5qX9aWCcqnBqqbUlq1O6st6jKKHHCDkFSn0O1eL4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=p9b3EZbZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="p9b3EZbZ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CB6B660191;
	Thu, 23 Jul 2026 12:14:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784801692;
	bh=DAKM3zPhPc1mJa0stWofZUFsZ9Jw0eBtP8fpd24dGsI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p9b3EZbZQYQGs6PIx13G6uJYz3ui78ERXO8x/unOJ15BuMHL6L2HoxQjeFgnUUJyZ
	 VGVUHF0kdA5gEyDpHsJhxDUK4bEdqSzXA0B43SNH0TsI+dvkmjJT61rExRlGEuRKko
	 umvyDyByPFKT2+m3oDhpqnA36r3d/W5bYivJguf30DhOODY9uwbTGpJOiO2y+xPes+
	 dD1oKMsWxuoTkBOjtnAb89HmjmY7YHaXnmlt28Zu0HQKPxGK/8ARp/FLfXkgAH95Fa
	 3L4T5f2rn99JHB5HkW46vrzTqADMcd3NSqTjdlS98j1Rpfct8yjsY9yUiv4i97rzPv
	 G51GqwonQurjw==
Date: Thu, 23 Jul 2026 12:14:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jaeyeong Lee <iostreampy@proton.me>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	sveyret@gmail.com, coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: conntrack: prevent helper extension
 relocation
Message-ID: <amHpm2FBj8QSgI4W@chamomile>
References: <20260715144755.00ea7dfcd9f@proton.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260715144755.00ea7dfcd9f@proton.me>

Hi,

On Wed, Jul 15, 2026 at 02:48:23PM +0000, Jaeyeong Lee wrote:
> nf_ct_ext_add() may relocate an unconfirmed conntrack's extension blob
> when the current allocation is too small. struct nf_conn_help embeds the
> hlist head for the master's expectations. The first expectation's
> lnode.pprev therefore points into that extension blob.
>
> An nftables CT expectation object can link an expectation before a later
> NAT expression adds extensions to the same unconfirmed conntrack. If an
> addition relocates the blob, the copied hlist head still points to the
> expectation, but the expectation's pprev continues to point into the
> freed old blob. Removing the expectation later executes hlist_del_rcu()
> and writes through this stale pointer.

Thanks for your patch.

For the record, I'm exploring an alternative fix from nft_ct
expectation support itself, patch should be available in the next
days.
