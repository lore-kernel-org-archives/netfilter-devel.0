Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB24A364BE
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2024 14:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724942142; cv=none; b=Yo0mKrBdL+EKCi5vTSDeIoHulI5uAduvym95Rkr3k+xfI3fo/H+PsFf6StlHxuSDLDztOwH+IbkIDE9giw/VoeePpfUrlsW8ZHf1RAEK2EuoIIKgQo+rbC8NPMdHsINYG7cJoxSXtdgSXwfCBVVh1UOdtSZNGLQuSyquAU4hnXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724942142; c=relaxed/simple;
	bh=7pxvZ4KKF+1q9BOjxPmLu7dYMAzqmZ9jCRf9TVopuHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rpjguQ+Ivnu76kHR0I8QSiJrsrEesemn1ZdrvPl0r2a8uUPW95uDY+F96h3SMKuE1RaFsbcVgGIa/6c24j3s9vTDkEsggQ4Td53+C3scjglPmgUnRSlV7JipaaXklTDbhvV2cybBX761JbPJQTBXLw2aWr5LwRLSz2NOXlN2d2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SiUJPq/L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SiUJPq/L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724942138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/dVqqBxXvB1LxiMqpe7j5HwkydFU9DSDjkQyA5xFLys=;
	b=SiUJPq/LtNAWFdbKGCIR78MvJq+idBDfvvh0Jy6hPRR/LufmdorvBUCYzwArF2N5iCcAe5
	+9ZIqRE6RPJEs2QSvWefpHBiCg1CAZ4MeBWJ9IBzzYLe8e8neWZSMSt7dy+4Ud2U29w/Ge
	KAhDRDdoWY7RCu4b4CkgOhNutQleIu0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-LiLkKvnzOI25hgFiWrF6Tw-1; Thu,
 29 Aug 2024 10:35:35 -0400
X-MC-Unique: LiLkKvnzOI25hgFiWrF6Tw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACD421955D55;
	Thu, 29 Aug 2024 14:35:33 +0000 (UTC)
Received: from localhost (unknown [10.22.17.151])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4CE2419560A3;
	Thu, 29 Aug 2024 14:35:32 +0000 (UTC)
Date: Thu, 29 Aug 2024 10:35:30 -0400
From: Eric Garver <eric@garver.life>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/5] cache: assert filter when calling
 nft_cache_evaluate()
Message-ID: <ZtCHMk2ez3l-JeTt@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240829113153.1553089-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829113153.1553089-1-pablo@netfilter.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Aug 29, 2024 at 01:31:49PM +0200, Pablo Neira Ayuso wrote:
> nft_cache_evaluate() always takes a non-null filter, remove superfluous
> checks when calculating cache requirements via flags.
> 
> Note that filter is still option from netlink dump path, since this can
> be called from error path to provide hints.
> 
> Fixes: 08725a9dc14c ("cache: filter out rules by chain")
> Fixes: b3ed8fd8c9f3 ("cache: missing family in cache filtering")
> Fixes: 635ee1cad8aa ("cache: filter out sets and maps that are not requested")
> Fixes: 3f1d3912c3a6 ("cache: filter out tables that are not requested")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/cache.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)

Thanks Pablo.

For the series:

Tested-by: Eric Garver <eric@garver.life>

