Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C85A1C6A8
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2024 20:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721681331; cv=none; b=jvJEiJxDfzs5fV566DUENaFSdXRdHxT4IfJ3+hC/bsbAe+8MZZSSN+E6hNigrYapOWUpeVxGwXT7m5w52NAgggrXQPXQ6BrPihM281hOk7UbeNpc1FCZDlfK1C4oQeDpdsgDIXOksh0Pj1+mpQsKhhqm7LFvEyjzJue/sOtdfcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721681331; c=relaxed/simple;
	bh=BjrphG9yBqKsn4lzViTayj6PfKm9weZvP8iAMNyEi8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EQEY3gduWtifJuUAsXSPloC3NtdOJz/Vg1zAzF2dUIVacfNiQIOkcNXhdz5WVP8CjU+OWmBSxPWvyMNeIs9r23uGzBLMHJD498qgr2QJA3rFjt1aH04/hjJzYetaOjCQ++5mv/nE3BA6MGx2Zesx/JiJxShHbJctYCAIK3aEtQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MdG4+x1X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MdG4+x1X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721681328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AwXUmxR8IsFh6pGK2vqHIsDEcmwF+OpK2GjO7nBSQ0w=;
	b=MdG4+x1XJvkTJz+v8eUYfqu6JcqWiANhrSkCbgu4x4P+qV4z4knWLyjBxztnrc+/1p+4SC
	uTgfXZaXVSO35UZXE2oSbCzH+6bfggYobAkQbnnS3jnrKDmqQhT4BjW/fhu8uS5Exz0iBq
	spJF+KSXY2cEdR68siqhhY47VvqwKlM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-674-jCBSxlEIOBelxiL5SBbWzg-1; Mon,
 22 Jul 2024 16:48:45 -0400
X-MC-Unique: jCBSxlEIOBelxiL5SBbWzg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 257E51955F45;
	Mon, 22 Jul 2024 20:48:44 +0000 (UTC)
Received: from localhost (unknown [10.22.32.181])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 57E12195605A;
	Mon, 22 Jul 2024 20:48:42 +0000 (UTC)
Date: Mon, 22 Jul 2024 16:48:40 -0400
From: Eric Garver <eric@garver.life>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de,
	Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft 2/2,v2] cache: recycle existing cache with
 incremental updates
Message-ID: <Zp7FqL_YK3p_dQ8B@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de,
	Phil Sutter <phil@nwl.cc>
References: <20240528152817.856211-1-pablo@netfilter.org>
 <20240528152817.856211-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240528152817.856211-2-pablo@netfilter.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, May 28, 2024 at 05:28:17PM +0200, Pablo Neira Ayuso wrote:
> Cache tracking has improved over time by incrementally adding/deleting
> objects when evaluating commands that are going to be sent to the kernel.
> 
> nft_cache_is_complete() already checks that the cache contains objects
> that are required to handle this batch of commands by comparing cache
> flags.
> 
> Infer from the current generation ID if no other transaction has
> invalidated the existing cache, this allows to skip unnecessary cache
> flush then refill situations which slow down incremental updates.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: no changes

Hi Pablo,

This patch introduced a regression with the index keyword. It seems to
be triggered by adding a rule with "insert", then referencing the new
rule with by "add"-ing another rule using index.

https://github.com/firewalld/firewalld/issues/1366#issuecomment-2243772215

I'm happy to test any fixes.

Thanks.
Eric.


--->8---


# cat /tmp/foo2
add table inet foo
add chain inet foo bar { type filter hook input priority filter; }
add rule inet foo bar accept
insert rule inet foo bar index 0 accept
add rule inet foo bar index 0 accept

# nft delete table inet foo; nft -i < /tmp/foo2 ; nft list table inet foo
Error: Could not process rule: No such file or directory
add rule inet foo bar index 0 accept
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
table inet foo {
        chain bar {
                type filter hook input priority filter; policy accept;
                accept
                accept
        }
}

# git revert e791dbe109b6dd891a63a4236df5dc29d7a4b863
[master 30ae3c684990] Revert "cache: recycle existing cache with incremental updates"
 1 file changed, 3 insertions(+), 15 deletions(-)

# make install
[..]

# nft delete table inet foo; nft -i < /tmp/foo2 ; nft list table inet foo
table inet foo {
        chain bar {
                type filter hook input priority filter; policy accept;
                accept
                accept
                accept
        }
}

