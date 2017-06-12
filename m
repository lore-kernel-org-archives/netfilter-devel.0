From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] scanner: add files in include dirs in alphabetical
 order.
Date: Mon, 12 Jun 2017 10:10:07 +0200
Message-ID: <20170612081007.GA2462@salvia>
References: <20170607083559.10051-1-ismo.puustinen@intel.com>
 <CAOkSjBjeTaZTJDEViBRq2y1q715EssHUdgxOFNVf1H7JzpJ6hw@mail.gmail.com>
 <20170608101735.GA2735@salvia>
 <CAOkSjBiTkEbhLtmRQq4ifYv7QQ352tCLfd6kT9DN=XsB=KtR7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ismo Puustinen <ismo.puustinen@intel.com>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:56307 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdFLIKW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2017 04:10:22 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiTkEbhLtmRQq4ifYv7QQ352tCLfd6kT9DN=XsB=KtR7Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 08, 2017 at 06:37:57PM +0200, Arturo Borrero Gonzalez wrote:
> On 8 June 2017 at 12:17, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > Then, to keep it consistent, we should also display a warning in
> > include file with no .nft postfix. At deprecate the existing behaviour
> > at some point, ie. bail out if you include a file that has no trailing
> > .nft in its name.
> >
> > If we follow this path, all ruleset file will end up using .nft as
> > a trailer in the name.
> >
> 
> but perhaps it makes sense to differentiate two cases:
>  * include a single file: accept arbitrary names
>  * include a whole dir: accept only files ending in .nft
> 
> This seems to be what sysctl(8) does when loading a single file vs a directory.
> I'm thinking in a case where you have a README in the directory or
> other unrelated file.

I see, it makes sense indeed to have a way to skip files you don't
want. But I still would like this behaviour is consistent.

> If the idea is to allow drop files (a good idea indeed), then being
> explicit is a good approach.
> 
> > Is there any other similar software following this approach? How is
> > 'ferm' doing this?
> 
> ferm seems to load arbitrary files. In the docs they suggest using
> .ferm files but the code
> seems to allow whatever.
> However, they have a set of regexp hardcoded to avoid loading things
> like backups file an the like.
> So, yes, probably forcing to .nft is sensible.

I would go for glob support, ie.

include ./nft-ruleset-files/*.nft

so you can explicit indicate what file pattern you want to load.
