Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F47918CBFC
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2024 13:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723122316; cv=none; b=af9Ou/d8GuCv5eelrJTHXtAV1dCYR7wc3LD9GziP3nxrk+jmWDcTp7lz6vh931v3g/zrUknFIXPkNGLaoNTZSHpYQam5GVbpPTcllUV3kg45OpL+papR4ronhRYDEEEUIdDvo0YW3IOa4cSHzCjKVP0ooPAezOpZhmm5J2AJjIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723122316; c=relaxed/simple;
	bh=xV58s8hxpAdkCKHW03AqYVLg4ax9G4WRIktAD5WktTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUqVzevfg3769NIBnDqvXAgkQ5adVw2JllaOplwE/DF7O+LkZNjgV4zNuGXNZjloVxLjBfS0y85S/8uiHPpzMeEoPZjDTwUkggLQe1pSkGl6S9ShpJOgOx/gVOwOUEOWIvizj8rt4oa64KpOSYn8D+krD1etPR2j5yZaZjnDLlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kgcuUtf0; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kgcuUtf0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5GKnYnIMWGPfnMSrD9dql3p40VHT6UX/ZnuKsiJ/B6g=; b=kgcuUtf0mK/ifODAVzeyr0arHc
	9ZzeAK6u6dgJ/wFuSSoIcS9Qw5q402/U0JgHKC+nCnNrZMqyitIEg+uS45SlnPpcLONzeOsmlg/KF
	irzFoWtLtzUxXLKlr/AWGnp5JK8NuuOdjhfvyXDfTrGmS8CX1w1guFHtKjiMouyOxKFS80yyw5p0p
	6xCD6NTUNPgAlpN4NqFMlcmYJx/7nuYCrnFsjIQdUs1Swhx0hAE1nyWmKes4LyOZV6E1F0GpxM3ee
	uQr32eK404omF4fOrYu6u0vSx9YSU4aTWx8GGtuA+1z1eWAnkJWB72vnMwHps93Ny/s11gGE01yhA
	fclPqg6w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sc2pL-000000001sP-0Raz;
	Thu, 08 Aug 2024 15:05:11 +0200
Date: Thu, 8 Aug 2024 15:05:11 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables RFC PATCH 8/8] nft: Support compat extensions in rule
 userdata
Message-ID: <ZrTCh6fOp_XP7frO@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Jan Engelhardt <jengelh@inai.de>
References: <20240731222703.22741-1-phil@nwl.cc>
 <20240731222703.22741-9-phil@nwl.cc>
 <ZrO1ZVKUT_fNKXx1@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrO1ZVKUT_fNKXx1@calendula>

Hi Pablo,

On Wed, Aug 07, 2024 at 07:56:53PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 01, 2024 at 12:27:03AM +0200, Phil Sutter wrote:
> > Add a mechanism providing forward compatibility for the current and
> > future versions of iptables-nft (and all other nft-variants) by
> > annotating nftnl rules with the extensions they were created for.
> > 
> > Upon nftnl rule parsing failure, warn about the situation and perform a
> > second attempt loading the respective compat extensions instead of the
> > native expressions which replace them. The foundational assumption is
> > that libxtables extensions are stable and thus the VM code created on
> > their behalf does not need to be.
> > 
> > Since nftnl rule userdata attributes are restricted to 255 bytes, the
> > implementation focusses on low memory consumption. Therefore, extensions
> > which remain in the rule as compat expressions are not also added to
> > userdata. In turn, extensions in userdata are annotated by start and end
> > expression number they are replacing. Also, the actual payload is
> > zipped using zlib.
> 
> What is store in the userdata extension? Is this a textual
> representation of the match/target?

The patch introduces a new attribute UDATA_TYPE_COMPAT_EXT which holds
an "array" of this data structure:

| struct rule_udata_ext {
|         uint8_t start_idx;
|         uint8_t end_idx;
|         uint8_t type;
|         uint8_t zip:1;
|         uint16_t orig_size;
|         uint16_t size;
|         unsigned char data[];
| };

start_idx/end_idx are those of expressions in the rule which are to be
replaced by this extension in fallback case. The 'type' field
distinguishes matches from targets (could be single-bit as well), the
'zip' field indicates 'data' is zlib-compressed. The remaining fields
are self-explanatory, whereat 'data' holds a (compressed) object of
either struct xt_entry_match or struct xt_entry_target.

> What is in your opinion the upside/downside of this approach?

You may recall, I tried to build a mechanism which works with old
binaries. This one does not, it requires user space support.
Distributions might backport it though, maybe even just the parser part.

The upside to this is that no kernel modifications are needed, the whole
thing is transparent to the kernel (apart from the increased rule size).

I had implemented a first approach embedding the rule in textual
representation into userdata, but it was ugly for different reasons.
Also I refrained from generating the string rep. ad-hoc from a given
iptables_command_state object because that would require refactoring of
the whole printing code to use a buffer or defined fp instead of stdout
directly. Apart from ugliness caused by reusing "whatever" the user put
into argv[], I had to overcome some obstacles:

- Space restrictions in userdata, breaking for "long" rules (e.g. having
  long comments).
- Parsing a rule from string ad-hoc (e.g. to compare user input with
  rules in cache) triggered some "funny" bugs.
- No way to omit redundant data (i.e., extensions which remain as compat
  expressions in the rule).

Vice-versa, this implementation has the following benefits:

- Rule parsing in fallback case is relatively simple, userdata bits
  parse similar to compat expression payload.
- Provide just the minimum parts of the rule in userdata. Comments will
  always remain in an extension, so will never be carried in userdata.
- Extensions compress relatively well (due to zero bytes in data
  structures).

One may assess better readability of netlink debug output when using a
string rep. This got somewhat reduced by me using NUL-chars to separate
arguments, but neither nft nor libnftnl will be able to convert the
binary payload of this approach to something user-friendly. Using
libxtables though, one could print the individual extensions into
iptables "command line parts".

I'll happily answer further questions, just shoot!

Cheers, Phil
