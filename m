From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: performance issues (nat / conntrack)
Date: Tue, 25 Jun 2002 16:53:33 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206251636130.539-100000@blackhole.kfki.hu>
References: <021a01c21c4b$47b2f2b0$0489cb8a@etbx180>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@gnumonks.org>,
	<netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jean-Michel Hemstedt <jean-michel.hemstedt@alcatel.be>
In-Reply-To: <021a01c21c4b$47b2f2b0$0489cb8a@etbx180>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 25 Jun 2002, Jean-Michel Hemstedt wrote:

> > From where do you think that the module usage counter reports how many
> > packets/connections are handled (currently? totally?) by the module.
> > There is no whatsoever connection!
>
> module usage counter increases when a TARGET needs it (i.e. ipt_REDIRECT).

Yes, this is true for netfilter target/match modules. But even in that
case, the number refers how many rules use the module and not how many
packets were processed.

> In this test, no rule was defined, and no target module was loaded.

There are always an implicit rule in the case of NAT. Being an implicit
rule, it is not counted in the module usage counter. :-)

> So I did not expect NAT to process any packet.

No, NAT always processes all packets, the same way as conntrack does.

> I suppose that due to the load, packets are dropped not because of conntrack
> but because they simply can't be processed, and thus conntrack misses packets
> of existing connections (such as FIN, RST) and can't thus recover due to its
> timeouts.

If conntrack missed packets such a way, then the destination would miss as
well and the sender should resend them. No problem.

> > When you issued "iptables -t nat -L", the system tried to reserve plus
> > 2x75MB. That's in total pretty near to all your available physical RAM
> > and the machine might died in swapping.
>
> exact!
> That's why I looked (but not closely) at swap-in/swap-out in procinfo,
> but didn't notice anything (0 most of the time on 10 sec average).
> But I agree that I was close to the limit, and even over when I tried 32K.
> Despite that, nothing so surpising to have so few swaps, since my table
> was not full (max 4000 up to 10000 concurrent tuples).

But the whole space gets reserved! Immediately as the module loaded!
An it is non-swappable RAM, everything else would get the rest.

> PS: could anybody redo similar tests so that we can compare the results
>     and stop killing the messenger, please? ;o)

Sorry if I look harsh, it's not my intention at all. We were simply over
almost exaclty the same arguments several times. And those resulted
neither pinpointing real flaws in the system, nor better algorithms.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
