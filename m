From: Jonathan Cooper <netfilter@jonc.me.uk>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Thu, 11 Mar 2004 19:33:26 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040311193326.GA1567@finarfin.cooper.xfnet>
References: <20040311160401.GA1565@finarfin.cooper.xfnet> <Pine.LNX.4.33.0403111818110.16353-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0403111818110.16353-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

* Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> [2004-03-11 17:28]:
> Hi Jonathan,
> 
> So you use NAT. If you could test the system without using
> NAT at all (I mean no NAT related module loaded in), that could probably
> help to identify the problem.

Aha. If we have just the following ip* modules loaded: ipt_limit,
ipt_REJECT, ipt_LOG, ipt_state, ip_conntrack, iptable_filter, ip_tables
(and the nat table flushed) then I can access pages via the previously
masqueraded interface without problems.

> On Thu, 11 Mar 2004, Jonathan Cooper wrote:
> > Under the 2.4.23 and 2.4.24 kernels my machine would oops on reboot (just
> > after killing syslog) after the message had occurred. This has not (yet)
> > happened on 2.4.25. One common feature, that has occurred once under
> > 2.4.23 and once under 2.4.25 is that after several occurrences of this
> > message the computer froze solid, with no keyboard, mouse or network
> > response.
> >
> > I have experienced no problems of this nature with Debian's 2.4.22
> > kernel.
> 
> All the kernels are downloaded from ftp.kernel.org?

No, sorry. They're all Debian kernel sources. (I did mention that in an
earlier version of the email, but it got eaten when the system froze...)

> Did you compile all of them with gcc 3.3.3? Could you recompile the
> kernels with gcc 2.95?

I can't remember what version was used to compile 2.4.22. It would've
been whatever the standard gcc was in Debian testing on Dec 12th 2003. I
certainly used gcc 3.3.3 for kernel 2.4.25, and I suspect for .23 & .24
as well, although I'm not sure.

I've just tried the Debian kernel 2.4.25 sources compiled with gcc 2.95
and the kernel.org 2.4.25 sources compiled with gcc 3.3.3. The problem
occurs with both.

Jonathan.

-- 
Jonathan Cooper        MSN: msn@jonc.me.uk        jonc.me.uk/

If you can stay calm when all around you is chaos... then you probably haven't
 fully grasped the seriousness of the situation.
