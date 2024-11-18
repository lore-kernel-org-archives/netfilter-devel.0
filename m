Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E2E1AF0D9
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2024 15:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731942818; cv=none; b=D5ULpaSpTNjUDGbXt4J9e5eNBNJBDqV0FI/WNWnKfu6sUbpjhYdTdJ7hTx6z6v+TnIL1VHNYMyuUtgSCGWRSmTtFVJmOYiNWlEroqzGqt/UWuLB27Ri5GzY17eQGSQtZ1FChDJ7SMO9QZk0iUl/TY6VnKLojhGmBvQnMI4+whQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731942818; c=relaxed/simple;
	bh=HZRViVnHh4vOrQRH0395pTijFY22pa2ddCqU1DN6ur4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F3Y9Gdo5fnhwsS23Xo6H3pgYHYLlQUfbrg7IQy5LzuzILJ21rWj3Lk7W2JziATpN7iG1gCeLhpAYT68ElVrsZR9l1Cf0HPCY1uajmRBqtrbUWEIQhkwzgMVcDQnkX6eyeVXCFZJXefY6NEPek6Hgmi+V/5ZkcD12MH3X1/G6a84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e3zC6KzT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e3zC6KzT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731942812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DoPaZJuwiM7uZq8oZ0X6UjIZIOiZUqrYgeX36JKpAHI=;
	b=e3zC6KzTtN0A47ttf2hsa/EdszL2UDVktCvSpRYAsV/1mDdI7oR8hLa3OZr3FmK4IQu/iA
	Ja1QhEU8oIBsXEb1aIXjx8Hw9CMRv+pwQ18BDBYiMDv6AXG4vENSzxv8kl8prveJzhknjo
	KytxA8X3LyRKT0vFEHdhiC+Jdf0BcgM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-281-5SyeNJfNMi-R--xsUMXDxg-1; Mon,
 18 Nov 2024 10:13:28 -0500
X-MC-Unique: 5SyeNJfNMi-R--xsUMXDxg-1
X-Mimecast-MFC-AGG-ID: 5SyeNJfNMi-R--xsUMXDxg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9E3D1979049;
	Mon, 18 Nov 2024 15:13:26 +0000 (UTC)
Received: from localhost (unknown [10.22.64.128])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 308C71956054;
	Mon, 18 Nov 2024 15:13:25 +0000 (UTC)
Date: Mon, 18 Nov 2024 10:13:23 -0500
From: Eric Garver <eric@garver.life>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Phil Sutter <phil@nwl.cc>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables] nft: fix interface comparisons in `-C` commands
Message-ID: <ZztZk9nmvI0S1uFU@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>,
	Jeremy Sowden <jeremy@azazel.net>, Phil Sutter <phil@nwl.cc>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20241118135650.510715-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241118135650.510715-1-jeremy@azazel.net>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Nov 18, 2024 at 01:56:50PM +0000, Jeremy Sowden wrote:
> Commit 9ccae6397475 ("nft: Leave interface masks alone when parsing from
> kernel") removed code which explicitly set interface masks to all ones.  The
> result of this is that they are zero.  However, they are used to mask interfaces
> in `is_same_interfaces`.  Consequently, the masked values are alway zero, the
> comparisons are always true, and check commands which ought to fail succeed:
> 
>   # iptables -N test
>   # iptables -A test -i lo \! -o lo -j REJECT
>   # iptables -v -L test
>   Chain test (0 references)
>    pkts bytes target     prot opt in     out     source               destination
>       0     0 REJECT     all  --  lo     !lo     anywhere             anywhere             reject-with icmp-port-unreachable
>   # iptables -v -C test -i abcdefgh \! -o abcdefgh -j REJECT
>   REJECT  all opt -- in lo out !lo  0.0.0.0/0  -> 0.0.0.0/0   reject-with icmp-port-unreachable
> 
> Remove the mask parameters from `is_same_interfaces`.  Add a test-case.
> 
> Fixes: 9ccae6397475 ("nft: Leave interface masks alone when parsing from kernel")
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

This patch also fixes a rule ordering regression (same Fixes) that Phil
and I discovered last week. Thank you!

Tested-by: Eric Garver <eric@garver.life>

