From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Checksum problem in tcp-window-tracking
Date: Tue, 15 Jun 2004 15:14:12 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406151510320.15738-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.33.0406132208380.11536-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.33.0406132208380.11536-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 13 Jun 2004, Jozsef Kadlecsik wrote:

> On Sun, 13 Jun 2004, Patrick McHardy wrote:
>
> > > I only get the complaints on localhost<->localhost traffic, all other
> > > traffic is complaint-free and working great :)
> > >
> > > Jun 12 21:14:30 tux ip_conntrack_tcp: INVALID: bad T IN= OUT= MAC=
> > > SRC=127.0.0.1 DST=127.0.0.1 LEN=93 TOS=00 PREC=0x00 TTL=64 ID=6306 DF
> > > PROTO=TCP SPT=6667 DPT=32813 SEQ=2226635880 ACK=2237541190 WINDOW=4095
> > > ACK PSH URGP=0
> Thank you both the report and the explanation. I'm going to fix it
> by checking the hook in order not to loose the fast path in the
> hardware-checksummed case.

I committed the fixed version of the patch in cvs. Besides the fix the
talkative log messages were trimmed in order to fit (better) into the
ULOG buffer.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
