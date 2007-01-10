From: Patrick McHardy <kaber@trash.net>
Subject: Re: dst cache overflow
Date: Wed, 10 Jan 2007 13:57:44 +0100
Message-ID: <45A4E2C8.8030302@trash.net>
References: <60665.10.1.1.10.1167776653.squirrel@www.arcoscom.com>	<55635.10.1.1.10.1167946368.squirrel@www.arcoscom.com>	<45A492AE.2030909@trash.net>
	<43702.195.55.244.106.1168431388.squirrel@www.arcoscom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: linux@arcoscom.com
In-Reply-To: <43702.195.55.244.106.1168431388.squirrel@www.arcoscom.com>
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
> The configuration is:
>    1) linux box with 2.6.19.1 kernel with these patches/modules:
>       a) l7-filter
>       b) multipath patch (from nano-howto)
>       c) IMQ
>       d) ipp2p
>       e) connlimit
>    2) 4 ethernet interfaces:
>       a) 2 external (eth1 and eth3) interfaces with balanced links (as
> described in nato-howto).
>       b) 2 internal ineterfaces (eth0 and eth2) in bridge zlan0 with STP
> enabled and configured.
>    3) For tests I load manually ALL conntrack/nat kernel modules.

Please try to reproduce this without all these whacky patches (or at
least without multipath and IMQ).
