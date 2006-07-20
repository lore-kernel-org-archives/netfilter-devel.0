From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: [PATCH] priv_data 0/2
Date: Fri, 21 Jul 2006 00:38:46 +0200
Message-ID: <20060720223846.GV7194@kriss.csbnet.se>
References: <200606261641.47294.max@nucleus.it> <44A962DF.3080406@trash.net>
	<200607032305.06581.max@nucleus.it>
	<44A9A103.8090705@anduras.de> <44A9B458.1030106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44A9B458.1030106@trash.net>
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

2006-07-04 02:20:40+0200, Patrick McHardy <kaber@trash.net> ->
> Sven Anders wrote:
> > If this is merged, I would like to see a negated limit...
> > I need some advice to preserve compatibility here.
> 
> Once this is merged we can convert matches and targets to keep their
> private state outside of the structure shared with userspace and can
> start reusing the fields, since they are ignored by userspace anyway.
> I'm not sure, but I think currently userspace initializes them to 0,
> which should make this easy.
> 

I wonder where all this priv_data changes ended? I have a few modules (that
I havn't submited, because i've been way to lazy :-/) that will benefit from
this. Among those a new limiter matcher simply called "lim". This match will
solve Sven Anders problem with negating match. It's also much more aqurate
and using a better limiter algoritm. Including being able to limit on packet
size etc etc. It has been working stable in large scale routers (several
100Mbit/s) for a year now I think.

So where did this end up. The reason I am asking is because I was working on
sending them in as patches. But they could really use this priv_data as they
are using alot of ugly things to work this problem around. Same goes for a
few target matches I have. They also need priv_data. Among them a "simple"
-j COUNT that presents counters in /proc in an easy and fancy way (for
scripts/rrdtool to read). I know hfpac wants this things they have droped
the counters built in for each rule.
