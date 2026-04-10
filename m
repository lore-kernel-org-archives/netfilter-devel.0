Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624083B8D79;
	Fri, 10 Apr 2026 11:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775819706; cv=none; b=Lr96WIFEkgiUNrAvjbmWJz8kfpqQb3mBicPnYeAc3kcqPQrewmwJWI+h5R0euloKlYyx+Y+gIWnkZ1ReFPl0JYPhKdiE5gNgXknCT/5k8twWgpvFFfPRDkpzPaymj3IcoET7f7oN9fhnBgPpFLYSz1vOwoSMqo1UZCaWWq11Vtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775819706; c=relaxed/simple;
	bh=8eu8GjfNcwmpDh12DHbw8IEt5L3Ifz1hcaq6AJy5lsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MgTSA8CCUclyVu0NhSQHZAOnwuxL3ZeyGcX1kOILYew31JYeKVLYMXNx9J/Iqea3+LN2pHA6R7DnQVMUsf+RNLUbj5skP6SBauUnBKlS2us98UDNq9C8CNzZ5UL6UXU2Jn1I0vmC6ISC0z9xsHNO6oGf8YyNvpBa6Aj4RbgLdBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YUxalXX6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YUxalXX6"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6DB476017D;
	Fri, 10 Apr 2026 13:14:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775819696;
	bh=Mh3S7WIx/yhoFJTOcpC2TOSd4VC6CTJCoUxt3kvMeh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YUxalXX6CIjkCwx+feFuII932EZOeNwp1fzQTNWDzsY/bNxgdnqPgOJpMa+uNdJKF
	 ZwWzf+82QI/F1a46afoOg5q9vvfw6XpY5+qBQvE3VfN9jJ2wmHpQLRbWVv4PMq7F5B
	 mhqVGV7c1VpcUhss1YhC5ciXyg+4VTF/DDiOw4Wxb0+KN2obwOZDZTyExn0r1E8EX+
	 dr51b1Uz0OB42UpZtsRvkaWWrMSU+Sy8NzQP8QilfZM+K2U9Idx3OrsbUzPqpxs3vA
	 J+jM8awH/bxKLa8Ogs5APcbLDE0su4TPO4tcWpupDIfyu7mWGxYzcea4gLxnQ/vfdt
	 F4NYfRJiTK91A==
Date: Fri, 10 Apr 2026 13:14:53 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Weiming Shi <bestswngs@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH nf] netfilter: nf_tables: use RCU-safe list primitives
 for basechain hook list
Message-ID: <adjbrcTOL8MLjtfh@chamomile>
References: <20260410101321.915190-2-bestswngs@gmail.com>
 <adjRiG_Bp3WpRYOz@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <adjRiG_Bp3WpRYOz@strlen.de>

On Fri, Apr 10, 2026 at 12:31:36PM +0200, Florian Westphal wrote:
> Weiming Shi <bestswngs@gmail.com> wrote:
[...]
> > Replace list_move() in nft_delchain_hook() with list_del_rcu() plus an
> > intermediate pointer array, followed by synchronize_rcu() before the
> > deleted hooks' list pointers are reused to link them into the
> > transaction's private list. In the error paths, put hooks back with
> > list_add_tail_rcu() which is safe for concurrent RCU readers (they
> > either continue to the original successor or see the list head and
> > terminate the walk).
> 
> I don't understand the existing code.

I am working on an alternative fix.
