Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ADF41A80
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jul 2024 11:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721821920; cv=none; b=ZXMAzHsmr62MC1oiIjY3wuVSJqdP5mUXycOWb1NtjEXkqEP8Hhe8cRklLHxAhtjwvZsggmq48aTiZOp60c8l/Uc0H8jObTjrK35XZTUQ/Q9wS5bUUCbbOddr6DEiB/L1uoKJhLzDzxsQ8V6iubFPyv8/pAC1qNrTBUAyWGcEb6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721821920; c=relaxed/simple;
	bh=mBRJ8ziRl/guNcWjRwic8mfNLxfyh94ZcS3KPAHBIt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D9tsCZewlThPdifvuzNh3rLoTp73yR9kxtpKXKAZqC/4NqFjrxMvrAXAlFvnqkxSPBXY5ocZBSpruOZYTUxCDvgLNmYh4h7BqL+h+hQywQUJd3wuStX3GXRRbxR4jNx7tMJXRrJjRFsB/FqM/WHK+KhAkf6ldPtJbBqhXo6aMdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BRgabST9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BRgabST9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721821915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tIvvpT8HTDg/QlDX5ECCz7hpRVrhQm0J8khMRwgwCRQ=;
	b=BRgabST9RoofRibz/WI294GsVfSlRn9SvJzkwOKvfKUNh4FfrvHX9DRR1dx8j6jCvh4Ro+
	Bn1v4z2j5lDD7nBzOH10OHe+Ki4M25eyH/06HKqbRpy6BBgEhbSuZq/jepsJ29gqqx5DsV
	Q4yfrmHtdYVujp1lHiuocFTSISBlly4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-465-_-ug8NCANfeCMgwVy54e4Q-1; Wed,
 24 Jul 2024 07:51:54 -0400
X-MC-Unique: _-ug8NCANfeCMgwVy54e4Q-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 530E21955D4E;
	Wed, 24 Jul 2024 11:51:52 +0000 (UTC)
Received: from localhost (unknown [10.22.32.181])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 576C41955D42;
	Wed, 24 Jul 2024 11:51:50 +0000 (UTC)
Date: Wed, 24 Jul 2024 07:51:48 -0400
From: Eric Garver <eric@garver.life>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	nhofmeyr@sysmocom.de
Subject: Re: [PATCH nft 2/2,v2] cache: recycle existing cache with
 incremental updates
Message-ID: <ZqDq1J8js7xHjwSk@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de
References: <20240528152817.856211-1-pablo@netfilter.org>
 <20240528152817.856211-2-pablo@netfilter.org>
 <Zp7FqL_YK3p_dQ8B@egarver-mac>
 <Zp7QSXcMHt9a8Hm7@calendula>
 <Zp-afhWpdM9R4hco@orbyte.nwl.cc>
 <Zp-fx35ewU1n8EE5@calendula>
 <Zp-_adFRy9PbvYXU@orbyte.nwl.cc>
 <ZqAEv1grG6B8xzvt@egarver-mac>
 <ZqCw126I4VRE0xKJ@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqCw126I4VRE0xKJ@calendula>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Jul 24, 2024 at 09:44:23AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 23, 2024 at 03:30:07PM -0400, Eric Garver wrote:
> > This patch fixes the failures around the index keyword. I see one more
> > issue around set entries.
> > 
> > Notably, if the set add and element add are on separate lines (and thus
> > round trips to the kernel) then the issue is not seen. Perhaps there are
> > more instances with other stateful objects.
> > 
> > --->8---
> > 
> > # cat /tmp/foo
> > add table inet foo
> > add set inet foo bar { type ipv4_addr; flags interval; }; add element inet foo bar { 10.1.1.1/32 }
> > add element inet foo bar { 10.1.1.2/32 }
> 
> Thanks for your reproducer.
> 
> I have reverted it:
> 
> https://git.netfilter.org/nftables/commit/?id=93560d0117639c8685fc287128ab06dec9950fbd
> 
> This needs more work and tests.

Thanks Pablo. I'll keep my eyes open for future cache patches.

