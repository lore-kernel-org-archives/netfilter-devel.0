Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A109A6FBF
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 15:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734553; cv=none; b=ZgZPihL5Jzk2lf7Jc+mUqzm/c33LUKaGpTAYte1I5XnmaZ/GWC4YLLgdxspaf1xHWsgSM+7mcycFR4roZUOxkRvBR8EqYpvWCtO7wxP5dxT9cGYw2ixlVogtrpPVWUefinGw2C5WloxyKOj+PPPcHyo+5Y4EWb0KI3JqGm60/J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734553; c=relaxed/simple;
	bh=gf81vtaB596XYWqOO7mXdH4jGevjT9LZV3y3oOj5Lwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzRR3SHa2Z+xC12QKHrfhJ6fmvOZZ8l2xBlG04yrGp8H9DKeMX8aZyKyKYlDP31s9pehqyzPbWwVgl1JMkEtVuiikv+ab7d2ACGiKLDlALcG6Yq+9RFmL1G3Aydmycc9bAoF/+z3ppu2+rLMZlYH9zmE0nVtFLCAvnIiNkITpqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aU7zo/wW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aU7zo/wW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723734550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bkfXzkPzfeWBajtPgkDcrUqKZa7evyA2dWo4YnfNcNA=;
	b=aU7zo/wW7IAPCxilsCyOMBXzhbTkLQDOV8hVLfPubcpmMIY83gk1qR+tP7+xDPjLA64pOt
	85ZzZDpDrB9fcbsO5OJr9vsKSDpBiZaXVytpELVRRWFl7F4rGoLm4yFBKyAAbSayHQWa9E
	r7NbTV6EctpAQd1Ah10/SUFbBQIwe+U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-goTfL7EUN9yUpJ2yxoHCQw-1; Thu,
 15 Aug 2024 11:09:06 -0400
X-MC-Unique: goTfL7EUN9yUpJ2yxoHCQw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE5901955EB3;
	Thu, 15 Aug 2024 15:09:04 +0000 (UTC)
Received: from localhost (unknown [10.22.9.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9077D1954B1A;
	Thu, 15 Aug 2024 15:09:02 +0000 (UTC)
Date: Thu, 15 Aug 2024 11:08:58 -0400
From: Eric Garver <eric@garver.life>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de, phil@nwl.cc,
	fw@strlen.de
Subject: Re: [PATCH nft 0/5] relax cache requirements, speed up incremental
 updates
Message-ID: <Zr4aCjGwkedu9ssB@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de, phil@nwl.cc,
	fw@strlen.de
References: <20240815113712.1266545-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240815113712.1266545-1-pablo@netfilter.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Aug 15, 2024 at 01:37:07PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset relaxes cache requirements, this is based on the
> observation that objects are fetched to report errors and provide hints.
> 
> This is a new attempt to speed up incremental updates following a
> different approach, after reverting:
> 
>   e791dbe109b6 ("cache: recycle existing cache with incremental updates")
> 
> which is fragile because cache consistency checking needs more, it should
> be still possible to explore in the future, but this seems a more simple
> approach at this stage.
> 
> This is passing tests/shell and tests/py.
> 
> Pablo Neira Ayuso (5):
>   cache: rule by index requires full cache
>   cache: populate chains on demand from error path
>   cache: populate objecs on demand from error path
>   cache: populate flowtable on demand from error path
>   cache: do not fetch set inconditionally on delete
> 
>  include/cache.h |  1 -
>  src/cache.c     | 23 ++++++-----------------
>  src/cmd.c       | 23 +++++++++++++++++++++++
>  3 files changed, 29 insertions(+), 18 deletions(-)

I applied this series to nft master and tested it against the latest
net-next and RHEL-9 kernels. No issues or regressions found.

Thanks Pablo!

Tested-by: Eric Garver <eric@garver.life>

