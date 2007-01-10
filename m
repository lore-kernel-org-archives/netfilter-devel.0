From: Patrick McHardy <kaber@trash.net>
Subject: Re: dst cache overflow
Date: Wed, 10 Jan 2007 08:15:58 +0100
Message-ID: <45A492AE.2030909@trash.net>
References: <60665.10.1.1.10.1167776653.squirrel@www.arcoscom.com>
	<55635.10.1.1.10.1167946368.squirrel@www.arcoscom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: linux@arcoscom.com
In-Reply-To: <55635.10.1.1.10.1167946368.squirrel@www.arcoscom.com>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

ArcosCom Linux User wrote:
> The log says:
> 
> Dec 30 00:52:27 cura kernel: dst cache overflow
> Dec 30 00:52:27 cura kernel: MASQUERADE: No route: Rusty's brain broke!
> Dec 30 00:52:27 cura kernel: dst cache overflow
> Dec 30 00:52:28 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
> Dec 30 00:52:28 cura kernel: zlan0: topology change detected, propagating
> Dec 30 00:52:28 cura kernel: dst cache overflow
> Dec 30 00:52:30 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
> Dec 30 00:52:30 cura kernel: zlan0: topology change detected, propagating
> Dec 30 00:52:32 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
> Dec 30 00:52:32 cura kernel: zlan0: topology change detected, propagating
> Dec 30 00:52:32 cura kernel: printk: 15 messages suppressed.
> Dec 30 00:52:32 cura kernel: dst cache overflow
> Dec 30 00:52:34 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
> Dec 30 00:52:34 cura kernel: zlan0: topology change detected, propagating
> Dec 30 00:52:36 cura kernel: zlan0: received tcn bpdu on port 1(eth0)
> Dec 30 00:52:36 cura kernel: zlan0: topology change detected, propagating
> Dec 30 00:52:37 cura kernel: printk: 40 messages suppressed.
> Dec 30 00:52:37 cura kernel: dst cache overflow
> 
> zlan0 is a bridge (with STP configured) between some LANs.
> 
> Thanks
> 
> P.D.: I'm a bit desesperated with this error, I changed "MASQUERADE" with
> "SNAT" with no sense. Some hours after router is booted up, the network
> appears to be UP but all ifaces haven't responses.


The MASQUERADE message is just an effect of the problem. Please describe
your setup in more detail (what kind of devices, how are they connected,
ebtables/iptables rules, routing, ...).
