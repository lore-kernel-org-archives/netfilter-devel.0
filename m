From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/4] examples/nf-queue: handle recv error, use larger
 buffer
Date: Fri, 26 Apr 2013 09:27:01 +0200
Message-ID: <20130426072701.GC32324@breakpoint.cc>
References: <1366886611-21666-1-git-send-email-fw@strlen.de>
 <1366886611-21666-3-git-send-email-fw@strlen.de>
 <20130426014244.GB4510@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48414 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412Ab3DZH1F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:27:05 -0400
Content-Disposition: inline
In-Reply-To: <20130426014244.GB4510@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Apr 25, 2013 at 12:43:29PM +0200, Florian Westphal wrote:
> > We ask for 0xffff copy size, so we need a buffer that can
> > hold 0xffff, plus a few more bytes to allow for netlink attributes.
> > 
> > Also, turn off/handle ENOBUFS.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  examples/nf-queue.c |   38 +++++++++++++++++++++++++-------------
> >  1 files changed, 25 insertions(+), 13 deletions(-)
> > 
> > diff --git a/examples/nf-queue.c b/examples/nf-queue.c
> > index 7adac21..57ba483 100644
> > --- a/examples/nf-queue.c
> > +++ b/examples/nf-queue.c
> > @@ -1,3 +1,4 @@
> > +#include <errno.h>
> >  #include <stdio.h>
> >  #include <stdlib.h>
> >  #include <unistd.h>
> > @@ -82,7 +83,8 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
> >  
> >  int main(int argc, char *argv[])
> >  {
> > -	char buf[MNL_SOCKET_BUFFER_SIZE];
> > +	char *buf;
> > +	size_t sizeof_buf = 0xffff + 2084;
> 
> I think users will appreciate a comment to explain why those black
> magic numbers are there ;-). Probably using MNL_SOCKET_BUFFER_SIZE/2
> instead of 2084.

Good point :-)
I'll do that and add a comment explaining this, e.g.
"largest possible packet payload, plus netlink data overhead"

> > +	/* ENOBUFS is signalled to userspace when packets were lost
> > +	 * on kernel side.  In most cases, userspace isn't interested
> > +	 * in this information, so turn it off.
> > +	 */
> > +	ret = 1;
> > +	mnl_socket_setsockopt(nl, NETLINK_NO_ENOBUFS, &ret, sizeof(int));
> >  
> > -		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
> > +	for (;;) {
> > +		ret = mnl_socket_recvfrom(nl, buf, sizeof_buf);
> >  		if (ret == -1) {
> > +			if (errno == ENOBUFS) /* messages were lost */
> 
> Hm, you disabled ENOBUFS errors, right?

True. I'll remove the check.
