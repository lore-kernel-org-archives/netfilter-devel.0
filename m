Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E331DFD1
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2024 12:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705495506; cv=none; b=uGzFz/weKz1zBBXuKeUOwitTmaB5KkrvWSOYoZimWvKLbQ9P+TG4LXLp9VfegXpr3188XfIoI7RSV504QDyyxYVx56mzVzjxmB81UUSH4ZdOVmZvaVJXIwRkjsaL+SNMnjwFYJ6Fvs8Axurb3cFT1nUN3cc7gTQPtr5orvWPgqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705495506; c=relaxed/simple;
	bh=3TTmRXTenhuvewvwRNr/Oy0G5Anls5dxsvWnIOquZ0I=;
	h=Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Spam-Score; b=k5T+6PIgCCTwlOFUPgomhKiwxhGcZnrlgs0juMH+xTauWcrFo8b3Ty576o+t6/z+mYKtfLYbO49fdLorUj/T7IsJCaej1uQuN5kMw9Qvm+OylxzO4R6RBtQExJdg+ZvYyAQ83T4kMhMVREn7IYCsxljAPf7A53L33hpKvZWDFV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=34298 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rQ5Hu-00DsHr-Lo; Wed, 17 Jan 2024 13:45:00 +0100
Date: Wed, 17 Jan 2024 13:44:58 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Ale Crismani <ale.crismani@automattic.com>,
	David Wang <00107082@163.com>
Subject: Re: [PATCH 1/1] netfilter: ipset: fix performance regression in swap
 operation
Message-ID: <ZafLyrzDb29HaX9Q@calendula>
References: <20240116162956.2517197-1-kadlec@netfilter.org>
 <20240116162956.2517197-2-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240116162956.2517197-2-kadlec@netfilter.org>
X-Spam-Score: -1.9 (-)

On Tue, Jan 16, 2024 at 05:29:56PM +0100, Jozsef Kadlecsik wrote:
> The patch "netfilter: ipset: fix race condition between swap/destroy
> and kernel side add/del/test", commit 28628fa9 fixes a race condition.
> But the synchronize_rcu() added to the swap function unnecessarily slows
> it down: it can safely be moved to destroy and use call_rcu() instead.
> Thus we can get back the same performance and preventing the race condition
> at the same time.

Manually applied this to nf.git, thanks!
