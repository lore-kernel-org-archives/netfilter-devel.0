From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Checksum problem in tcp-window-tracking
Date: Mon, 14 Jun 2004 10:23:52 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406141018360.12847-100000@blackhole.kfki.hu>
References: <1087068742.1019.53.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1087068742.1019.53.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Martin,

On Sat, 12 Jun 2004, Martin Josefsson wrote:

> I only get the complaints on localhost<->localhost traffic, all other
> traffic is complaint-free and working great :)
>
> Jun 12 21:14:30 tux ip_conntrack_tcp: INVALID: bad T IN= OUT= MAC=
> SRC=127.0.0.1 DST=127.0.0.1 LEN=93 TOS=00 PREC=0x00 TTL=64 ID=6306 DF
> PROTO=TCP SPT=6667 DPT=32813 SEQ=2226635880 ACK=2237541190 WINDOW=4095
> ACK PSH URGP=0
>
> "bad T" can only be this code from unclean()

Why did the prefix get truncated to 'ip_conntrack_tcp: INVALID: bad T'???
Anything special with your kernel?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
