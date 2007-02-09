From: Patrick McHardy <kaber@trash.net>
Subject: Re: Opinions about pom/patches [was: iptables 1.3.7, kernel
	2.6.19, ROUTE and Layer7 issues]
Date: Fri, 09 Feb 2007 18:03:51 +0100
Message-ID: <45CCA977.9080704@trash.net>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>	<457E6997.1050001@trash.net>	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>	<457FBBFD.6060009@trash.net>	<Pine.LNX.4.64.0612282158360.16672@bizon.gios.gov.pl>	<45A48087.8090200@trash.net>	<Pine.LNX.4.61.0701101233080.3029@yvahk01.tjqt.qr>	<54696.195.55.244.106.1168435275.squirrel@www.arcoscom.com>	<1169746884.4253.51.camel@andybev.localdomain>	<45C005EB.1040704@netfilter.org>	<1171028254.4244.26.camel@andybev.localdomain>
	<Pine.LNX.4.64.0702091741250.9884@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <lartc-bounces@mailman.ds9a.nl>
In-Reply-To: <Pine.LNX.4.64.0702091741250.9884@bizon.gios.gov.pl>
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
> Getting back to the question: generally I have no objection for
> forwarding connlinit to the mainline but I believe we should first
> investigate a possibilty to add support for other protocols than TCP.
> AFAIK at least UDP support could be very usefull - p2p software
> generates not only a lot of tcp cnnections but also udp flows and main
> job for this extension is to prevent conntrack database overflows.

Feel free to post a version you consider suitable for merging
(without all the version ifdefs, only nf_conntrack support,
etc). I had a quick look at the current version and it seems
to maintain some internal hash of connections, IIRC that has
not always been the case. In case that change is from you
please add a short description. And it should probably support
all protocols.
