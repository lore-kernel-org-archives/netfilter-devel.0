From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH net-next] netfilter: nf_tables: limit maximum table name
 length to 32 bytes
Date: Thu, 5 Mar 2015 14:12:51 +0000
Message-ID: <20150305141251.GI29092@acer.localdomain>
References: <1425564336-7265-1-git-send-email-pablo@netfilter.org>
 <20150305140532.GH29092@acer.localdomain>
 <20150305141259.GA7374@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60847 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbbCEOM4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 09:12:56 -0500
Content-Disposition: inline
In-Reply-To: <20150305141259.GA7374@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05.03, Pablo Neira Ayuso wrote:
> On Thu, Mar 05, 2015 at 02:05:32PM +0000, Patrick McHardy wrote:
> > On 05.03, Pablo Neira Ayuso wrote:
> > > Set the same as we use for chain names, it should be enough.
> > > 
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > > @Patrick: I'm planning to add per-table information after the name field, this
> > > will make it easier and this stays consistent to what we have in chains and
> > > sets (and other new object we'll add). I wouldn't expect people using larger
> > > names than this limit.
> > 
> > What kind of information are we talking about?
> 
> The hardware offload stuff, we'll need to keep a reference to the
> net_device *dev in the table, to call this from the commit path. But I
> can keep this in that batch if you prefer to have a larger view on
> this.

Seems fine to me in either case, a larger name does indeed seem
unnecessary and inconsistent.

BTW, what about my patches? :) Waiting for them (especially the
fixes) to make their way to nf-next to continue ...
