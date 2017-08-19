From: Eric Leblond <eric@regit.org>
Subject: Re: [nft PATH 06/16] libnftables: add missing variable to library
Date: Sat, 19 Aug 2017 13:02:35 +0200
Message-ID: <1503140555.31564.25.camel@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
         <20170816204310.3371-7-eric@regit.org>
         <20170817093502.GV16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:59062 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751329AbdHSLCj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 07:02:39 -0400
In-Reply-To: <20170817093502.GV16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, 2017-08-17 at 11:35 +0200, Phil Sutter wrote:
> On Wed, Aug 16, 2017 at 10:43:00PM +0200, Eric Leblond wrote:
> > Signed-off-by: Eric Leblond <eric@regit.org>
> > ---
> >  src/libnftables.c | 2 ++
> >  src/main.c        | 1 -
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/src/libnftables.c b/src/libnftables.c
> > index 6599248..6d4aceb 100644
> > --- a/src/libnftables.c
> > +++ b/src/libnftables.c
> > @@ -33,6 +33,8 @@ unsigned int handle_output;
> >  unsigned int debug_level;
> >  #endif
> >  
> > +const char *include_paths[INCLUDE_PATHS_MAX] = {
> > DEFAULT_INCLUDE_PATH };
> > +
> 
> I guess this belongs into nft_ctx as well.

Yes, it could be done later.

++
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
