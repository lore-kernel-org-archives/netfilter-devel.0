From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] iptables-proc and admin-prohib patches
Date: Mon, 5 May 2003 10:32:19 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305051018360.607-100000@blackhole.kfki.hu>
References: <20030430163304.GI685@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Maciej Soltysiak <solt@dns.toxicfilms.tv>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030430163304.GI685@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

On Wed, 30 Apr 2003, Harald Welte wrote:

> > while the major modification is that I added versioning support to
> > tables/matches/targets.
>
> To be honest, I wouldn't call this 'versioning support'.  It just adds a
> version number field to the structures that is printed in '/proc/'.
>
> The kind of versioning support we could really need (but which cannot be
> added to the 2.4.x architecture without being totally incompatible) is
> to have version information in every rule that is loaded from userspace.
> The kernel would then reject rules for target versions > than the loaded
> target module. Userspace would then need to read the version number and
> prepare a structure for an older version.

Yes, you are correct. That'd mean real versioning.

> So without any further convincing arguments, I would rather not want to
> include your patch.  It would require patching all existing
> targets/matches (to include the version number), and that's a too high
> price for the little/limited use.

There is no need to patch all existing extensions. I admit it's not
elegant, but because the version parameter is the last in the module
structures, all unpatched module gets automatically the zero version
number. (And in order to introduce C99 initialization, we have to patch
all extensions anyway and then the version numbers can explicitly be
added.)

What disturbs me is that the users cannot check (at least in such a
primitive way) what is actually supported by the running kernel in the
case of such incompatibilities.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
