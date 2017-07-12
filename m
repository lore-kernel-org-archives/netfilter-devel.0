From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 2/4] list: Introduce list_last_entry
Date: Wed, 12 Jul 2017 21:15:05 +0200
Message-ID: <20170712191505.GF16375@orbyte.nwl.cc>
References: <20170712123658.25363-1-phil@nwl.cc>
 <20170712123658.25363-3-phil@nwl.cc>
 <CAOkSjBgy1e_L8a8Epo8XbYWH8_GTdBX=KeWZLC_nqeOYtU8jdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:52627 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752450AbdGLTPH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 15:15:07 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBgy1e_L8a8Epo8XbYWH8_GTdBX=KeWZLC_nqeOYtU8jdg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 12, 2017 at 05:41:32PM +0200, Arturo Borrero Gonzalez wrote:
> On 12 July 2017 at 14:36, Phil Sutter <phil@nwl.cc> wrote:
> > Similar to list_first_entry, this macro allows to retrieve the list's
> > last entry.
> >
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  include/list.h | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> 
> Phil,
> 
> I think you can safely merge this patch into 1/4.
> 
> Better to introduce new functions at the same time of the callers, the
> same patch.

Well, patches 2 and 3 are used by patch 4, so not added afterwards (that
would be a bummer indeed). I kept them separate for a purpose: When
backporting fixes, it is often quite annoying when one has to fiddle
these independent parts out of another patch which does something
unrelated. So whenever One wants to backport a patch using
list_first_entry() (in this example), there is a separate commit to
backport which contains the macro and nothing else. No big deal in this
case, though so no objections merging them.

Thanks, Phil
