From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 16:23:15 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206251618580.539-100000@blackhole.kfki.hu>
References: <20020625124744.GB7975@naboo.ols.wavesec.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>,
	<netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20020625124744.GB7975@naboo.ols.wavesec.org>
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

> > According to your first mail, the machine has 256M RAM and you issued
> >
> > insmod ip_conntrack 16384
> >
> > That requires 16384*8*~600byte ~= 75MB non-swappable RAM.
> >
> > When you issued "iptables -t nat -L", the system tried to reserve plus
> > 2x75MB. That's in total pretty near to all your available physical RAM
> > and the machine might died in swapping.
>
> ??? Why should listing an IP table try to reserve twice the size of the
> conntrack table?

By entering the command above, he loads in the iptable_nat kernel module,
which at initializing itself try to allocate memory for the bysource and
byipsproto hashes (with the same size as of ip_conntrack_hash).

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
