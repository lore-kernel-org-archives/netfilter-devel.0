From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: --reject-with admin-prohib - Suggested Solution.
Date: Wed, 4 Dec 2002 01:02:23 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0212040052300.29619-100000@blackhole.kfki.hu>
References: <20021128081009.GJ7047@naboo.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Maciej Soltysiak <solt@dns.toxicfilms.tv>,
	<g@naboo.gnumonks.org>, <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021128081009.GJ7047@naboo.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 28 Nov 2002, Harald Welte wrote:

> > Now, if the 2.5.48 kernel has the admin-prohib support, the userspace will
> > detect it, and will show the option in -j REJECT --help and will accept
> > admin-prohib.
>
> No.  You will make the libipt_REJECT.so dependent on the particular
> source code installed on the machine where iptables was compiled.

Why don't we simply add an INCOMPATIBILITIES file to the userspace source
tree, together with a similar section in the manpage?

Backward compatibility is very important, but we shouldn't insist on it at
every cost.

Maciej's patch is simple, I'd even leave out the checking of the kernel
version as the manpage would describe the conditions.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
