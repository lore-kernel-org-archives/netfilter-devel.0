From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: (D)NAT with IPv6 (was "nf_conntrack & NAT")
Date: Wed, 7 Dec 2005 16:09:25 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0512071603190.17863@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
	<20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
	<20051206173135.GQ5617@eychenne.org>
	<Pine.LNX.4.58.0512071201460.17863@blackhole.kfki.hu>
	<20051207145438.GA5617@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20051207145438.GA5617@eychenne.org>
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

On Wed, 7 Dec 2005, Herve Eychenne wrote:

> I don't want to use DNAT for load balancing.  I want to use DNAT (and
> I'm using it just now with IPv4) to redirect traffic destined to a
> certain IP/port to another IP (private or not) in the most transparent
> way. There are plenty of scenari where I'm willing to do that.
>
> For those who need practical examples (others can stop here) that I'm
> regularly facing myself, here it is.
>
> Then MX of domain points on host A, and I want to redirect SMTP traffic
> to host B (also in my network) in the most atomic way.
> DNS propagation can be slow (caching), and user proxying is too slow
> (and not transparent).
> If there are miraculous mecanisms in IPv6 which enable to achieve that
> redirection as atomically and quickly that DNAT, please let me know.

Yes, use as many IP addresses as you want :-):

Host A:
	addressA0: maintenance
	addressA1: az advertised SMTP server
	addressA2: az advertised HTTP server
	...
Host B:
	addressB0: maintenance
	addressB1: az advertised SMTP server
	addressB2: az advertised HTTP server
	...

If you want to "replace" A as SMTP server by server B, just assign
addressA1 to server B. That's it. No NAT required at all and it
is practically atomic.

(Assumed the same network as you wrote.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
