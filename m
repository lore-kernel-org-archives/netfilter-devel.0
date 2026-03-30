Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D77615C14F;
	Mon, 30 Mar 2026 11:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774871618; cv=none; b=ujU6ziRHHeca02gJIWyAbeuZS82/tZ3ZbtkJtSxfZsgm1uag3cfNakEFlFLK1AUKj+3Rh6rDqd2HcReESqHLIEoYDGysGf+9Bzu8llQKC9QsVaJPsg0/1WKgqLuBEetaL/rZsEQeUk0OyvvBYEdZado2ycaIxkdiG3/lm7PrCAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774871618; c=relaxed/simple;
	bh=1JZ0jTW6/Psdq1Q4n/yeT/bumjixZkINNq5+rerMfjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xboy5rTd54mnLfWnNwl9vzWNBlO5h+QuNwWLJ5d9JszkT27m9/CNMMjO/ffFLCKq5c5lsOKTQ0AyNHBfQxWz1+H6V6lGdmjBSgtieWlkxi+g4c3oHRiQUNqHfDNvQb67AgN0hrUf2c9jMuYl+4dcq8GjGreSRQZtln4p9nRi2uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Z9fNRKUQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Z9fNRKUQ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1A8D460265;
	Mon, 30 Mar 2026 13:53:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774871615;
	bh=wB9KtHcNwq7byYDCOtHwOwXkHzp7JwSRlR1G+CzBe0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z9fNRKUQ7WdtPbIJaqAa6lAqjpI4qDBNz5AYGd7RFT0zLJHU2KISqyJnGKOzCnKFo
	 KfbeVgAZqvv8vL+MOYJxki6AWupLx8idJMN9flAsf9VU+m5lI+Ks5XgiE9kxfTMbJJ
	 PwQasGhdCsnyWPAW0TAxkVn+vbbWdJDZ9C6vnm/tCy1eOiI1D7eEQorTYXd0L1NH6y
	 SsPvmNkc/Fny/5JMvyRKoCtKOEgN3NvPl/xmmeNGn7S7ff7KbN4/d+Ay0JIJumucna
	 +rCITNFjKfeQR/wenaUHN5YjMHPYvtAzjuRqTIxO35nE0tqg5LY4+tuPUngbW1S10E
	 +vONJc7QhJzLA==
Date: Mon, 30 Mar 2026 13:53:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Qi Tang <tpluszz77@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: ctnetlink: validate expect class against
 master helper
Message-ID: <acpkPEJRvzeY863Y@chamomile>
References: <20260329165131.240989-1-tpluszz77@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260329165131.240989-1-tpluszz77@gmail.com>

Hi,

On Mon, Mar 30, 2026 at 12:51:31AM +0800, Qi Tang wrote:
> ctnetlink_alloc_expect() validates CTA_EXPECT_CLASS against the
> helper specified by CTA_EXPECT_HELP_NAME.  However,
> __nf_ct_expect_check() and nf_ct_expect_insert() later index the
> expect_policy array using the master conntrack's actual helper.
> 
> When the supplied helper has a larger expect_class_max than the
> master's helper, the class passes validation but produces an
> out-of-bounds read on the master helper's heap-allocated policy
> array during expectation insertion.
> 
> Validate the class against the master conntrack's own helper
> instead, since that is the helper whose policy array will actually
> be indexed.
> 
>   BUG: KASAN: slab-out-of-bounds in nf_ct_expect_related_report+0x2479/0x27c0
>   Read of size 4 at addr ffff8880043fe408 by task poc/102
>   Call Trace:
>    nf_ct_expect_related_report+0x2479/0x27c0
>    ctnetlink_create_expect+0x22b/0x3b0
>    ctnetlink_new_expect+0x4bd/0x5c0
>    nfnetlink_rcv_msg+0x67a/0x950
>    netlink_rcv_skb+0x120/0x350

Better to ignore the helper name proposed by userspace when creating
the expectation.

The master conntrack must already has a helper, and such helper must
be the same that is specified here.

I could instead validate that exp->helper == nfct_help(master)->help->helper
but it is not worth, this fix simplifies this interface.

CTA_EXPECT_HELP_NAME still is used for dumping the name.

See:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260330115236.882409-1-pablo@netfilter.org/
