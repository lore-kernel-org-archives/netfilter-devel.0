From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] combine iptables, iptables-save and iptables-restore
 for size reduction
Date: Fri, 25 Jun 2004 13:30:05 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406251329340.11001-100000@blackhole.kfki.hu>
References: <1087852753.2962.27.camel@x1722074250.edup.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bastiaan Bakker <bastiaan.bakker@lifeline.nl>
In-Reply-To: <1087852753.2962.27.camel@x1722074250.edup.local>
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

On Mon, 21 Jun 2004, Bastiaan Bakker wrote:

> The iptables, iptables-save and iptables-restore binaries contain a
> relatively large amount of identical code. In most cases this doesn't
> matter, but on embedded platforms 100KB can make a difference.
> Attached is a small patch against iptables 1.2.10 which enables building
> iptables, iptables-save and iptables-restore into 1 multi-purpose
> binary. In BusyBoxy style it selects the correct command based on
> argv[0].
>
> To build, do 'make DO_MULTI=1' instead of 'make'.

The patch is applied in cvs.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
