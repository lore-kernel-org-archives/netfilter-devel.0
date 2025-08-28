Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E7430C605;
	Thu, 28 Aug 2025 12:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756385330; cv=none; b=DUUkMAW/DGqBM0lu2mibi9KrYqwkBIWoDT4WY5T7kSqY9WiwYpTI+x4DXy9/JBzsnqV93li1DV1RC0KmTpFWVpaSVs7wgz/M60qOkT8bxJaiQ+YnETFj6CdM6kgUYqxPyz4gjAdZzBroCZy297t/4ZRy6omYCRASR4T0q2Z3qFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756385330; c=relaxed/simple;
	bh=2n4NeLSmEOqtdlWPXQwJRI7feYesN6zJIyWQkcDsobc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfOWGrybXzMo2LvEY6eEsNZGdSgGCgGoJry2JkcU202CyYPVtl0bBuJeEbskE3kKAsxliJuDjiKLQQe4V0wsFjraFpKA1sft3hP+NoV17/ezVvM/9LwPDHIBppybXRTUMxCgfDSAiB9I+h4iPhVJq427ya2sXqgRMy6lpMI9M68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E9EE1605F7; Thu, 28 Aug 2025 14:48:45 +0200 (CEST)
Date: Thu, 28 Aug 2025 14:48:45 +0200
From: Florian Westphal <fw@strlen.de>
To: Fabian =?iso-8859-1?Q?Bl=E4se?= <fabian@blaese.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v3] icmp: fix icmp_ndo_send address translation for reply
 direction
Message-ID: <aLBQLVEAqLOHl15T@strlen.de>
References: <20250825203826.3231093-1-fabian@blaese.de>
 <20250828091435.161962-1-fabian@blaese.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250828091435.161962-1-fabian@blaese.de>

Fabian Bläse <fabian@blaese.de> wrote:
> The icmp_ndo_send function was originally introduced to ensure proper
> rate limiting when icmp_send is called by a network device driver,
> where the packet's source address may have already been transformed
> by SNAT.
> 
> However, the original implementation only considers the
> IP_CT_DIR_ORIGINAL direction for SNAT and always replaced the packet's
> source address with that of the original-direction tuple. This causes
> two problems:
> 
> 1. For SNAT:
>    Reply-direction packets were incorrectly translated using the source
>    address of the CT original direction, even though no translation is
>    required.
> 
> 2. For DNAT:
>    Reply-direction packets were not handled at all. In DNAT, the original
>    direction's destination is translated. Therefore, in the reply
>    direction the source address must be set to the reply-direction
>    source, so rate limiting works as intended.
> 
> Fix this by using the connection direction to select the correct tuple
> for source address translation, and adjust the pre-checks to handle
> reply-direction packets in case of DNAT.
> 
> Additionally, wrap the `ct->status` access in READ_ONCE(). This avoids
> possible KCSAN reports about concurrent updates to `ct->status`.

Reviewed-by: Florian Westphal <fw@strlen.de>
