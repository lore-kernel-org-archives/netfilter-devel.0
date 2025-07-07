Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E371625394A
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Jul 2025 19:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751914991; cv=none; b=lvN52md9neeiKNwobyLXao/H0OJ2f/FkYH8vj4ZAPPDswZ1FAJPMfg7p7wZE7S0tsiOr8BZWMs+E0Mi2tr7l5uyocTRZRqJ1+vCC3ysHcoH05RZLquEJcZ/MMGM+/fapRSdEzWZqqN7hvHm1OKbEBkVw4iutWd5AIcxTkSZzRfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751914991; c=relaxed/simple;
	bh=nIgkPN+PP5iw3VCzAqDGQOv/4OQXI8Zsj/GrNpwADrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ff+PtvKWGJoBqQhmqjvnYr3RSq1nsW2YyLfd7Tl6mdR13bdaffuJQwQ0UxD5itolgcthTGgihBfNOVN+WPMLGBA8t3+GOEvig45waBhBk87B9F7xc0rFwulElF5DbDSalAI+YBHnXsRP234isQfbJzOz8R2SQGKBU+O4l7N33Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dZuwRzd5; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dZuwRzd5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dZuwRzd5";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dZuwRzd5"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7679C60265; Mon,  7 Jul 2025 21:02:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751914979;
	bh=/0qCGJNMsZT1TIC6LzeCTXJ55QicPU8jFqsh4tx+rok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dZuwRzd5u/0LWuBluhK2bYVAi7hZPgbuLkhpZpkgKcnCY6n449+deFowbsTQXv1+e
	 kmpRU2fzHTC2i3BatJN4dzMWAJ06yzysf+LBdYPrZbJ/MvWptkGRxOlhIy82t0iaGc
	 436Xh2uESFoCl9+1d8JMlQi9wMxl3sE+WoxOe6ZKTz4p0E64J9mEvSNSWENFsmJ+3V
	 3P+UHhwOZZvXKTucr+XKEHE/36o/nkBNfcvQYVV+hH9G6KsDZEYXuBeM+D8FKyDm9H
	 UQm/3+nUdiHb2nBLfVtrSQi8rnAbAJ7RIYjubxysfznCSSveUp4tN6rkOzX4jUcJ2Q
	 AixZ50PXfJU1A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DF0DE60265;
	Mon,  7 Jul 2025 21:02:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751914979;
	bh=/0qCGJNMsZT1TIC6LzeCTXJ55QicPU8jFqsh4tx+rok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dZuwRzd5u/0LWuBluhK2bYVAi7hZPgbuLkhpZpkgKcnCY6n449+deFowbsTQXv1+e
	 kmpRU2fzHTC2i3BatJN4dzMWAJ06yzysf+LBdYPrZbJ/MvWptkGRxOlhIy82t0iaGc
	 436Xh2uESFoCl9+1d8JMlQi9wMxl3sE+WoxOe6ZKTz4p0E64J9mEvSNSWENFsmJ+3V
	 3P+UHhwOZZvXKTucr+XKEHE/36o/nkBNfcvQYVV+hH9G6KsDZEYXuBeM+D8FKyDm9H
	 UQm/3+nUdiHb2nBLfVtrSQi8rnAbAJ7RIYjubxysfznCSSveUp4tN6rkOzX4jUcJ2Q
	 AixZ50PXfJU1A==
Date: Mon, 7 Jul 2025 21:02:56 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/2] src: add conntrack information to trace monitor
 mode
Message-ID: <aGwZ4MKAhUQWuGiL@calendula>
References: <20250707094722.2162-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250707094722.2162-1-fw@strlen.de>

On Mon, Jul 07, 2025 at 11:47:12AM +0200, Florian Westphal wrote:
> First patch is a preparation patch that moves the trace code
> from netlink.c to the new trace.c file.
> 
> Second patch adds the ct info to the trace output.
> 
> This patch exposes the 'clash' bit to userspace.
> (Technically its the kernel counterpart).
> 
> If you dislike this, I can send a kernel patch that removes
> the bit before dumping ct status bits to userspace, let me
> know.

If this is intentional, then

+             SYMBOL("clash",         IPS_UNTRACKED_BIT),

hiding clash bit is probably a good idea.

Just hide it from userspace nftables in this series, later I'd suggest
you proceed with the kernel update.

Thanks.
