Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="d2Py6OD1"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EA7AC
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 05:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VJcKNEiT2iQ8i47VpVn2LmCViqLKHjhZdAo205ETGhQ=; b=d2Py6OD12uDhktQbtfQyDinek4
	+LaKIsbTerccG3E7ZNg+HNkEtwd85yeF+N/2GbYg5uZG9q81S9yu4pZgdl4fApPf8Q4ZeYauvsKS+
	kmTi2Ahjw/His8FZ1aZSgQnR+8MeRJvqf9jHjNwRomXd2qgiX4KiCKwCK1mdmky5PwRKXdBksT4Q3
	gYdh+PswxL35e0fInOj+hFOIF/5pNeepc22QgxpziVAsEeOVLCmQi/m5B3iVGegh1vIxlog8ykpfp
	xAerJdDoBgsCbJBOg6A9DNDQem9rJmETw9meGO4cBE+wk1X3vvt05En4SLx7sgcWTXtjNZmC7QT97
	DzI80EHA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rArYv-0007on-05; Wed, 06 Dec 2023 14:03:37 +0100
Date: Wed, 6 Dec 2023 14:03:36 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] initial support for the afl++ (american fuzzy lop++)
 fuzzer
Message-ID: <ZXBxKEhprUVUvG7m@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20231201154307.13622-1-fw@strlen.de>
 <ZW/YVpeUtn5dfcmA@orbyte.nwl.cc>
 <20231206074342.GC8352@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206074342.GC8352@breakpoint.cc>

On Wed, Dec 06, 2023 at 08:43:42AM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > +__AFL_FUZZ_INIT();
> > > +/* this get passed via afl-cc, declares prototypes
> > > + * depending on the afl-cc flavor.
> > > + */
> >
> > This comment seems out of place?
> 
> I wanted to add some explanation as to where this
> macro is defined/coming from.

Ah, so it relates to the preceding macro call. Maybe
s/this/above macro declaraction/ ?

> 
> > > +	len = strlen(buf);
> > > +
> > > +	rv = write(fd, buf, len);
> > 
> > So this sets input->fname to name and writes into the opened fd, but
> > what if savebuf() noticed buf fits into input->buffer and thus set
> > input->use_filename = false?
> 
> What about it?  The idea is to have an on-disk copy in case afl or the
> vm its running in crashes.

Hmm. Probably I miss the point regarding struct nft_afl_input. IMO, if
save_candidate() writes data into the file despite called savebuf()
setting use_filename = false, nft_afl_run_cmd() will try to read from
->buffer when it should read from ->fname.

Cheers, Phil
