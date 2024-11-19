Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA5D1514FB
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 13:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732022443; cv=none; b=Q1ZU8G4GTjUFGnGaNn10GKdaACcHtuOq9a+IkaPRlf7tPfIZtBPSx0qI1L+WsMfOTutX9d8DR6dBIG13/YPp/ZmWaFp3wcrq8LybmpfhEVEbxYNY3Cl4ciRWEw5F50UCGp2cWgIzHqy4sQBkWf5apnGgihYagxa7rccByfw2qW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732022443; c=relaxed/simple;
	bh=v4iLRcAr7qQ3b/lqBkZjsCgmmzhYaadmykTZG8hTMZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MHw1cRiA3yzrM85YU+NnWxL4f0VqbU6xKiE0vXiQuKBvaUXor0k/yaC/rVUuf0V0nKMwrX3SpH9qu18/TTEbNNc/JDCFmTn8aqZ0jNy4FEcu7qjPZfoPLVTIFuKbL5a3KcNVT59kyEDQYK0WtB9rZu3dEzkEvhNj5eVrV1PKj00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=n/qFNhus; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="n/qFNhus"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rNGJwDqX8EwaGBPt7mLbbsWoMFwtpQgCeulPaFpHHy4=; b=n/qFNhus2JLI6oCDmV9L46LgeL
	b0PXhO5KKGAmwf3BGwCkuKYVlXMgTeRP0wRQ6WFkcWJQUoZkLTSXbQWbBImqriD7NrpKjzjwfPXEF
	iVIBXV1p3dLA0Xiap6WIk92pJm4ScjUih4KecluFAC5oMH6eXfOUVpTnBaeQRop64LnOyFZr6DItF
	pRqpFOy2Y2RhFv9TT2dqFRYTyIwkLdfrhzVyJu0GVLvD2/d++f54cvWRMgbTQBe84McIuF8oc3n/5
	qVUYDIdluS0AJdLBtI22tiCxmkOqb+31GXAKwyDskwpDUh6veS3JmJmLJhBSZVT+4au9me0hybyXQ
	i+k648Uw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tDO9f-0000000019X-0tMi;
	Tue, 19 Nov 2024 14:20:31 +0100
Date: Tue, 19 Nov 2024 14:20:31 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Eric Garver <eric@garver.life>
Subject: Re: [PATCH iptables] nft: fix interface comparisons in `-C` commands
Message-ID: <ZzyQn9E0cPi7t98b@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Eric Garver <eric@garver.life>
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

Hi Jeremy,

On Mon, Nov 18, 2024 at 01:56:50PM +0000, Jeremy Sowden wrote:
[...]
> Remove the mask parameters from `is_same_interfaces`.  Add a test-case.

Thanks for the fix and test-case!

Some remarks below:

[...]
>  bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
> -			unsigned const char *a_iniface_mask,
> -			unsigned const char *a_outiface_mask,
> -			const char *b_iniface, const char *b_outiface,
> -			unsigned const char *b_iniface_mask,
> -			unsigned const char *b_outiface_mask)
> +			const char *b_iniface, const char *b_outiface)
>  {
>  	int i;
>  
>  	for (i = 0; i < IFNAMSIZ; i++) {
> -		if (a_iniface_mask[i] != b_iniface_mask[i]) {
> -			DEBUGP("different iniface mask %x, %x (%d)\n",
> -			a_iniface_mask[i] & 0xff, b_iniface_mask[i] & 0xff, i);
> -			return false;
> -		}
> -		if ((a_iniface[i] & a_iniface_mask[i])
> -		    != (b_iniface[i] & b_iniface_mask[i])) {
> +		if (a_iniface[i] != b_iniface[i]) {
>  			DEBUGP("different iniface\n");
>  			return false;
>  		}
> -		if (a_outiface_mask[i] != b_outiface_mask[i]) {
> -			DEBUGP("different outiface mask\n");
> -			return false;
> -		}
> -		if ((a_outiface[i] & a_outiface_mask[i])
> -		    != (b_outiface[i] & b_outiface_mask[i])) {
> +		if (a_outiface[i] != b_outiface[i]) {
>  			DEBUGP("different outiface\n");
>  			return false;
>  		}

My draft fix converts this to strncmp() calls, I don't think we should
inspect bytes past the NUL-char. Usually we parse into a zeroed
iptables_command_state, but if_indextoname(3P) does not define output
buffer contents apart from "shall place in this buffer the name of the
interface", so it may put garbage in there (although unlikely).

Another thing is a potential follow-up: There are remains in
nft_arp_post_parse() and ipv6_post_parse(), needless filling of the mask
buffers. They may be dropped along with the now unused mask fields in
struct xtables_args.

WDYT?

Thanks, Phil
