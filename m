From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: patch in bugzilla
Date: Thu, 1 Mar 2012 00:27:39 +0100
Message-ID: <20120229232739.GB3817@1984>
References: <CAO88JF9FcBkjEs345hK4bOhQa1q-RuckkrLN9SKUUt3cWaLJKw@mail.gmail.com>
 <alpine.LNX.2.01.1202281409020.10284@frira.zrqbmnf.qr>
 <20120229125052.GA1115@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jonh Wendell <jonh.wendell@vexcorp.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54650 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757218Ab2B2X1o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:27:44 -0500
Content-Disposition: inline
In-Reply-To: <20120229125052.GA1115@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 29, 2012 at 01:50:52PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Feb 28, 2012 at 04:20:10PM +0100, Jan Engelhardt wrote:
> > On Tuesday 2012-02-28 13:48, Jonh Wendell wrote:
> > 
> > >hi, folks. a while ago I filled a bug with a simple patch attached:
> > >http://bugzilla.netfilter.org/show_bug.cgi?id=768
> > >
> > >what's the right place to post things like that? here in this mailing
> > >list or the bugzilla?
> > 
> > [Someone still has not pointed the bugzilla automatic notification to 
> > post to the netfilter-devel mailing list :) ]
> > 
> > Certainly the choice of mailing list makes it more visible. No 
> > objections to the patch.
> 
> Applied, thanks.

I'm going to revert this patch, it's breaking my iptables script:

# iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables: Incompatible with this kernel.

Please, test patches before posting them.
