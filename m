From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Checksum problem in tcp-window-tracking
Date: Mon, 14 Jun 2004 10:43:38 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0406141036530.759@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0406141018360.12847-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0406141018360.12847-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 14 Jun 2004, Jozsef Kadlecsik wrote:

> Hi Martin,

Hi Jozsef

> > Jun 12 21:14:30 tux ip_conntrack_tcp: INVALID: bad T IN= OUT= MAC=
> > SRC=127.0.0.1 DST=127.0.0.1 LEN=93 TOS=00 PREC=0x00 TTL=64 ID=6306 DF
> > PROTO=TCP SPT=6667 DPT=32813 SEQ=2226635880 ACK=2237541190 WINDOW=4095
> > ACK PSH URGP=0
> >
> > "bad T" can only be this code from unclean()
>
> Why did the prefix get truncated to 'ip_conntrack_tcp: INVALID: bad T'???
> Anything special with your kernel?

No nothing special, using ULOG for logging.
I thought it was weird as well but I didn't trace the problem. Maybe I'll
look at it later today.

/Martin
