Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669A4A41;
	Thu,  6 Nov 2025 23:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762471280; cv=none; b=bw3WRKM52aQvjTq+HdpNuAsMEqH8faBcCMukZkL1DXg0jKDV2zNYHV5kEmuvH8p3GmcgUAZDM+gqV0/h6G2q8rb1HwZmn7N8U0LRJauFkUUJPLnSb3wV/4/DIpiX9jCQXvMPwx0juBp4mVx/3lgBBrZQl0dyxuiriIc50nTV2V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762471280; c=relaxed/simple;
	bh=59732leBYnImKyqBll6UrPZp0KO2CPY/oH6YlG+CJTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SBisyLMQeAJLVt1wT1zeDXVQhCG4ooJO3jzuK0Z5sFjl3SSX1UAVhrICzhsbMr1FLv7fMZ2kX5PuVZccAFcfIKW2ldiIaJF4rNLwKBCyYAd3t89o8BaBGrjftFXIuuLExSM0S/GGiStK1AOFdkzXUPJkvaNQISBpQ0ARpAviNWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6F724601A1; Fri,  7 Nov 2025 00:21:16 +0100 (CET)
Date: Fri, 7 Nov 2025 00:21:16 +0100
From: Florian Westphal <fw@strlen.de>
To: Ricardo Robaina <rrobaina@redhat.com>
Cc: audit@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	paul@paul-moore.com, eparis@redhat.com, pablo@netfilter.org,
	kadlec@netfilter.org
Subject: Re: [PATCH v5 0/2] audit: improve NETFILTER_PKT records
Message-ID: <aQ0tbO8YNNdOP5KS@strlen.de>
References: <cover.1762434837.git.rrobaina@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1762434837.git.rrobaina@redhat.com>

Ricardo Robaina <rrobaina@redhat.com> wrote:
> Currently, NETFILTER_PKT records lack source and destination
> port information, which is often valuable for troubleshooting.
> This patch series adds ports numbers, to NETFILTER_PKT records.
> 
> The first patch refactors netfilter-related code, by moving
> duplicated code to audit.c, creating two helper functions:
> 'audit_log_packet_ip4' and 'audit_log_packet_ip6'. 
> The second one, improves the NETFILTER_PKT records, by 
> including source and destination ports for protocols of
> interest.

I'll assume this will go via audit tree, so:

Acked-by: Florian Westphal <fw@strlen.de>
