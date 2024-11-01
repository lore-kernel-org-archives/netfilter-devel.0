Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247651A7AF7
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Nov 2024 14:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730472936; cv=none; b=WM6N9hTlbt5qcy7AYdcLiCcXwP2Jc0uuaj8WyQ37xFsbsKaVY3VxV/tmTcw8O1fRZqFwEBJCKhs5QoEcdQFvzwFPgXGzq5iXQXVQe1Q/Ga2jA0WdnS5mMhzxjQobn1T8VTVVhqAEaTiAfgHKQVOLZ1HLvTTXlL9a/41N1R3ving=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730472936; c=relaxed/simple;
	bh=Em/9MfAXhaZZZgdply/5GTErY5W2y2973kHslpzXyLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WwHii1OBqzuyrmk2AD9ouxPwEsuVk/gJyvbDK8pyaLuP4iDo9kjSiciZ6T8kIQeqB8pgWXgvB4E0LtPGkLxGCmoMC+qgOGrXRfOuC/fahW3suwEU6b8S6ndI+9Cf0R9l67tWzYpsCcRzo0RRLEcSWEE7ryLtaIFVXjGL2j36CFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VXjg6+6T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VXjg6+6T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730472931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YPkFIw6XaPjvZy3HMG2oZQK5wKk2RiA+bhYpwHIob/I=;
	b=VXjg6+6TVfmbuIb4xtolVwN6nEJhoqLgFUR2u0tiamVb/bCudyOi57PR0z4xGtoY+B4CcB
	jgzDWVIp7bqe1QTxxgE9uiASJ6UBSi5IUP0jgJcp6dpQb6QLGmCXDpH4I2QQyJ7ksgptBn
	5WJHOo0pMkEHKUg4mn4raHrgRw28dJs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339-lnknB0IHOfmHGCaiuaF0ZQ-1; Fri,
 01 Nov 2024 10:55:28 -0400
X-MC-Unique: lnknB0IHOfmHGCaiuaF0ZQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71DBD19560A3;
	Fri,  1 Nov 2024 14:55:27 +0000 (UTC)
Received: from localhost (unknown [10.22.64.65])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E2649195605A;
	Fri,  1 Nov 2024 14:55:26 +0000 (UTC)
Date: Fri, 1 Nov 2024 10:55:24 -0400
From: Eric Garver <eric@garver.life>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH nft] json: collapse set element commands from parser
Message-ID: <ZyTr3OJ5i79aTc_Z@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, phil@nwl.cc
References: <20241031220411.165942-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031220411.165942-1-pablo@netfilter.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Oct 31, 2024 at 11:04:11PM +0100, Pablo Neira Ayuso wrote:
> Update json parser to collapse {add,create} element commands to reduce
> memory consumption in the case of large sets defined by one element per
> command:
> 
> {"nftables": [{"add": {"element": {"family": "ip", "table": "x", "name":
> "y", "elem": [{"set": ["1.1.0.0"]}]}}},...]}
> 
> Add CTX_F_COLLAPSED flag to report that command has been collapsed.
> 
> This patch reduces memory consumption by ~32% this case.
> 
> Fixes: 20f1c60ac8c8 ("src: collapse set element commands from parser")
> Reported-by: Eric Garver <eric@garver.life>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks Pablo!

Tested-by: Eric Garver <eric@garver.life>

