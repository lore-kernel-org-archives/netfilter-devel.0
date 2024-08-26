Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8771925AC
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Aug 2024 15:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724686176; cv=none; b=py+7mgDWY+jLM2frZFRbQT+xyP+wrUWPbm4xk3t4axXeCjIC0F3g6PrzYvRYqzpjdp/SluRT0P9ADtWDKX/6nBLHD1avjyQ0Em/DH285I6yMclDC++LZF4+HmGABwIDGWO51KGIIkfajHxkiPduCT6JajjX9GB66fuB1rgFv/hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724686176; c=relaxed/simple;
	bh=X7kL3ZH+tjK7QJXYTCB8cRUY1OxxcitjhCYN995Z6ak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mL2dTyUvCnFXZ3NA+4i1asWp5KgXVdfvvsRjztT2BcF1t4H0rgNdzi7qI3C/Y14y46q5EYhmfJQ26E0hlDDNx5DYR96IEQhVLggsXndlXz6gTTdrHNP42W2kg+3T2p6X+DJVotgUr9n+nD4oq+nMT1vwANcWaDGF/0magywAzL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T5tZdJl2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T5tZdJl2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724686172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y1Y9ddwpIja40hIX/m6/dWKWkcC0ZpB1GvZNrO4P5o8=;
	b=T5tZdJl2+Fm3WAJ8lAr2StV6NhtRM6EVxNIlc5pYn4JjMXOXJ+xRDZzRxvIQufz5YBVn76
	tZFWZnM8dBRmvXKr+tElWigyIrIX5aZbwg/B+VbIs/Jd50zRUcxtL4p8FR12WXCLUQ0pEK
	++dY3eqZQgb4GHfupvYBDZFMGTP2s8M=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-664-WUQaPh5ZOnKVrYDbiyhXmA-1; Mon,
 26 Aug 2024 11:29:24 -0400
X-MC-Unique: WUQaPh5ZOnKVrYDbiyhXmA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF5161955D58;
	Mon, 26 Aug 2024 15:29:23 +0000 (UTC)
Received: from localhost (unknown [10.22.17.151])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 26ACA1955DD8;
	Mon, 26 Aug 2024 15:29:22 +0000 (UTC)
Date: Mon, 26 Aug 2024 11:29:20 -0400
From: Eric Garver <eric@garver.life>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 0/7] cache updates
Message-ID: <ZsyfUE24_cmTtLiL@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240826085455.163392-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826085455.163392-1-pablo@netfilter.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Aug 26, 2024 at 10:54:48AM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains cache updates for nft:
> 
> Patch #1 resets filtering for each new command
> 
> Patch #2 accumulates cache flags for each command, recent patches are
> 	 relaxing cache requirements which could uncover bugs.
> 
> Patch #3 updates objects to use the netlink dump filtering infrastructure
> 	 to build the cache (
> 
> Patch #4 only dumps rules for the given table
> 
> Patch #5 updates reset commands to use the cache infrastructure
> 
> Patch #6 and #7 extend tests coverage for reset commands.
> 
> Pablo Neira Ayuso (7):
>   cache: reset filter for each command
>   cache: accumulate flags in batch
>   cache: add filtering support for objects
>   cache: only dump rules for the given table
>   cache: consolidate reset command
>   tests: shell: cover anonymous set with reset command
>   tests: shell: cover reset command with counter and quota
> 
>  include/cache.h                               |  12 +-
>  include/netlink.h                             |   5 -
>  src/cache.c                                   | 201 ++++++++++++++----
>  src/evaluate.c                                |   2 +
>  src/mnl.c                                     |   7 +-
>  src/netlink.c                                 |  78 -------
>  src/parser_bison.y                            |   8 +-
>  src/rule.c                                    |  48 +----
>  tests/shell/testcases/listing/reset_objects   | 104 +++++++++
>  .../testcases/rule_management/0011reset_0     |  31 ++-
>  10 files changed, 305 insertions(+), 191 deletions(-)
>  create mode 100755 tests/shell/testcases/listing/reset_objects
> 
> -- 
> 2.30.2

I ran this against the firewalld testsuite; lgtm. It does not cover
"reset" commands.

Tested-by: Eric Garver <eric@garver.life>

