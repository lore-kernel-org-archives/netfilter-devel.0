From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: About IP unused bit WAS:Why was not there any response to my patch?
Date: Mon, 3 Jun 2002 15:17:15 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.21.0206031457070.1065-100000@dns.toxicfilms.tv>
References: <Pine.LNX.4.33.0205300846380.7361-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0205300846380.7361-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> However there are so many sanity checkings in unclean that it's not so
> easy to design an intuitive and handy interface.
i will look into it, i have seen tons of checks, maybe it is possible to
divise a strategy.

> > 1. match ip unused and log or drop
> > 2. match some scans using --tcp-flags and reject with tcp-reset
> > 3. match tcp scans using psd and reject with tcp-reset
> > 4. match udp scans using psd and reject with icmp
> > 5. match using unclean for anything else: bad chksum, bad frag offset,
> >    etc
> 
> If you simply drop at 5. then it could be replaced with the new unclean
> match used at 1.
No, unclean will match what's in 2. XMAS, NULL, etc.

But i will add this to unclean and send a patch soon.

Maciek
