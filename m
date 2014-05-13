From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd, internal cache keeps filling up
Date: Tue, 13 May 2014 14:40:44 +0200
Message-ID: <20140513124044.GA3738@localhost>
References: <20140505104058.GA30297@finrod>
 <20140509113129.GA8031@localhost>
 <20140510061743.GA32197@finrod>
 <20140512163538.GA13344@localhost>
 <20140513114535.GA9209@finrod>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Martin Kraus <lists_mk@wujiman.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34967 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759727AbaEMM5s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2014 08:57:48 -0400
Content-Disposition: inline
In-Reply-To: <20140513114535.GA9209@finrod>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 13, 2014 at 01:45:35PM +0200, Martin Kraus wrote:
> On Mon, May 12, 2014 at 06:35:38PM +0200, Pablo Neira Ayuso wrote:
> > > current kernel is 3.13.7. 
> > > 
> > > we already hit a bug in the official 3.2 kernel packaged with wheezy where 
> > > our scan for heartbleed vulnerability would cause conntrackd to kernel panic
> > > the router.
> > 
> > Please, provide more information on how to reproduce the problem that
> > you're noticing. Thank you.
> 
> regarding the kernel panic on 3.2 a colleague of mine was using nmap with it's
> heartbleed plugin
> 
> nmap --script ssl-heartbleed -sT -oX logfile.log 10.0.0.0/20
> 
> http://nmap.org/nsedoc/scripts/ssl-heartbleed.html
> 
> it took about 30 minutes to trigger the problem.

Did you annotate the kernel oops backtrace? Without that information,
this is pretty much like looking for the needle in the stack.

> regarding the internal cache fill up. we have two routers and some vlans using
> one and some vlans using the other router as the default gateway. 
> 
> this is the conntrackd config on both routers.
> 
> Sync {
>         Mode FTFW {
>                 ResendQueueSize 131072
>                 ACKWindowSize 300
>                 DisableExternalCache On
>         }
>         UDP {
>                 IPv4_address 192.168.100.200
>                 IPv4_Destination_Address 192.168.100.100
>                 Port 3780
>                 Interface eth0
>                 Checksum on
>         }
>         Options {
>                 TCPWindowTracking On
>         }
> }
> 
> General {
>         Nice -20
> 
>         HashSize 65536
>         HashLimit 262144
> 
>         Syslog on
>         LockFile /var/lock/conntrack.lock
>         UNIX {
>                 Path /var/run/conntrackd.ctl
>                 Backlog 20
>         }
> 
>         NetlinkBufferSize 2097152
>         NetlinkBufferSizeMaxGrowth 8388608
>         NetlinkEventsReliable On
>         NetlinkOverrunResync Off
> 
>         Filter From Kernelspace {
>                 Address Ignore {
>                         IPv4_address 127.0.0.1 # loopback
>                 }
>         }
> }
> 
> We have about 80 users, some of them running window or macs, so there is
> plenty of multicasts and broadcasts that fill the conntrack table. some of
> these then get stuck in the conntrackd internal cache. We can see the
> LAST_ACK tcp states stuck in the internal cache as well, but I think these are
> related to TCPWindowTracking On.

Did you retry with lastest conntrack-tools version? If so, please
collect as much information as you can via all -s options, moreover
check the logs. If you didn't retry with lastest, please upgrade.
