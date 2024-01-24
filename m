Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E801F7E565
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2024 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706112830; cv=none; b=cKL49xTp+9766xu7pXD5LeLb3BYzmQwPr3NHDObGYE2VT+VfcDB7lLsdN5F6A2b1Hz2iOH0G4M8eGxmtPQFCI5e5w/1EE41zWacgm9WBpVAaLwmKw9uAhp2NGULT/UXTvwE0EmIU9lRgovfRdHClNP+mjafNzuZ9V+qRwa/1IIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706112830; c=relaxed/simple;
	bh=qLmhAkVMgBCawHBnAfPMWPoISaP7i/EsDuEC7/CeDUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eozMAz5PZXbnlopnu4q9oNwC+tfI9xrjA7Yagbf1+WJ2FE3YKc5jKm3ob88Agkg5up1KH2nYDiRh8POHePc+D9OiLrCD4IuvPA4u/n2ySoJMMDW/H5I0+ugLVPdpAl0oGmvw5EZrocxEil8CUR0Sukg+gc8xyix2+rQcXYmrIKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=lxurTPit; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lxurTPit"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VyZcOok4/S7wUMh9owY8O+HH/iTriy50BRQbSutLp5E=; b=lxurTPitCSiIE3++NvNG95oBYA
	DCavXWEPf9OcUuo+PF1Se27CdByQz2IPppPkjReT3eTfIqxUZ/xeDC5tiwPbieTATdIdtGCmK+L/9
	DlhE7VSYPi6KGvI8fnCNHi+KR4tPK62QOGZI5nTDRgMUryLBE82oBGB5wBrewbpzM5lOcS8YwcDYg
	kimQC+auoZ/mE/rf5H8l7tCrKtE3rDiVFLm7qqg7mLz4xZjlPRaMMwZWQ5bNOuE8oBaleCY61e2yM
	yrwhz7+aqnAmGObh/GJKXsDHru10EuUq/+9tYgNf62JusuXVstixftJ6Z9DTD6ZpjRTpxQ5bAvYN8
	xX9H3B/w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rSfsn-000000003ib-3lJU;
	Wed, 24 Jan 2024 17:13:45 +0100
Date: Wed, 24 Jan 2024 17:13:45 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] extensions: libebt_stp: fix range checking
Message-ID: <ZbE3OUiDlnf7A7kI@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20240123164936.14403-1-fw@strlen.de>
 <ZbEYDliDhUrO73eu@orbyte.nwl.cc>
 <20240124143757.GC31645@breakpoint.cc>
 <ZbElUwojpsHjxnGO@orbyte.nwl.cc>
 <20240124154216.GD31645@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124154216.GD31645@breakpoint.cc>

On Wed, Jan 24, 2024 at 04:42:16PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > While you correctly hate the game instead of its player, you probably
> > hate the wrong game: The code above indeed is confusing. Maybe one
> > should move that monotonicity check into libxtables which should
> > simplify it quite a bit. I'll have a look. :)
> 
> Something IS broken.  Still not working on FC 39 test machine
> even after fresh clone.
> 
> On a "working" VM:
> export XTABLES_LIBDIR=$(pwd)/extensions
> iptables/xtables-nft-multi ebtables -A INPUT --stp-root-cost 1
> have 1 32765
> 
> @@ -150,7 +151,9 @@ static void brstp_parse(struct xt_option_call *cb)
>                 RANGE_ASSIGN("root-prio", root_prio, cb->val.u16_range);
>                 break;
>         case O_RCOST:
> +               fprintf(stderr, "have %u %u\n", cb->val.u32_range[0], cb->val.u32_range[1]);
> 
> I can't even figure out where the correct max value is supposed to be set.
> 
> Varying the input:
> 
> xtables-nft-multi ebtables -A INPUT --stp-root-cost 1
> have 1 32764
> 
> Looks to me as if the upper value is undefined.
> 
> Other users of *RC versions handle it in .parse, e.g. libxt_length.
> No idea how this is working.

In xtopt_parse_mint(), there is:

| const uintmax_t lmax = xtopt_max_by_type(entry->type);
| [...]
| if (*arg == '\0' || *arg == sep) {
|         /* Default range components when field not spec'd. */
|         end = (char *)arg;
|         value = (cb->nvals == 1) ? lmax : 0;

But that branch appears to be dead code. So this is indeed a bug and a
specific build may or may not hit it as your experience shows. I'll see
how xtopt_parse_mint() can be fixed.

The reason why extensions may sanitize the values is because kernel code
may expect upper==lower or upper==MAX if not given.

Cheers, Phil
