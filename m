Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E5C36D4E4;
	Sun,  8 Mar 2026 10:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772966587; cv=none; b=bWKxM9kbwLDTkGDAi3+mJ0XOU4i9ZXuG70dgK8xS9e+mxwBvgnLx+GD+l6pWPWyv8FjBCjVbPA8+AjPDkHWSNj/Yv+4dBp5WaiigRiK0WC4KfORQhDZ+aq/SFeotsw1g24ILq/GWC2UTHknwlJ+Z52+LgWz86gtkEsqUrSnM5NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772966587; c=relaxed/simple;
	bh=y02TfbcEwGKQePAuEZIBamlBhc6UIiF+PhEqTAb8ZWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dzNcYsXxMYPBCAc3RWpLFxSCRbUq04lW1p+5rNeRSBw1mWBG/YsEGv48iAgEhE5Yc+eYiAkHAjvwf9dv8puhDba93RJe8lKvh3f//9Ndv+fTBgdN6IUSESzSgCuXfVnmYiqB8fLjmRBJMs64vIgx56vRYo5qW8jahZf6NmobhQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sTaDHGsj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sTaDHGsj"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 142E660521;
	Sun,  8 Mar 2026 11:43:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772966582;
	bh=+M+S7zGFiZKb8nqyORaqH9S+h5OjmBDWiY/9ubOO6rw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sTaDHGsjSoLcXyrme51C/4cfZZCderlwRHxr64fk+J4kApYHkRXub3jVr6luLk5vz
	 FVSBRIX/t6tpvs2zKGZy0if4XGtZdw/VcU54HZ4RB7DWbJ6Hw1XmJyfYpd3TWfmXYD
	 veJ4TmEGq4eYaJLIU2N5Se+ODfejqPJX9UqEwrjevzTPqxT96vOkFD70bjcCDC0c1U
	 ptx+7IYl6+4FzdiXV2546OfVSF2ft093nvIV002In9ze2GMr/4rytaHrv7BDK+9HEY
	 T0AGnpbX/R2GzcQNfp3/2s62e+lZNmsUSAu98fHQ1XDzfI8DtmIS7S15v7qI6/nEJl
	 Du/L6epu1SFZg==
Date: Sun, 8 Mar 2026 11:42:59 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: ctnetlink: validate CTA_EXPECT_NAT_DIR to
 prevent OOB access
Message-ID: <aa1Ss9c4Soa8C6Dc@chamomile>
References: <aaxew8enOWT853XV@v4bel>
 <aaxn41hrKcVo7e9M@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaxn41hrKcVo7e9M@strlen.de>

On Sat, Mar 07, 2026 at 07:01:07PM +0100, Florian Westphal wrote:
> Hyunwoo Kim <imv4bel@gmail.com> wrote:
> > ctnetlink_parse_expect_nat() assigns the user-supplied
> > CTA_EXPECT_NAT_DIR value directly to exp->dir without validating that it
> > is within the valid range (0 to IP_CT_DIR_MAX-1).  When
> > nf_nat_sip_expected() later uses exp->dir as an index into
> > ct->master->tuplehash[], an out-of-bounds array access occurs.
> > 
> > For example, with exp->dir = 100, the access at
> > ct->master->tuplehash[100] reads 5600 bytes past the start of a
> > 320-byte nf_conn object, causing a slab-out-of-bounds read confirmed by
> > UBSAN.
> > 
> > Validate exp->dir against IP_CT_DIR_MAX before accepting it.
> 
> I would prefer a fix for exp_nat_nla_policy so netlink policy validation
> can handle this for us.
> 
>         [CTA_EXPECT_NAT_DIR] = NLA_POLICY_MAX(NLA_BE32, IPCT_DIR_MAX),
> 
> .. should do it.  Might make sense to check all other attrs while at it.

Agreed.
