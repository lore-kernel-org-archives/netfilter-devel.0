From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: raw.patch needs defrag at LOCAL_OUT
Date: Sat, 1 Nov 2003 23:20:44 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0311012315530.11097-100000@blackhole.kfki.hu>
References: <20031101183812.GL15184@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031101183812.GL15184@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 1 Nov 2003, Harald Welte wrote:

> I'm not sure if this bug was already discovered in the recent
> discussion, but the raw.patch moves ip_ct_gather_frags() to a seperate
> netfilter hook entry.
>
> However, that hook entry is only called from PRE_ROUTING and not from
> LOCAL_OUT, resulting in ip_conntrack_in() seeing fragmented packets e.g.
> in case of NFS.

Ouch! It seems I'm completely dense nowadays. :-(((

> I'll prepare a fix (need it working for my own NFS server).

Thank you,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
