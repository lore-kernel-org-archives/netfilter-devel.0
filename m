From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: nf_conntrack & NAT
Date: Wed, 7 Dec 2005 12:22:22 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0512071201460.17863@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
	<20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
	<20051206173135.GQ5617@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Jan Kasprzak <kas@fi.muni.cz>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20051206173135.GQ5617@eychenne.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 6 Dec 2005, Herve Eychenne wrote:

> On Tue, Dec 06, 2005 at 09:13:21PM +0530, Harald Welte wrote:
>
> > for stuff like redirecting traffic, all you really need is stateless
> > rewriting of the destination address.  If people want that, the entire
> > implementation fits in a single ip6tables target.  no relation to
> > nf_conntrack at all.
>
> Stateless?  And what if you want the response (of the packets which have
> been redirected) to come back with their initial address, as if they
> had not been redirected? (if the client shouldn't know that, if this
> should be transparent to him)
> This is also known as DNAT, for which the state has be stored, right?
>
> So, in one word: if we definitely need DNAT with IPv4 today, why
> wouldn't we need DNAT with IPv6?

IPv6 is not just IPv4 with a larger address space. Definitely there is no
need for DNAT in order to make a server with private address available.
But I can imagine for example to replace the "need" for DNAT with anycast
in IPv6 for load balancing.

Old hacks and workarounds should not be reimplemented blindly.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
