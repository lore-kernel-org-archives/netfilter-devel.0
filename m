From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Feasability of Protocol Filtering
Date: Thu, 24 Apr 2003 14:16:59 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304241415530.23473-100000@blackhole.kfki.hu>
References: <1051137456.28404.34.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eicke Friedrich <tady@gmx.net>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1051137456.28404.34.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 24 Apr 2003, Martin Josefsson wrote:

> I benchmarked the stringmatch a bit a while ago.
> On my pIII it uses ~50k cycles / kB.
>
> If using the Boyer-Moore algorithm instead you get it down to ~3k cycles
> / kB when searching for a 5 byte string (cpu usage decreases with string
> length)
>
> The Boyer-Moore patch was sent to this list quite some time ago. I
> should update it so it applies.

Would you do so? Let's try to collect the missed bits :-(

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
