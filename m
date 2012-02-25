From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] SSDP (UPnP) conntrack helper
Date: Sat, 25 Feb 2012 14:32:29 +0100
Message-ID: <20120225133229.GE15774@1984>
References: <jhkpju$dsp$1@dough.gmane.org>
 <20120224165359.GB11488@1984>
 <ji8r22$om2$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58612 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab2BYNcb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Feb 2012 08:32:31 -0500
Content-Disposition: inline
In-Reply-To: <ji8r22$om2$1@dough.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 24, 2012 at 02:13:54PM -0600, Ian Pilcher wrote:
> On 02/24/2012 10:53 AM, Pablo Neira Ayuso wrote:
> > We're targeting to have this helper and others in user-space in the
> > short tun.
> > 
> > I have a patch to add user-space helper infrastructure. I expect to
> > have it done soon.
> > 
> > I think it's time to think about having helpers in user-space.
> 
> Thanks for the response.
> 
> Assuming the user-space connection tracking thing pans out, it sounds
> like there isn't much possibility of this making it upstream.
> 
> I'd still like to get it the module finished up.  It's a useful learning
> exercise, and I think it could be useful for anyone who stays on an
> older kernel, "enterprise" distribution users for example.

I'll be very happy if you work on the user-space version. The
user-space cthelper infrastructure will be ready in two months
or so.

> I would *really* appreciate some feedback on the various questions that
> I've posed in this thread.

I think most of the questions can be replied by looking and
nf_conntrack_expect.c. I'll try to find some spare time to reply some
of those questions, but I don't promise anything.
