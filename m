Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697203E9F6A
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 17:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770227913; cv=none; b=XCPbhyc+cFY0OZJF4WEzPxVdG5PXJymZGIghi7E0DCYWdu+2/SUJspNGw13v/Z3C2ebb9S/gr1roASUqq+3M1luUJB8yJpU1Chv+DTqkEnMZbz5I4iPhjao6MnYMrZAE9fUNeoiWQ+yPp2y7t5l0v4S3cI2Js6iz5vYa3/UChrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770227913; c=relaxed/simple;
	bh=dERXO6WnOraZsKSnzDItfs4CXCXxXTgAurwLBb5EMXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1g+dGQ7N2BxtiBDcCliSTbIH9ki2xiDqJe5TizYP6oH3QLg2cNQAolo3qFVqcB9+P86o6nzzpa17Cm613TLpMzR68wNoi3MjHU4Ori7YvRYkYgrsXocEaii/1JO4aPVFYogP5r7mXkfTi4vXp/vHzMXzUFB+dhOjRjE32emzeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=gXIJI/Yi; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="gXIJI/Yi"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id 4F3CDF50;
	Wed,  4 Feb 2026 18:58:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770227904;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yqmGGGL043rpxMoVwjqU105j4KecCtyvW2H7N0tO0RY=;
	b=gXIJI/YiaTq59eVPerZZxOaiSYTgGSUVTc/WhQAO4eeZyEGmyY7bRBn20YLR0rGn
	X/pYBMTL6kHxFWrV7qj5eQvynI8mB8bQXVDxoKmAm/vMNPAjrhe9Ul4xkx7wL7s8GY0
	WYyUye8qlJTcZ+Eo2vN80jccpihR/cXeUwcbrY8TWHkRpWJBCBf8cUeZKoQHwXphl0T
	VIn+Cfszqet6+1GgVc8yRTglGaP3V4FORxVa7/zpoy3UOcN5/2tg4aZfHnl8KP6dGek
	ly3Kqo+Shv6zxacXiKeCDDAuHZFIMaFdC/Qpkid+mE7JzW+brW0LO/OinBa+96Q1zr7
	yTX1ywVPKA==
Received: by smtp.mailfence.com with ESMTPSA ; Wed, 4 Feb 2026 18:58:20 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	brianwitte@mailfence.com,
	kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
Subject: Re: [PATCH v4 nf-next 2/2] netfilter: nf_tables: serialize reset with spinlock and atomic
Date: Wed,  4 Feb 2026 11:58:09 -0600
Message-ID: <20260204175809.5703-1-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aYJ0h5y-KZ29F99g@chamomile>
References: <aYJ0h5y-KZ29F99g@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ContactOffice-Account: com:441463380

On Mon, Feb 03, 2026 at 11:19:46PM +0100, Pablo Neira Ayuso wrote:
> Maybe this so it covers for get and dump path?
>
> static struct nftables_pernet *nft_pernet_from_nlskb(const struct sk_buff *skb)
> {
>         struct sock *sk = skb->sk ? : NETLINK_CB(skb).sk;
>
>         return nft_pernet(sock_net(sk));
> }
>
> in case it is worth to skip the unique nft_counter_lock below.

I have v5 ready with Florian's global DEFINE_SPINLOCK approach:
split into 3 patches (revert, counter spinlock, quota atomic64_xchg),
with nft_counter_fetch_and_reset() wrapping fetch+reset under the
lock so parallel resets can't both read the same values. Tested and
working.

Before I send: should I go with the global spinlock, or would you
prefer the per-net lock via nft_pernet_from_nlskb()? Happy to do
either.

Thanks,
Brian
