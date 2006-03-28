From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Hashtrie testing2 (was: Re: [PATCH 4/4] first conntrack ID must
 be 1 not 2)
Date: Tue, 28 Mar 2006 14:26:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0603281413520.3483@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0603250927490.31915@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0603250927490.31915@blackhole.kfki.hu>
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

Hi Martin,

On Sat, 25 Mar 2006, Jozsef Kadlecsik wrote:

> > A lot of your changes should go into svn, you have full freedom to
> > change whatever you want.
>
> OK, I'll commit it sometime at the weekend. :-)
[...]

The new version finally is in svn :-) The new results and comments can be
found at

http://people.netfilter.org/kadlec/hashtrie

A short summary:

- sfhash does indeed faster than jhash when CPU-dependent optimization is
  enabled
- hastrie with variable hash sizes at the different level can help,
  surprisingly both in memory and speed. I tested three variants, there
  may easily be other ones which are even better.
- hasharray is very good on the price of some memory. But very good,
  and simple.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
