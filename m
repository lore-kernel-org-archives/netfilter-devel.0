From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] tcp-window-tracking patch
Date: Tue, 9 Dec 2003 14:21:44 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0312091410570.5228-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.44.0312091404540.25001-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0312091404540.25001-100000@filer.marasystems.com>
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
> > - close_wait timeout value is lowered to the more proper 10 minutes
>
> Is this a "silence" timeout extended if there is traffic, or a session
> timeout after enterig close_wait no matter if there is traffic or not?

Yes, it's extended whenever there is traffic. If there is nothing, then
the timer goes down and deletes the corresponding conntrack entry.

> If the first then 10 minutes should be sufficient for most uses, even if
> there quite likely is some applications which will fail this..

Yes, that's true. The original value was 60 secs. That was increased to 3
days in the window tracking code, which was surely excessive: there might
be no resent traffic to detect and thus long dead connections could stay
in the hash table. Hard to choose the proper value, which does not break
either way.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
