From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 16:33:50 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206251628480.539-100000@blackhole.kfki.hu>
References: <20020625135113.GE7975@naboo.ols.wavesec.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>,
	<netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20020625135113.GE7975@naboo.ols.wavesec.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 25 Jun 2002, Harald Welte wrote:

> > But this raises one additional problem:
> > 1) the hash index size and the hash total size should be configurable
> > separately (get rid of that factor 8, and use a free list for the tuple
> > allocation).
> > 2) NAT hash sizes should also be configurable independently from conntrack.
> > Normally the nat hashes are smaller than conntrack hash, since conntrack
> > is based on ports, while nat is not.
>
> both of this is already true. look at the module loadtime parameters of
> ip_conntrack.o and iptable_nat.o

One must set hashsize for the ip_conntrack module and then tweak of
/proc/sys/net/ip_conntrack_max in order to get rid of the factor 8.

But we do not have a module parameter yet for setting the hashsizes
of iptable_nat independently.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
