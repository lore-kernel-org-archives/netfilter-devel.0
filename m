Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA792157E91;
	Fri, 27 Sep 2024 11:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727438271; cv=none; b=I0N+k1+PkTvlkrbUlxdN6wMS2KeYsXmbxqtpQrQzWXhZ+lbOAQCtjUnLbCKgo+PNQhnmWtDMXx1tasT0rv57Qt9xtjxHysQtAVL3nVyduNDtW4HpXwLAwcCBD/J4fEuXljtOfZS334n5A/mDs8KYQBThOIM0vrMh53688N2StYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727438271; c=relaxed/simple;
	bh=2/Y9sQJ4WkI/IIqHSwFHU1ts4m2/2S/5GcZSGvVSUFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CAYoTegzKzSGcmZTe8cixsjSvEbH2iGCEsjn/9pLpJmsmqHIPY/e0VIjaVqlNR2nq1QUKQ107Lmn1paKuXt9bR73vhu+DORC+hyxmas1DGxhvgzEVQT1XVBtpYRtJLTIZEqVT0qgX84QV7J0Sup3DOSPVNM2Z8+cic72A2iVdzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=47066 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1su9bT-002vrP-TN; Fri, 27 Sep 2024 13:57:45 +0200
Date: Fri, 27 Sep 2024 13:57:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: prevent nf_skb_duplicated
 corruption
Message-ID: <Zvadt0P6TDZwELej@calendula>
References: <20240926185611.3988042-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240926185611.3988042-1-edumazet@google.com>
X-Spam-Score: -1.8 (-)

On Thu, Sep 26, 2024 at 06:56:11PM +0000, Eric Dumazet wrote:
> syzbot found that nf_dup_ipv4() or nf_dup_ipv6() could write
> per-cpu variable nf_skb_duplicated in an unsafe way [1].
> 
> Disabling preemption as hinted by the splat is not enough,
> we have to disable soft interrupts as well.

Applied, thanks
