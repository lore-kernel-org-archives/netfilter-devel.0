From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/02]: nf_conntrack_tcp: fix connection reopening
 fix
Date: Thu, 18 Oct 2007 05:12:52 -0700 (PDT)
Message-ID: <20071018.051252.71873220.davem@davemloft.net>
References: <Pine.LNX.4.64.0710181223310.17074@bizon.gios.gov.pl>
	<4717359E.9020208@trash.net>
	<Pine.LNX.4.64.0710181231210.17074@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: ole@ans.pl
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51566
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755952AbXJRMMi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:12:38 -0400
In-Reply-To: <Pine.LNX.4.64.0710181231210.17074@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Krzysztof Oledzki <ole@ans.pl>
Date: Thu, 18 Oct 2007 12:37:42 +0200 (CEST)

> 
> 
> On Thu, 18 Oct 2007, Patrick McHardy wrote:
> 
> > Krzysztof Oledzki wrote:
> >> 
> >> 
> >> On Thu, 18 Oct 2007, Patrick McHardy wrote:
> >> 
> >>> [NETFILTER]: nf_conntrack_tcp: fix connection reopening fix
> >>> 
> >>> Setting the last_dir parameter was missing from the previous one.
> >> 
> >> This description is IMHO wrong. It should be as in previous, little 
> >> incomplete (last_dir), patch:
> >> 
> >> "If one side aborts an established connection, the entry still lingers for
> >> 10s in conntrack for the late packets. Allow to open up the connection
> >> again for the party which sent the RST packet."
> >
> >
> > The first patch was submitted seperately with a somewhat similar
> > description. This is just the incremental fix.
> 
> No, there are two independent fixes. The first one is already in the 
> mainline (nf_conntrack_tcp: fix connection reopening) and it is OK:
>    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=17311393f969090ab060540bd9dbe7dc885a76d5
> 
> The second one had been incomplete:
>   http://marc.info/?l=netfilter-devel&m=119214261727254&w=1
> and it was recently fixed:
>   http://marc.info/?l=netfilter-devel&m=119264302103523&w=1
> 
> So, this "Setting the last_dir parameter was missing from the previous 
> one." comment applies to this patch:
>   http://marc.info/?l=netfilter-devel&m=119214261727254&w=1

Please sort out this changelog message issue so I can apply
the patch correctly :-)

Thanks!
