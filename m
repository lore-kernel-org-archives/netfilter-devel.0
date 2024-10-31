Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F301A2C25
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 15:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730387705; cv=none; b=t/WIvM45IybbWLu8a1jiIFq2Yt2X50jNRZG+Gns7KoJiDggfT0/VGIXm0e9CaWHU6E864gMOHDBhlqzcFib8Mmt0u6jYm5D7PT/oI47oxYgPMiF+C6uwhZsedaGshTrCOoQMtT+oc4ljG2a2iqkfHyAKKBKqLmFYah+YcF7Lnkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730387705; c=relaxed/simple;
	bh=2u4Kgu8OJJXuIjvhJcDNARDAPjn8KaNOe0H2ZtfdeY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VD6dqFIEKMeuY8tgbkGzAs6mp6kvsLJtB5vZQ2GjZOMmA4Lyjv3JUJu1sTRgTWsyIMk11Regh/73AD62sYXxFzyGyZaTdHgeLXb0Q0SoW+3m4C1OXXyd+WsfVDDd721dqaxilqp4kGBaC7MXzrRT3p4ytCit1VBlnU1pp7Z5YZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fXRIv5lM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fXRIv5lM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730387701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fBBz9r/PKD7kuX4Cjj+rqLQISrAv6LRiAgOumnhmwic=;
	b=fXRIv5lM9EReS7RCZGdhDIYQvo3tNUzHvRSBtafk0BVYl7R/9itq9mdMupzOhkRVlgvlXi
	mTKHthSfXaXanZb/IOY9Wsy226Lo5vaMeKTA95Tn22Kos/n2F+ldqToYzK8+KDtMd1p5j4
	QKx+PxeaEGyv/PEQpl/X3xlO5a8Uk3Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-440-e1-qOiPyPq-o8a8eYY3VrQ-1; Thu,
 31 Oct 2024 11:14:57 -0400
X-MC-Unique: e1-qOiPyPq-o8a8eYY3VrQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C26B19541B3;
	Thu, 31 Oct 2024 15:14:56 +0000 (UTC)
Received: from localhost (unknown [10.22.64.65])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 13508300018D;
	Thu, 31 Oct 2024 15:14:55 +0000 (UTC)
Date: Thu, 31 Oct 2024 11:14:53 -0400
From: Eric Garver <eric@garver.life>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: collapse set element commands from parser
Message-ID: <ZyOe7fOjPZExHJFm@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241023133440.527984-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023133440.527984-1-pablo@netfilter.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Oct 23, 2024 at 03:34:40PM +0200, Pablo Neira Ayuso wrote:
> 498a5f0c219d ("rule: collapse set element commands") does not help to
> reduce memory consumption in the case of large sets defined by one
> element per line:
> 
>  add element ip x y { 1.1.1.1 }
>  add element ip x y { 1.1.1.2 }
>  ...
> 
> This patch collapses set element whenver possible to reduce the number
> of cmd objects, this reduces memory consumption by ~75%.
> 
> This patch also adds a special case for variables for sets similar to:
> 
>   be055af5c58d ("cmd: skip variable set elements when collapsing commands")
> 
> This patch requires this small kernel fix:
> 
>  commit b53c116642502b0c85ecef78bff4f826a7dd4145
>  Author: Pablo Neira Ayuso <pablo@netfilter.org>
>  Date:   Fri May 20 00:02:06 2022 +0200
> 
>     netfilter: nf_tables: set element extended ACK reporting support
> 
> which is included in recent -stable kernels:
> 
>  # cat ruleset.nft
>  add table ip x
>  add chain ip x y
>  add set ip x y { type ipv4_addr; }
>  create element ip x y { 1.1.1.1 }
>  create element ip x y { 1.1.1.1 }
> 
>  # nft -f ruleset.nft
>  ruleset.nft:5:25-31: Error: Could not process rule: File exists
>  create element ip x y { 1.1.1.1 }
>                          ^^^^^^^
> 
> there is no need to relate commands via sequence number, this allows to
> remove the uncollapse step too.
> 
> Fixes: 498a5f0c219d ("rule: collapse set element commands")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Hi Pablo,

This patch appears to introduce a performance regression for set entries
in the JSON interface. AFAICS, the collapse code is only called from the
CLI parser now.

E.

