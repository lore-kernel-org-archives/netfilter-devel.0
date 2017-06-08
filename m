From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] scanner: add files in include dirs in alphabetical
 order.
Date: Thu, 8 Jun 2017 12:17:35 +0200
Message-ID: <20170608101735.GA2735@salvia>
References: <20170607083559.10051-1-ismo.puustinen@intel.com>
 <CAOkSjBjeTaZTJDEViBRq2y1q715EssHUdgxOFNVf1H7JzpJ6hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ismo Puustinen <ismo.puustinen@intel.com>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:48165 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbdFHKRn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Jun 2017 06:17:43 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjeTaZTJDEViBRq2y1q715EssHUdgxOFNVf1H7JzpJ6hw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 07, 2017 at 09:40:53PM +0200, Arturo Borrero Gonzalez wrote:
> On 7 June 2017 at 10:35, Ismo Puustinen <ismo.puustinen@intel.com> wrote:
> >
> > +static int directoryfilter(const struct dirent *de)
> > +{
> > +       if (strcmp(de->d_name, ".") == 0 ||
> > +                       strcmp(de->d_name, "..") == 0)
> > +               return 0;
> > +
> > +       /* Accept other filenames. If we want to enable filtering based on
> > +        * filename suffix (*.nft), this would be the place to do it.
> > +        */
> > +
> 
> This filter by suffix is good to have IMHO.
> I guess that forcing users to explicitly create a file for nftables
> (or at least give a specific suffix) reduces chances for user errors.

You mean, this new include directory feature just takes *.nft files,
right?

Then, to keep it consistent, we should also display a warning in
include file with no .nft postfix. At deprecate the existing behaviour
at some point, ie. bail out if you include a file that has no trailing
.nft in its name.

If we follow this path, all ruleset file will end up using .nft as
a trailer in the name.

Is there any other similar software following this approach? How is
'ferm' doing this?
