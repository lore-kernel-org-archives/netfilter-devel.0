Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D701F3B9E
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Feb 2025 21:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739051860; cv=none; b=Os/pCLP05tjeOAtrkUDhmGJvkRcrzP3hOCCi3tjMFMmA/ugVTtfVD+Der8R4ZXs3gfuHdWYOv64fy00vOaQr7+l7Q2k32YXTLXxEZvOYEhBoavjRTUPYPExeY8QpujgLQZjuYXzHM7ui7HWPqM4r5vnavPNk/c4CYM1hLN4X+4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739051860; c=relaxed/simple;
	bh=3DO8fZpnzjxi0MjeTQh0bZTqxpS/CX/qMw2CjN7WP24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ODgqWVNzYEtN5kaUysB1nwbEy6YUSxZBmIbPAW33My46ggdy78MJ/SeWltbBmbHURRa/0Xo5iaemsVuI3ZM70xmevQINy5kk/F0PFhyQTNkVQ3aEEapLMDNshT4Ay/K4IJFzQ4H9jEeYi7QbXHzzZ5KMxYpO6WteKORRseb/FO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oZjaXgoP; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rEycxu+Y; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oZjaXgoP";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rEycxu+Y"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 04DB1602FB; Sat,  8 Feb 2025 22:57:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1739051857;
	bh=a0mk1L6xJkWznI155OWDL+n8hflQV/KOSLm/nCNcYhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oZjaXgoPm5avbsrNM6BAnp7gwyTehmpldzA1MggMsQy4vPll6m7Bnmaiv7wT7QKwi
	 hREeG8YQw9P5O/IA+t9O7EbviHKY24NvWTQZ64ZGSc/sw6WEUYD2e0kx8whgajiTSa
	 akHB5usD87icGHqmG+5JACCsWosKo4HOg/IGUPnxtPoTPDjvPW4Z+0+N+n3GSbKgGG
	 2b2OMg3xk+u5McBf1Zyveuuowz6S+c0CdCywXg7Ja/O87kFI9tcqumZPiGJZZekVNc
	 ZVEJNAB4Ag1gNlIuvcu8EZE7vjaCuhjZaRcv+g9XusVDjR/oAGaN/yqaWHrz9PbqsJ
	 IivHfZGwL5Nlg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 813F260284;
	Sat,  8 Feb 2025 22:57:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1739051856;
	bh=a0mk1L6xJkWznI155OWDL+n8hflQV/KOSLm/nCNcYhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rEycxu+Y4lTbYNjBbpeImP1ZpNIchu3DkpE7lFqwXrkPp3hg5XhDibizlYhsIOJIs
	 rjcxAl3H4334AGXbAS4bS+cqI+2OhxpCntO6T//E3VBA966Stx2TWhU0VZ2G8b7Zhx
	 BeXVCdVhzSEOjaQrcakydD4CRuumjovPOzALoMxYW0ukQvjqQgW1INlg6vb1QUyAIe
	 ewItdqI/9fJqs49Pu3SsX/C9APZrfqYDCwR72T/43sAJInfmG456BoFRzxQz+CiA2n
	 eNV+mdQ9i4f1eW4+37Ht+eo4TKU41IG/4SVhIlPs7ltju2FB3eiAPyKlR3OvIPr44L
	 oE6LvDX3MEB7A==
Date: Sat, 8 Feb 2025 22:57:33 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: corubba <corubba@gmx.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2 2/3] gprint: fix comma after ip addresses
Message-ID: <Z6fTTTvw9RNbwGKd@calendula>
References: <0a983b51-9a51-47a7-bbdc-9bf163a88bbd@gmx.de>
 <2e047e50-e689-4fbb-ae58-bc522a758e40@gmx.de>
 <Z6fKoE-JOtvbKHvY@calendula>
 <9a755bdd-c715-46e5-ad50-6e158ec1ef48@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9a755bdd-c715-46e5-ad50-6e158ec1ef48@gmx.de>

On Sat, Feb 08, 2025 at 10:30:04PM +0100, corubba wrote:
> On 08.02.25 22:20, Pablo Neira Ayuso wrote:
> > On Sat, Feb 08, 2025 at 02:49:49PM +0100, corubba wrote:
> >> Gone missing in f04bf679.
> >
> > ulogd2$ git show f04bf679
> > fatal: ambiguous argument 'f04bf679': unknown revision or path not in the working tree.
> >
> > ???
> 
> The full commit id is f04bf6794d1153abd2c3b0bfededd9403d79acf6, which
> does exist [0]. And that `git show` command works in my local clone of
> the repo, showing the commit in question.
> 
> [0] https://git.netfilter.org/ulogd2/commit/?id=f04bf679

My fault, I was quickly checking on a stale working copy of ulogd2, apologies.
