From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: tcp-window-tracking.patch question
Date: Fri, 20 Sep 2002 09:05:31 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0209200839370.21253-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.44.0209191558570.15133-100000@laptop1.agatha>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Oskar Andreasson <blueflux@koffein.net>,
	Jay Schulist <jschulist@bivio.net>,
	Harald Welte <laforge@gnumonks.org>
In-Reply-To: <Pine.LNX.4.44.0209191558570.15133-100000@laptop1.agatha>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Thu, 19 Sep 2002, Oskar Andreasson wrote:

> Quick question, do you know if the tcp-window-tracking patch will enter
> the main kernel tree, or if it is considered at all?

It'll enter the main kernel tree one time.

However, the problem encountered on kashyyyk (long mail delays due to
packets marked as out of window) must be sorted out before considering a
submission.

> Reason I am wondering is since I've pretty much based my ipsysctl
> documentation on your code, and I would hate to "put it down" just because
> this is not even close to how the final implementation will look:). My
> mistake if so, but still annoying.

That's another corner of the patch. I introduced the
/proc/net/ipv4/netfilter/ directory in order to keep all the
netfilter-related parameters separated - I believe it's much nicer, makes
easier to introduce new entries and it follows the source tree structure
as well.

Jay Schulist has just submitted a patch ('User defined udp and tcp
conntrack state timeouts') which implements the same feature but he keeps
the new knobs in /proc/net/ipv4/.

A decision should be taken on the systcl interface of netfilter.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
