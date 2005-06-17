From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: GFP_KERNEL i checkentry
Date: Fri, 17 Jun 2005 20:29:18 +0200
Message-ID: <20050617182918.GA14065@aaricia.csbnet.se>
References: <20050617165026.GY12820@aaricia.csbnet.se>
	<876ef97a050617101245656fd6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
Content-Disposition: inline
In-Reply-To: <876ef97a050617101245656fd6@mail.gmail.com>
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

2005-06-17 13:12:38-0400, Tobias DiPasquale <codeslinger@gmail.com> ->
> On 6/17/05, Joakim Axelsson <gozem@gozem.se> wrote:
> > I have during my developing of some new modules be running into some
> > problem which I need help with. Since im running my routers on old
> > 2.4.23-kernel i have been developing for it. However i will most probably
> > convert to 2.6 soon.
> > 
> > Anyway, in "ipt_checkentry" that is executed everytime a new rule is added
> > which uses the module (or acutally whenever ANY rule is changed, added or
> > removed) it would seem that the kernel (atleast 2.4) considers this to be
> > inside an interupt-handler. I guess this is the softinterupt syscall that
> > get/setsockopt() refers to. However, i was using GFP_KERNEL to allocate
> > memory here. This seems to be wrong and needs to be GTP_ATOMIC. In _very_
> > rare occations this will trigger the BUG() on line 1130 in mm/slab.c (in
> > kernel 2.4.23) whenever the general fiting slabs needs to be grown.
> > 
> > Now to the problem. As far as i can see, vanilla 2.6.11.9 has this problem
> > in ipt_SAME. Possbile ipt_connlimit and ipt_recent. However i don't think
> > proc fs punctions need to be GFP_ATOMIC. Possbily this problem exists in other
> > modules in patch-o-magic. I havn't had a time to check it. However, among
> > those patches i use from an about 1 year old pom in my 2.4.23 routing kernel
> > there are several occations of this.
> > 
> > Again, this is a very very rare bug to trigger. I had to load ALOT of
> > instances using iptables-restore of my module before the bug was triggered.
> > 
> > Question is: Should it really be GFP_ATOMIC in all of the modules hook
> > functions?
> 
> No, this is definitely in process context. The bug you are
> experiencing is not due to being in interrupt context when you think
> you're in process: if that were the case, the bug would manifest
> itself a lot more often than you claim. This sounds to me like some
> kind of locking problem; I would check the locks used in my module and
> see if they conflict with the locks used elsewhere up the call stack.
> Failing that, look for a bug in the locking of the calling functions.
> 

The problems was solved changing from GFP_KERNEL to GFP_ATOMIC. I had
checking just around the kmalloc-call and i could easily reprocude the bug
by adding alot of rules using my module. All disapeared them i changed to
GFP_ATOMIC.

Actually i have 3 differnte kind of modules, all the same problem. Either
its a checking bug in kernel 2.4.23 or checkentry returns true for
in_interrupt() and shoudl therefore use GFP_ATOMIC.

My kernel is a UP-system (however the module has been running ona a
SMP-system as well, just not using the module in so many rules trigering the
bug). So there is no (classic SMP) locking at all.

I'll put up my code on http://www.gozem.se/~gozem/netfilter/
Its 4 modules:
1. A new limiter baed on a much better and more accurate algorithm, Can alos
limit on bytes/s. Also saves the state between reloads of rules (there fore
needing to allocate memory).
2. A -j SPEED that will show you the current flow hiting the target in /proc.
Saves the state between reloads of rules.
3. A -j ACCOUNT that will should you simple counter that hits the target.
Easy for mrtg and/or rrdtool to read of. Can reset/set the counter by
echoing into the /proc-entry. Saves the state.
4. A -m norm that is a normalizer for traffic-flow. Might need some more
triming. Will be needing a small code-cleanup before submissing.

All four modules but -m norm is more or less ready for submissing to POM. I
just need to port them to 2.6 and package them.

Specially both ipt_SPEED and ipt_ACCOUNT suffers from the same problem. 

ipt_ACCOUNT is fairly simply code, atleast the match, checkentry,
destory-part.

Userspace-code can be supplied if needed. Just working on checking atleast
the first 3 before submit now before packaging them.

I'll try reproduce this (if time allows) using the ipt_SAME which should
suffer from the same problem.

-- 
/Joakim Axelsson A.K.A Gozem@EFnet
