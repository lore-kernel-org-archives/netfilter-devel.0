From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_tables: add generation mask to
 table objects
Date: Mon, 10 Aug 2015 20:37:15 +0200
Message-ID: <20150810183715.GA12171@salvia>
References: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
 <20150804090917.GA6033@acer.localdomain>
 <20150804092905.GA7944@salvia>
 <20150804102635.GC6033@acer.localdomain>
 <20150804170447.GA3355@salvia>
 <20150805090915.GD13187@acer.localdomain>
 <20150806102043.GA18683@salvia>
 <20150810075646.GA20899@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38340 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbbHJSbR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 14:31:17 -0400
Content-Disposition: inline
In-Reply-To: <20150810075646.GA20899@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 10, 2015 at 09:56:46AM +0200, Patrick McHardy wrote:
> On 06.08, Pablo Neira Ayuso wrote:
> > On Wed, Aug 05, 2015 at 11:09:16AM +0200, Patrick McHardy wrote:
[...]
> > > > - preparation phase -
> > > > delete table y
> > > > create table y
> > > > create set x
> > > > - commit phase -
> > > > send NEWGEN, attribute type: begin
> > > > delete table y
> > > > create table y
> > > > create set x
> > > > send NEWGEN, attribute type: end
> > > > 
> > > > Thanks for your feedback!
> > > 
> > > That might work if the message ordering is then guaranteed. However I think
> > > we can fix this case without changing NEWGEN. Let me think about that a bit,
> > > for now just taking care of the genid checks correctly seems like a good
> > > step forward.
> > 
> > But we can catch this problem through ->res_id, OK?
> 
> I guess we could with a unique res_id per object, but how would this work
> with multiple object types? Any change bumps res_id, so we'd invalidate
> the full dump for any change.

I see, if we want to be able to invalidate caches at per-object level,
then I think we have to recover the idea of having a netlink attribute
for the per-object generation counter.
