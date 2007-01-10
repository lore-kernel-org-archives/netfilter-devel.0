From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables 1.3.7, kernel 2.6.19, ROUTE and Layer7 issues
Date: Wed, 10 Jan 2007 06:58:31 +0100
Message-ID: <45A48087.8090200@trash.net>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>	<457E6997.1050001@trash.net>	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>	<457FBBFD.6060009@trash.net>
	<Pine.LNX.4.64.0612282158360.16672@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: Krzysztof Oledzki <ole@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0612282158360.16672@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
>> Its still down, but the ROUTE patch is unmaintained anyway.
> 
> 
> How about attached (and inlined) patch. BTW - is it possible to add a
> Kconfig entry after a specific text, like with Makefile.ladd?
> 
> 
> [POM-NG] ROUTE: 2.6.19 compatibility fix
> 
> Make both IPv4 and IPv6 versions compatible with 2.6.19


Thanks Krzysztof, applied.

I would prefer to have someone maintain it externally though. Jan, are
you still interested in doing that? If you need help or webspace for
an external repository please let me know.
