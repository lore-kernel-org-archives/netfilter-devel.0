Received: from sphereful.sorra.shikadi.net (sphereful.sorra.shikadi.net [52.63.116.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92DA380
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Apr 2025 00:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.63.116.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745453057; cv=none; b=bUcyMY3lLvPXqiwZR4QCRC66y7vZ/mUMsNhuuR1Qk+BIUpMLh3D/pyl2R1ccB/4apUPc/8Z2CNegzxBb5tlyonS6MWHkiKiOug11OKNTJyPTNhQHRb2v72klFDUIfzlH/QcRQ3D2iKeQh1Wc29rvT1dg2p+GteaucZLKjhVZKZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745453057; c=relaxed/simple;
	bh=uHOfqu/4P+VjqEfGf8c6KTxBZH8+39jYsLXxxvZwws8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pjstmE7Z6+CYmIVF2JVumq60Uo0VcPzTtCzOvELEpr5x8XVjEJR9fUvj2AW2onCVOCB1brN61sLLqLLfkbFA/AHIci8kuO7hk97bsc2s2lHkI3ucd0W9O9e6cyU0FUhxMDymA6UB/JerNmkDAHrgY2SDyVu9+3i+sqgD98IIfUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=shikadi.net; spf=pass smtp.mailfrom=shikadi.net; dkim=pass (2048-bit key) header.d=shikadi.net header.i=@shikadi.net header.b=KuToz1BL; arc=none smtp.client-ip=52.63.116.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=shikadi.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shikadi.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shikadi.net header.i=@shikadi.net header.b="KuToz1BL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=shikadi.net
	; s=since20200425; h=MIME-Version:References:In-Reply-To:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=QY+G7qHj7f3DvCxzl7W/J4LyudVt03Rkf/Gj8PfZH50=; b=KuToz1BLNZN3bef9RR20kA4/D9
	RPDY9rNgd4dfdZ4yTXcVH1e98dGU4ghBdkZaXXUJ89h9Qf98H8ER5oEri8Amn6cgiolsIiM94SJ0j
	86obCBHFQmHF+ZhMd6OHezSOafzyVKdEVifAp41T9+b+O9Vb51MKCuEzFFXZSEJ5M15HT/wwZFTEB
	9TYmWLHkFOlbVHbY6dc26LkhLkEVnjbtK9tr7PL8knfiTiLjL+CKnttgAS4DDEQe/gfR8zUwNuE/D
	h7n8haCvghVU1YswnVPPYwb3mmf0FudPAaW0f54XIqCuqe5V7sf2i+KnrrTf6eKbTi+f+irXOmoqW
	jW1Cmn/A==;
Received: by sphereful.sorra.shikadi.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <a.nielsen@shikadi.net>)
	id 1u7k4a-0001j2-1G;
	Thu, 24 Apr 2025 10:04:12 +1000
Date: Thu, 24 Apr 2025 10:04:09 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xshared: Accept an option if any given command
 allows it
Message-ID: <20250424100409.5f9ca598@gnosticus>
In-Reply-To: <aAl6WkT9vx1IT1-8@orbyte.nwl.cc>
References: <20250423121929.31250-1-phil@nwl.cc>
	<aAlXGcRNV4AkXGk-@orbyte.nwl.cc>
	<20250424085803.73864094@gnosticus>
	<aAl6WkT9vx1IT1-8@orbyte.nwl.cc>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.48; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

> > Hopefully it won't be too long until the next release, given the last
> > one looks to have been a couple of years...  
> 
> Something between 6-12 months?
> 
> v1.8.11: Wed Nov  6 11:47:59 2024 +0100
> v1.8.10: Tue Oct 10 11:20:12 2023 +0200
> v1.8.9:  Tue Jan 10 17:46:43 2023 +0100
> v1.8.8:  Fri May 13 15:26:12 2022 +0200
> 
> There's no rule though, we tend to release whenever there's "enough"
> pending work. Right now we're just 14 commits in, I'd say we keep
> collecting a bit more. :)

Fair enough.  I think the previous release sat in my distro's repos for
around 18 months before we got 1.18.11, so I was hoping I wouldn't have
to wait that long again before 1.18.12 comes along and gets my
bandwidth monitoring scripts working again!

I'll probably do a custom package with the git version, then I can get
things going once more without hassling you for more frequent
releases :)

Cheers,
Adam.
