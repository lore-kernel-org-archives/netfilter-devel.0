From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] tcp-window-tracking patch
Date: Wed, 10 Dec 2003 13:34:43 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0312101322140.7667-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.44.0312091713500.26124-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0312091713500.26124-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 9 Dec 2003, Henrik Nordstrom wrote:

> On Tue, 9 Dec 2003, Jozsef Kadlecsik wrote:
>
> > Yes, that's true. The original value was 60 secs. That was increased to 3
> > days in the window tracking code, which was surely excessive: there might
> > be no resent traffic to detect and thus long dead connections could stay
> > in the hash table. Hard to choose the proper value, which does not break
> > either way.
>
> Would it be possible to classify these as "junk" somehow with the
> intention to keep them around in the connection table longer when not
> under pressure?

How long should we keep them in the connection table?

But the current approach for hunting connections to drop when the table
is full is not satisfactory: we search in the hash bucket we'd insert
the new entry and in one another random bucket only. It's quite possible
that there are plenty of entries which could be dropped but we do not
find them.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
