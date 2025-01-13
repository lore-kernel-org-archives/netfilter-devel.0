Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B260C1CAA69
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 12:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736771416; cv=none; b=ZMdATs+j0CwLKX9+FLSHFNCrjERb+JFURz8BqL5wONM7qkdfxbtt9Th+JmwwbeMDZnI4Q7cwTwQFZIOaAFea257NuIjyWhCRJ1tQKvtwQhifH5QbNv+B3dhxypaQ5oRd9q0j3rgLntgrEo7qGdWffXfJicNAvIEGzdFIaAKgWaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736771416; c=relaxed/simple;
	bh=lal3p80gRW4iu3iYehXg8coSpRK8O4cHd6uCIS3G2SA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ml8eZBphjqs0gch/ZjHVC3xYmBeNS2eCOBNzWpyTe2l7icI1c5HD3lWJmwln7e+0NLeDKy/VlUPX10EVJmYWiPFN6+cRBrleAmsvlxcRHUObzoQRqrnoTHREocYgWa9U+acJiLNVvNelKFeDAyaLAwgFAJ48aCnN2lUjHvXom3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 13 Jan 2025 13:30:01 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <azazel@debian.org>
Cc: James Dingwall <james@dingwall.me.uk>, netfilter-devel@vger.kernel.org
Subject: Re: ulogd: out of bounds array access in ulogd_filter_HWHDR
Message-ID: <Z4UHMxttvdFs55Vo@calendula>
References: <Z4Tr5p19Uoc1UEcg@dingwall.me.uk>
 <20250113111201.GB2068886@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250113111201.GB2068886@celephais.dreamlands>

On Mon, Jan 13, 2025 at 11:12:01AM +0000, Jeremy Sowden wrote:
> On 2025-01-13, at 10:33:10 +0000, James Dingwall wrote:
[...]
> > --- filter/ulogd_filter_HWHDR.c.orig	2025-01-13 09:25:18.937977335 +0000
> > +++ filter/ulogd_filter_HWHDR.c	2025-01-13 09:25:51.337824820 +0000
> > @@ -109,7 +109,7 @@
> >  	},
> >  };
> >  
> > -static char hwmac_str[MAX_KEY - START_KEY][HWADDR_LENGTH];
> > +static char hwmac_str[(MAX_KEY + 1) - START_KEY][HWADDR_LENGTH];
> >  
> >  static int parse_mac2str(struct ulogd_key *ret, unsigned char *mac,
> >  			 int okey, int len)
> 
> This was fixed a couple of years ago:
> 
>   https://git.netfilter.org/ulogd2/commit/?id=49f6def6fcbaf01f395fbe00543a9ab2c4bb106e
> 
> and the fix should have made it into the Debian & Ubuntu packages.  I
> will investigate.

I am going to launch a new release to help this propagate to distros.
