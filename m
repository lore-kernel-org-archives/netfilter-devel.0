From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [resend] Passive OS fingerprint xtables match.
Date: Thu, 4 Jun 2009 15:37:23 +0400
Message-ID: <20090604113723.GA13018@ioremap.net>
References: <20090511095343.GA30778@ioremap.net> <4A1D6A20.8050404@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A1D6A20.8050404@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi.

On Wed, May 27, 2009 at 06:28:16PM +0200, Patrick McHardy (kaber@trash.net) wrote:
> >You will find something like this in the syslog:
> >Windows [2000:SP3:Windows XP Pro SP1, 2000 SP3]: 11.22.33.55:4024 -> 
> >11.22.33.44:139 hops=4
> >Linux [2.5:]: 1.2.3.4:44448 -> 11.22.33.44:22 hops=4
> 
> Please convert this to use nf_log_packet().

That's hard - there is no hook number in the match function, so we do
not really know if it is forward, input or prerouting.

In the version I'm about to send I fixed all rised issues except
multiple attributes - if there will be a need to extend attribute list
we can always switch them into new attribute except current all-in-one.

-- 
	Evgeniy Polyakov
