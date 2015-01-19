From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH iptables] iptables: use IPC semaphore instead of abstract
 unix sockets
Date: Mon, 19 Jan 2015 13:08:33 +0000
Message-ID: <20150119130833.GA8818@acer.localdomain>
References: <1421615616-23053-1-git-send-email-pablo@netfilter.org>
 <alpine.LSU.2.11.1501182227200.16158@nerf60.vanv.qr>
 <20150119122410.GA4206@salvia>
 <20150119125118.GK17886@acer.localdomain>
 <20150119130024.GA4410@salvia>
 <20150119130634.GA4425@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
	kernel@linuxace.com, lennart@poettering.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35369 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbASNIj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:08:39 -0500
Content-Disposition: inline
In-Reply-To: <20150119130634.GA4425@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19.01, Pablo Neira Ayuso wrote:
> On Mon, Jan 19, 2015 at 02:00:24PM +0100, Pablo Neira Ayuso wrote:
> > On Mon, Jan 19, 2015 at 12:51:19PM +0000, Patrick McHardy wrote:
> > > On 19.01, Pablo Neira Ayuso wrote:
> > > > "This patch introduces a semaphore that is identified by the path to
> > > > the iptables binary, it also relies on SEM_UNDO so the kernel performs
> > > > the up() operation at process exit to avoid races with signals. This
> > > > also avoids file locks that require a writable filesystem."
> > > 
> > > Is it wise to use the path? Not that its very common, but multiple
> > > binaries would still race. Any reason you chose not to use something
> > > globally unique?
> > 
> > What kind of race are you worrying about?
> 
> Oh, I get it. Several different iptables binaries located in different
> paths. This patch cannot address that situation, we can select a
> hardcoded key but we may conflict with other applications.

Sure, but that risk also exists with using the path.

> Regarding the use of posix semaphores, there is no SEM_UNDO feature,
> so we can have problem if this receives a kill signal or it
> abort/crash somewhere in the code.
> 
> I think the best solution is to use to flock() as others do but then
> we need a writable filesystem() which is what Phil was trying to skip.
> 
> Question is if we should really care. I mean, this locking solution
> was introduced as a workaround given we couldn't solve this in the
> kernel.

I think your patch is fine, just wanted to point out that we might
want to choose a hardcoded name. I think the risk of clashes with
other applications is absolutely minimal.
