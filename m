Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87467265CAF
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Apr 2025 18:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914123; cv=none; b=VA0TdyhVRdLfCtjqbWGWJo/7VWlIxOJRlb/RO7jMCyVFOGlqEC8KDarEOvgLhGH4d88QE7qbchfxFjwoiPNBOWhfn7pewAbM+/AUtovJpMjdtpPd2/tvFYzl7Va/Cga2eKZ4bIjzYfmJIon7rAo0PdQQdd3JIGbj+4s+QpYcqxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914123; c=relaxed/simple;
	bh=shCdNbozHqkaJl7SEe3UdnLSz0iY2Gmm33awXqt2noA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXU+NhmhFwizj/3jgOP0V6elvS8sSUGk2819zZUuIfef2uP9JrVt8++bw4RreuxLtF/W9ABuH+pLhGENuhH1gghE2fo8ysMCzWXWBuJ41F9eylt32OyG455qwo+IAe8H5xRU9OG70iyWfifIwDpujIm9jivnce/tFMx8PrRlpB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jTmKvgSl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jTmKvgSl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744914120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UEu2swHZw6SrQ/GBh9hVEnM+N2pIOK3vtI/5XlC99ek=;
	b=jTmKvgSl4890xZBILAN9hC3nOHHwUWDIbsRZOdlcIWt4YBSk9MBSqKAsTacBEqZgrDOWeL
	Cwp/dIfDjSb/YoT7dy2Y8f0oa3nesTizOIIkpWdxWxSMdxYGF8+Q1EWb/m9UfznpivZteN
	PQLVbEBWrgJpgv2v39j0SyCtXXpmu5I=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-bwZ66JFMOlmB--giRPBvqw-1; Thu,
 17 Apr 2025 14:21:54 -0400
X-MC-Unique: bwZ66JFMOlmB--giRPBvqw-1
X-Mimecast-MFC-AGG-ID: bwZ66JFMOlmB--giRPBvqw_1744914113
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with UTF8SMTPS id 34F531800876;
	Thu, 17 Apr 2025 18:21:53 +0000 (UTC)
Received: from localhost (unknown [10.22.65.170])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with UTF8SMTP id 699341800D9E;
	Thu, 17 Apr 2025 18:21:52 +0000 (UTC)
Date: Thu, 17 Apr 2025 14:21:49 -0400
From: Eric Garver <eric@garver.life>
To: Jan Engelhardt <jengelh@inai.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [nftables PATCH v3] tools: add a systemd unit for static rulesets
Message-ID: <aAFGvWycJoFnwG3q@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>,
	Jan Engelhardt <jengelh@inai.de>, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org, phil@nwl.cc
References: <20250417145055.2700920-1-jengelh@inai.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417145055.2700920-1-jengelh@inai.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Apr 17, 2025 at 04:48:33PM +0200, Jan Engelhardt wrote:
> There is a customer request (bugreport) for wanting to trivially load a ruleset
> from a well-known location on boot, forwarded to me by M. Gerstner. A systemd
> service unit is hereby added to provide that functionality. This is based on
> various distributions attempting to do same, for example,
> 
> https://src.fedoraproject.org/rpms/nftables/tree/rawhide
> https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/nftables/nftables.initd
> https://gitlab.archlinux.org/archlinux/packaging/packages/nftables
> 
> ---

Thanks Jan!

Acked-by: Eric Garver <eric@garver.life>

