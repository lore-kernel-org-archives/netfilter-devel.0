From: Eric Leblond <eric@regit.org>
Subject: Re: [PATH nft v2 08/18] libnftables: add missing variables to
 library
Date: Mon, 21 Aug 2017 21:04:48 +0200
Message-ID: <1503342288.9868.7.camel@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
         <20170819152420.22563-9-eric@regit.org> <20170821082722.GF2982@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:52618 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753628AbdHUTEx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 15:04:53 -0400
In-Reply-To: <20170821082722.GF2982@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Mon, 2017-08-21 at 10:27 +0200, Pablo Neira Ayuso wrote:
> On Sat, Aug 19, 2017 at 05:24:10PM +0200, Eric Leblond wrote:
> > This patch also avoids double definition of global vars.
> > 
> > Signed-off-by: Eric Leblond <eric@regit.org>
> > ---
> >  src/libnftables.c | 2 ++
> >  src/main.c        | 6 ------
> >  2 files changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/src/libnftables.c b/src/libnftables.c
> > index 446ec1e..28f9272 100644
> > --- a/src/libnftables.c
> > +++ b/src/libnftables.c
> > @@ -33,6 +33,8 @@ unsigned int handle_output;
> >  unsigned int debug_level;
> >  #endif
> >  
> > +const char *include_paths[INCLUDE_PATHS_MAX] = {
> > DEFAULT_INCLUDE_PATH };
> 
> Would you send an initial patch to place this in nft_ctx?
> 
> Otherwise, we can probably tell Varsha - Outreachy to do this for
> you.

I'm really fine with Varsha taking it!

> 
> >  void nft_global_init(void)
> >  {
> >  	mark_table_init();
> > diff --git a/src/main.c b/src/main.c
> > index 9b4e450..7ab01b7 100644
> > --- a/src/main.c
> > +++ b/src/main.c
> > @@ -29,12 +29,6 @@
> >  #include <iface.h>
> >  #include <cli.h>
> >  
> > -unsigned int max_errors = 10;
> > -#ifdef DEBUG
> > -unsigned int debug_level;
> > -#endif
> 
> These are being removed here, so I guess this is a leftover from
> previous patch.
> 
> Anyway, I think these are candidates for the ctx object too, let me
> have a look if I can send you a quick patch to sort out this.

OK perfect.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
