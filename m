From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2.6] Allow dynamic helper-port assignment
Date: Sun, 13 Feb 2005 23:38:40 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0502132315570.10608@blackhole.kfki.hu>
References: <20050213165638.GM20269@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050213165638.GM20269@sunbeam.de.gnumonks.org>
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

Hi Harald,

On Sun, 13 Feb 2005, Harald Welte wrote:

> The recent problem with h323 made me again consider the old idea of
> having runtime-configurable port assignments for helpers.
>
> Ideally, we would actually have conntrack helpers be iptables targets,
> this way allowing totally dynamic assignemnt.  Maybe yet another
> pkttables todo.
>
> Meanwhile, the following patch uses the same mechanism as CLUSTERIP:
>
> Add port 2121 to ftp helper:
> 	echo "+2121" > /proc/net/ip_conntrack_helper/ftp
>
> Remove port 6669 from irc helper:
> 	echo "-6669" > /proc/net/ip_conntrack_helper/irc

Let's imagine a real H.323 helper module, which works reliably (contrary
to the current one) and thus deployed at sites which use videoconferencing
heavily. Due to the nature of H.323, the dynamic H.245 helpers are truly
created dynamically for every single H.225 session, which starts the whole
H.323 protocol-tree . The currently nicely static helper list (which we
could thus protect even by RCU locking) would become dynamic and
could create *potentially* a new bottleneck.

Let's assume another protocol, which uses dynamic sub-helpers. How
could we handle the possible ports clashes of the different
sub-helpers in your scheme?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
