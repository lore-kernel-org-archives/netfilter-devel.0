From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: H.323 Contrack w/ 2.6?
Date: Tue, 3 Feb 2004 10:02:07 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0402030958400.11027-100000@blackhole.kfki.hu>
References: <1075790189.12953.30.camel@goliath.dscn.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Robert Day <zarin@dscn.net>
In-Reply-To: <1075790189.12953.30.camel@goliath.dscn.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 3 Feb 2004, Robert Day wrote:

> I know PoM -ng is going to address this issue, but till it is ready, and
> all the extras are ported to it, is there any way to use the h.323
> contrack module kernel patch with a 2.6 kernel?
> Running 2.6.1 - no 2.4 kernel stuff on the system, so downgrade is not
> an option...

The module is not ported yet to 2.6, sorry.

> Do I have any options besides a gatekeeper app (does not work in my
> network) or a proxy (would prefer to avoid them)?

I suggest everyone to setup a proxy (gatekeeper) instead: the module is
really dumb and does not deserve to exist at all. It was an excellent tool
to debug/develop the newnat interface.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
