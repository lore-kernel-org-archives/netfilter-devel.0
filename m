From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: timeout storms make the box unresponsive
Date: Sun, 27 Jul 2003 00:39:22 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0307270027460.7327-100000@blackhole.kfki.hu>
References: <20030725202113.GK10897@naboo>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Balazs Scheidler <bazsi@balabit.hu>,
	<netfilter-devel@lists.netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030725202113.GK10897@naboo>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 25 Jul 2003, Harald Welte wrote:

> On Fri, Jul 25, 2003 at 08:56:44PM +0200, Balazs Scheidler wrote:
>
> > Maybe we should consider removing expired entries from the NAT hash at a
> > single go, instead of the current lock-remove-unlock for each entry. Or
> > create a cleanup thread which cleans up conntrack entries regularly, but not
> > in the timer interrupt context.
>
> Rusty, Jamal and I were talking about this conntrack cleanup yesterday
> (we're currently all at OLS).  The conclusion was that a cleanup kernel thread
> is what we want to have.
[...]
> If I understood correctly, Rusty already has some old patches in this
> area, and he is most likely to put an update of these patches out in the
> next weeks before the netfilter developer workshop.

Maybe the reworked per bucket locking patch is a good start for a
cleanup kernel thread. I have uploaded all my pending patches to
http://www.kfki.hu/~kadlec/sw/netfilter/2.5/:

01_logging.patch	2.4 logging patch ported to 2.5
02_proc.patch		ditto
03_locking.patch	per bucket locking patch with a couple of
			optimizations
04_tcp_window.patch	TCP window tracking patch port
05_dos.patch		protection against a conntrack attack
			by an advisory hotlist

[Harald, the user home pages on kashyyyk are unavailable from outside.]

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
