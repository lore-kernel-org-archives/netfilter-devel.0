From: Herve Eychenne <rv@wallfire.org>
Subject: Re: RAM and conntrack performance: first draft of the document is online
Date: Thu, 27 Nov 2003 04:33:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031127033351.GC1084@eychenne.org>
References: <20031028151032.GD726@eychenne.org> <20031103081240.GQ1536@sunbeam.de.gnumonks.org> <20031125153543.GD1082@eychenne.org> <20031125205723.GE2971@obroa-skai.de.gnumonks.org> <20031126034231.GA1044@eychenne.org> <20031126113645.GF3121@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20031126113645.GF3121@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Nov 26, 2003 at 12:36:45PM +0100, Harald Welte wrote:

> On Wed, Nov 26, 2003 at 04:42:32AM +0100, Herve Eychenne wrote:

> > Yes, but that is really negligible (2 * size_of_pointer * HASHSIZE).

> well, sizof(void *) is 4 bytes on most archs... two times is 8.  so if
> you have let's say 100k buckets, that's 800k non-swappable kernel
> memory...

Which is really not that much when you have 512 MB... (0.0015 %)

> > > maybe you're running a different kernel?

> > Debian standard kernel.  Maybe they are patching netfilter?  These are smart
> > guys! ;-)

> IIRC debian has still 2.4.18 which had a different hashing algorithm

Standard Debian stable, maybe. But you may want to run testing, or
sid, and I run testing (sarge), so I have a 2.4.22.

> > > no, there are none deleted.  we just skip creating new ones until the
> > > number has dropped below the limit.  There is no special case for that,
> > > we just chek >= conntrack_max at conntrack allocation time.

> > Don't you think it would be good to shrink the lists immediately?
> > Waiting til the number has dropped below the limit can take days...

> well, it might be a good idea.  but I somehow doubt this is a valid
> scenario.  And if we would shrink the list:  how do we select which
> entries to evict?

That seems relatively simple to me:
- reduce timeouts on every entries proportionally
- sort the entries by order of importance (state, timeout (time to
  live), protocol (icmp ping/pong, udp, tcp), maybe unprivileged ports
  matter less, etc.). Then evict "bad scores" first.

> I'd rather wait for ctnetlink to appear in mainstream
> kernels and then leave that to a userspace process.

Maybe such a job (probably happening while network is stressed) is
better done in kernel space? That doesn't seem so complicated...

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
