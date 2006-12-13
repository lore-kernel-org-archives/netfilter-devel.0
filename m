From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables 1.3.7, kernel 2.6.19, ROUTE and Layer7 issues
Date: Wed, 13 Dec 2006 09:38:21 +0100
Message-ID: <457FBBFD.6060009@trash.net>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>	<457E6997.1050001@trash.net>
	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: linux@arcoscom.com
In-Reply-To: <36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>
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
> Thanks for your response.
> 
> I'm using multiple gateways for internet connection and having problems
> with random disconection, and I not use ROUTE usually, but I was trying to
> force only one gateway for one type of traffic (which the clients lost
> conections and are having issues).
> 
> I know I can use -j MARK or -j CONNMARK and this mark to filter, but I'm
> using marks for another purposes and I can't use it for routing.

Everything using marks supports bitmasks in 2.6.19.

> The box is a dual xeon and the kernel has been compiled SMP enabled.
> 
> I haven't tested ROUTE yet with this kernel (2.6.19), but with 2.6.18.x I
> were having a problem with -j ROUTE in -t mangle and POSTROUTING chain.
> 
> Perhaps ROUTE need a more in deepth revision?

As I said, it needs to fill in the targetsize field and probably needs
to adjust the target function signature.

> Do I help more reporting the bug into netfilter-bugzilla?

Its still down, but the ROUTE patch is unmaintained anyway.
