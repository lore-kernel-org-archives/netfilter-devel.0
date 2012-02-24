From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] DHCPv6 connection tracker helper
Date: Fri, 24 Feb 2012 18:54:20 +0100
Message-ID: <20120224175420.GA11587@1984>
References: <CAFntDkx2SUkCkSbU7sO4OrWqypWQpY-KNgrD-_DgqRSXAGvJZQ@mail.gmail.com>
 <alpine.LNX.2.01.1202130940390.30851@frira.zrqbmnf.qr>
 <CAFntDkw0sN=j+mKm0s=kac+mMWnQqdyUviGj0_puj0bqSobR=Q@mail.gmail.com>
 <alpine.LNX.2.01.1202151758290.15357@frira.zrqbmnf.qr>
 <CAFntDkx_aZ4Pvfg21yHUDYWcaG=pwk28xwjpv1Sh9q0B4N+TRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Darren Willis <djw@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44110 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab2BXRy1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:54:27 -0500
Content-Disposition: inline
In-Reply-To: <CAFntDkx_aZ4Pvfg21yHUDYWcaG=pwk28xwjpv1Sh9q0B4N+TRw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 16, 2012 at 01:56:01PM +0900, Darren Willis wrote:
> On Thu, Feb 16, 2012 at 02:13, Jan Engelhardt <jengelh@medozas.de> wrote:
> >>It would be possible to capture outgoing messages' transaction IDs and
> >>require that incoming advertise/reply responses match it, but I'm not
> >>sure that's really going to be a big help (the clients are surely
> >>doing this already).
> >
> > Certainly would be on my wishlist if such an extension does not look
> > too ugly.
> 
> Probably not too ugly. Transaction IDs are effectively one-shot,
> except for solicit/advertise, so just keeping a couple of arrays of
> sent transaction IDs and checking incoming messages for a match could
> work (one array for solicit transaction IDs, which can get multiple
> replies, and one array for 'normal' transaction IDs, which can't).
> Array size could reasonably be expected to be 1 entry per DHCPv6
> server, I think. There'd need to be a scheme for evicting old IDs as
> well. I'm considering this a bit of a to-do-later though.
> 
> Oh, right now this module has an expect_policy with max expected of 1,
> which I'm assuming is a hard limit of 1 expectation. Not sure what the
> usual decision is on this - typical case is going to be 1 DHCPv6
> server, but more are allowed.
> 
> > Irk. I would suggest doing like the ICMPv6 tracker does,
> > marking it unconditionally as INVALID to indicate that the
> > implementation chose to not track RECONFIGURE on purpose.
> 
> The thing with reconfigure is I've got nowhere to track it (sensibly).
> RECONFIGURE just appears out of the blue from a DHCPv6 server. Right
> now this module's only deals with messages from the client, I don't
> examine incoming DHCPv6 packets at all, I just set up expectations for
> them.
> 
> Another revision with your changes and a bugfix (I was dereferencing
> udph before checking it was NULL in the last one...)

Thanks for the patch.

I still have two concerns with this:

1) In the last Netfilter workshop, we decided that we're targeting
towards explicit helper configuration via iptables, ie. something
like:

ip6tables -I OUTPUT -t raw -s $SRC -d $DST \
        -p udp --dport 547 -j CT --helper dhcpv6

According to your report, this is exactly what distributors don't
want to do. The reason why we're doing this was that we have detected
problems in default configuration of non-broadcast helpers (read Eric
Leblond article):

http://home.regit.org/netfilter-en/secure-use-of-helpers/

If we move towards explicit helper configuration, distributors will
have to add the rule above.

2) The helper infrastructure is allowing us to filter broadcast
traffic but I think that it's  been designed for a different purpose.
I know, we don't have any better by now. But in the meanwhile, we're
adding specific helpers to support each broadcast protocol.
