From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat-experimental5 PATCH] iptables: xtables-eb: fix
 renaming of chains
Date: Mon, 24 Nov 2014 19:58:46 +0100
Message-ID: <20141124185846.GA15664@salvia>
References: <20141120120931.24603.59259.stgit@nfdev.cica.es>
 <20141120122033.GA11615@salvia>
 <CAOkSjBha3BuK0HvwSgp+9-xcRrHfbxKasrOcne91ZOJEVY7kzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Giuseppe Longo <giuseppelng@gmail.com>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59216 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbaKXS4j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:56:39 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBha3BuK0HvwSgp+9-xcRrHfbxKasrOcne91ZOJEVY7kzg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 24, 2014 at 07:27:40PM +0100, Arturo Borrero Gonzalez wrote:
> On 20 November 2014 at 13:20, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> diff --git a/iptables/xtables-eb-standalone.c b/iptables/xtables-eb-standalone.c
> >> index 1c3cbf0..740a420 100644
> >> --- a/iptables/xtables-eb-standalone.c
> >> +++ b/iptables/xtables-eb-standalone.c
> >> @@ -84,7 +84,7 @@ int xtables_eb_main(int argc, char *argv[])
> >>               ret = nft_commit(&h);
> >>
> >>       if (!ret)
> >> -             fprintf(stderr, "%s\n", nft_strerror(errno));
> >> +             xtables_error(OTHER_PROBLEM, "%s\n", nft_strerror(errno));
> >
> > IIRC error reporting in ebtables differs from iptables. The output
> > should look the same. We're currently using nft_strerror() but I guess
> > we'll need a ebt_strerror() function.
> >
> 
> I've tried to collect ebtables original errors. Most of them uses
> arguments, for example:
>  * Can't delete the chain 'test', it's referenced in chain 'FORWARD', rule 0.
>  * Loop from chain 'test2' to chain 'test'.
> 
> So, that ebt_strerror() function seems almost useless.
> 
> I will resend this patch with the changes you requested. I guess we
> can revisit that issue in the future.

Sure, please go ahead. Just document limitations, just in case we
revisit this later on. Thanks.
