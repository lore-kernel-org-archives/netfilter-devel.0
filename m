Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A03927CCE4
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 15:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747843120; cv=none; b=KkzlHNVxw/yNvFa1Nc+aD93X8daWyC0MtE+/D0pqfma9Dko2oGg1N/7eDGD7JhYxamQWa7zlLtfgbJJJ2mYgS700qXJP0LIb2C835B+CRJU8SOTXiuOO0/3pVf8rIn8RXIWS1+Ya50lzBACh8z8pVTPKewemFPZfKHSU9CRT4QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747843120; c=relaxed/simple;
	bh=SbFSyj1iYbULqAsNnPRoOnLQK6wLPvxvnSYBvWw3chc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4mjJmWQz9RPZrGFEh9wMKuhqPVhC1mST8ps9JxO8Ww1VzbD/WqGd4ZANG5Q8k+V9/sT+hjHPclNIh3hUHXSWkuhUBuWCXe7yPIME4PD7qhQMMoOZNlJb9XUj7Va3CLWw8C9uE2/QmH+Fvj5G+lJNye5KuFNJzSspxq7eSdEZrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ooosDGe9; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZUPKp/e0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ooosDGe9";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZUPKp/e0"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4EAC5602EA; Wed, 21 May 2025 17:58:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747843116;
	bh=wTjKnDdoSGwycb/dFNUbzHbZLKjSFoeHcl89Onil37A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ooosDGe9J8dXUzoJmdTLBDtVDdyebRtE7CPL2XzRXrMTSJ2rottiV72x53MWks20T
	 hFSu6hz48AGir9y7nwGHV4TRq/Kf4kWVgPI0vjC0d5EywRWl1924jBDwGBARcydfIB
	 BJtX5W8nsF1seyKxhav6hvkdCU3soH3dohTXsLALvV+/PiYiAyKx3Fon5UsN4Vgpf8
	 p/9qK26hdPVLXVgnLG+FhtvRi1B7Qd9UZF8TbF3tG5vaapiDORXIYgiGZ/ViMJGSuj
	 d/GbFvfVZHA1/nFoVzsWcSFsq97prJSyAhvTFME6LZ3tWRfa0whu/BGL3i+a7N6S6q
	 uQaWj4eTpmWYA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E4674602EA;
	Wed, 21 May 2025 17:58:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747843115;
	bh=wTjKnDdoSGwycb/dFNUbzHbZLKjSFoeHcl89Onil37A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZUPKp/e0O7F16jmjzHl3Ar1Bu4EW/syC5V5QWMOSldTdI7K91RalcnXw4OVUikXsn
	 Fun6VLph3nt4J6kMqjNtPmFFRWepJFKor3sY+YkcUquBvc8RiSsguiRnQ4L/3XgvGX
	 CTwJdTpSNUqEDyaNDASOk8N/OMQF6BFchpazMMu7BZw+jJ7ppntql+jRoialyhcRm5
	 Sn3hEXedQC+memQFx3wW9pbYgtT2AXkeybKag/nmJjTd1ghLeLp3tGNrzb7jADF8it
	 x88JknIaOr3E903Qs0EEfAOWMWeriHp9aQMPhfdJwba8/cihC4WjcN19jtZdyrgNHq
	 L87osLRhyTwhA==
Date: Wed, 21 May 2025 17:58:31 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH nf-next v1 0/3] netfilter: Cover more per-CPU storage
 with local nested BH locking.
Message-ID: <aC34JyYurHyf0HRk@calendula>
References: <20250512102846.234111-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250512102846.234111-1-bigeasy@linutronix.de>

On Mon, May 12, 2025 at 12:28:43PM +0200, Sebastian Andrzej Siewior wrote:
> I was looking at the build-time defined per-CPU variables in netfilter
> and added the needed local-BH-locks in order to be able to remove the
> current per-CPU lock in local_bh_disable() on PREMPT_RT.
> NF wise nft_set_pipapo is missing but this requires some core changes so
> I need to postspone it for now.
> 
> This has been split out of the networking series which was sent earlier.
> Therefore the last patch (nf_dup_netdev) will likely clash with net-next
> due to changes in include/linux/netdevice_xmit.h (both add an entry).

Applied to nf-next, thanks.
