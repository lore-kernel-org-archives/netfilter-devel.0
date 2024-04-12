Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F87842069
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2024 12:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712925728; cv=none; b=bWGkb1VdzRz7yH3XhHcZsdjXZAA9FSZo7J4b/B1kKjPa7bgcdKjhthy1kM6IpP/fWATHVj4BH1VVxrsUEC5e9ZKkgns93IjPqJB8s+YuihseUaya+xUWbt40bbO8EE5SBsGcHvLfVYqqjqlBTOWRtNF1M7HNf2+mRL4wb9qdYj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712925728; c=relaxed/simple;
	bh=SE2muQpsT8jpsbsLceq0CDejWzLcHRboe7Gp7sRzKoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dvxCcQAm0Xu9rGINpo9gGheWEUSXnJ95jYgNtaN+CYlyEznKGAx93ijNI1BncGevzuTZsAX4lTwwjr1AmK7gMNX2U50Iwf7STufbbavJ3llkEyNreAOMyuQezelwb/XIcJPiIl8uBMeXjl1ld/nqiXn1yr9gV6vJ9zhJVJtUtx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=eUiaQWP7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eUiaQWP7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zJMrWvtjE6KXEvWgGJL2+X+9v+6Uo2c9tffhMQTtjhE=; b=eUiaQWP7XsIz2Ht6qWSu5Dc7xR
	nii9dzWzOeHDw43nidq1/18Gi0SjXAyQLGlbV6xbgU8ROSOliWshY/yWEl0h/fmu9y4n8cozqBtnL
	JWDiuyVbE80UNGCqaBURhOyhU8OpTZoIPjHmVnjWGRnRHcHViPraWCCo8KxsWT+ETmgpjyy/Xw8pk
	OM5wUVUZwjqtQQiM2XSZXwIx7cAdkuFXXpZC1yNuYlvbxje/QnxADTQlZXAfEVB2NsqISWnt6/Ar6
	1rYgvXCiyoxu0D3CSQeo8ZliMJRHpIJg3/e2baBQeQfQJWkrsAZ8SFPr7Oq4emTOzbTWs3Ok4ID4e
	s0aUZAxQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rvGEF-0000000041S-3A9i;
	Fri, 12 Apr 2024 14:42:03 +0200
Date: Fri, 12 Apr 2024 14:42:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Thomas Haller <thaller@redhat.com>
Subject: Re: [nft PATCH] tests: shell: Avoid escape chars when printing to
 non-terminals
Message-ID: <ZhksG4AKe2B-zqwA@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Thomas Haller <thaller@redhat.com>
References: <20240323023733.20253-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240323023733.20253-1-phil@nwl.cc>

On Sat, Mar 23, 2024 at 03:37:33AM +0100, Phil Sutter wrote:
> Print the 'EXECUTING' status line only if stdout is a terminal, the
> mandatory following escape sequence to delete it messes up log file
> contents.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
