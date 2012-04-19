From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2.1] conntrack: add /proc entry to disable helper by
 default
Date: Thu, 19 Apr 2012 20:11:15 +0200
Message-ID: <20120419181115.GB17764@1984>
References: <1332917824-4839-1-git-send-email-eric@regit.org>
 <1332940790-18337-1-git-send-email-eric@regit.org>
 <1332940790-18337-2-git-send-email-eric@regit.org>
 <20120412152651.GA10677@1984>
 <1334246771.6042.13.camel@tiger.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39258 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab2DSSLT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:11:19 -0400
Content-Disposition: inline
In-Reply-To: <1334246771.6042.13.camel@tiger.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 12, 2012 at 06:06:11PM +0200, Eric Leblond wrote:
> Hello,
> 
> On Thu, 2012-04-12 at 17:26 +0200, Pablo Neira Ayuso wrote:
> > Hi Eric,
> > 
> > On Wed, Mar 28, 2012 at 03:19:50PM +0200, Eric Leblond wrote:
> > > This patch gives the user different methods to disable
> > > the attachment of helper to all connections on a given
> > > port. The idea is to allow the user to choose with the CT target
> > > the helper assignement he wants to have.
> > > 
> > > First method it to use the 'nf_conntrack_helper' option on the
> > > nf_conntrack module and set it to 0. As this is a constraint to do
> > > this at the time of the loading, a /proc entry is also available.
> > > Setting sys/net/netfilter/nf_conntrack_auto_assign_helper to 0 will
> > > disable the automatic assignement of the helper.
> > 
> > I have modified your patch a bit, please find the one I plan to apply
> > enclosed to this email.
> > 
> > I have also heavily rewritten the description. I decided to keep you
> > as author, if you're OK with it.
> 
> OK for authoring. I really like more the new description :)

I have enqueued this patch for net-next with some minor modification:
I've made the notice that is spotted one per-net aware.

I still have to extend the Netfilter news talking about the
deprecation, I'll try to make it tomorrow.
