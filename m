From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/02]: nf_conntrack_tcp: fix connection reopening
 fix
Date: Thu, 18 Oct 2007 05:22:08 -0700 (PDT)
Message-ID: <20071018.052208.126115674.davem@davemloft.net>
References: <Pine.LNX.4.64.0710181231210.17074@bizon.gios.gov.pl>
	<20071018.051252.71873220.davem@davemloft.net>
	<47174EBA.5090903@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ole@ans.pl, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34821
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761758AbXJRMVy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:21:54 -0400
In-Reply-To: <47174EBA.5090903@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 18 Oct 2007 14:16:58 +0200

> David Miller wrote:
> > From: Krzysztof Oledzki <ole@ans.pl>
> > Date: Thu, 18 Oct 2007 12:37:42 +0200 (CEST)
> > 
> >>>> On Thu, 18 Oct 2007, Patrick McHardy wrote:
> >>>>
> >>>>> [NETFILTER]: nf_conntrack_tcp: fix connection reopening fix
> >>>>>
> >>>>> Setting the last_dir parameter was missing from the previous one.
> >>>> This description is IMHO wrong. It should be as in previous, little 
> >>>> incomplete (last_dir), patch:
> >>>>
> >>>> "If one side aborts an established connection, the entry still lingers for
> >>>> 10s in conntrack for the late packets. Allow to open up the connection
> >>>> again for the party which sent the RST packet."
> >>>
> > Please sort out this changelog message issue so I can apply
> > the patch correctly :-)
> 
> 
> Please take the one from Krzysztof :)

Done! :-)
