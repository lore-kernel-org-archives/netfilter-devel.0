From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Tue, 1 Jun 2004 11:48:11 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406011128390.4755-100000@blackhole.kfki.hu>
References: <40AE8A42.9060908@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40AE8A42.9060908@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

As far as I remember there are two issues not settled down yet:

On Sat, 22 May 2004, Pablo Neira wrote:

> - use of defined flags in tcp.h

As Patrick reminded us, we cannot use the TCPCB_FLAG_* flags. And I'm
reluctant to use the enumerated values from include/linux/tcp.h because
then I should have to add shifts to the window tracking code - just to
eliminate the locally defined flags. What'd we gain by complicating the
code?

> and pending that you give your ok:
> - fine grain locking for private tcp helper info

First I added your code to the patch then removed it, sorry: it's overkill
to add per entry locking. In the (near) future we'll have per bucket
locking and then we can rely on that instead of a global tcp_lock.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
