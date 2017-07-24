From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH] monitor: Print NEWGEN events
Date: Mon, 24 Jul 2017 17:37:32 +0200
Message-ID: <20170724153732.GQ16375@orbyte.nwl.cc>
References: <20170719143257.3772-1-phil@nwl.cc>
 <20170724111730.GA6691@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:43975 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753363AbdGXPhd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 11:37:33 -0400
Content-Disposition: inline
In-Reply-To: <20170724111730.GA6691@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 24, 2017 at 01:17:30PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 19, 2017 at 04:32:57PM +0200, Phil Sutter wrote:
> > Now that they contain process information, they're actually interesting.
> > For backwards compatibility, print process information only if it was
> > present in the message.
> 
> Wait, a couple of comments.

All ACK, one remark:

[...]
> > +		case NFTA_GEN_PROC_NAME:
> > +			if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
> > +				break;
> > +			strncpy(name, mnl_attr_get_str(attr), sizeof(name));
> 
> What is maximum process name length? If we hit this bound, we have to
> make sure this does:
> 
>                         name[X - 1] = '\0';
> 
> Where X is the name buffer size.

NFTA_GEN_PROC_NAME attribute is filled with output from get_task_comm(),
which returns a string of max 16 bytes length. It is safe to assume that
it's NULL terminated since set_task_comm() uses strlcpy().

That static buffer above is needless though, so I'll change it to just
point to the netlink attribute itself if it is present.

Thanks, Phil
