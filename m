From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Fri, 12 Mar 2004 08:16:00 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0403120802180.20054-100000@blackhole.kfki.hu>
References: <20040311193326.GA1567@finarfin.cooper.xfnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jonathan Cooper <netfilter@jonc.me.uk>
In-Reply-To: <20040311193326.GA1567@finarfin.cooper.xfnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 11 Mar 2004, Jonathan Cooper wrote:

> > So you use NAT. If you could test the system without using
> > NAT at all (I mean no NAT related module loaded in), that could probably
> > help to identify the problem.
>
> Aha. If we have just the following ip* modules loaded: ipt_limit,
> ipt_REJECT, ipt_LOG, ipt_state, ip_conntrack, iptable_filter, ip_tables
> (and the nat table flushed) then I can access pages via the previously
> masqueraded interface without problems.

So it looks like NAT related bug. Please do the following: both in
ip_conntrack_core.c and ip_nat_core.c enable debugging by changing

#if 0
#define DEBUGP printk
#else
#define DEBUGP(format, args...)
#endif

to

#if 1
#define DEBUGP printk
#else
#define DEBUGP(format, args...)
#endif

at the head of the files and add additional debugging to the
clean_from_lists function in ip_conntrack_core.c like this:

static void
clean_from_lists(struct ip_conntrack *ct)
{
        unsigned int ho, hr;

        DEBUGP("clean_from_lists(%p)\n", ct);

	/* The additional debug lines follow: */
	DEBUGP("original tuple: ");
	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
	DEBUGP("reply tuple:    ");
	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);

Recompile the kernel modules, start your system and try to trigger the
bug. Then please send me the kernel log messages or post the URL to
download from.

> > Did you compile all of them with gcc 3.3.3? Could you recompile the
> > kernels with gcc 2.95?
>
> I can't remember what version was used to compile 2.4.22. It would've
> been whatever the standard gcc was in Debian testing on Dec 12th 2003. I
> certainly used gcc 3.3.3 for kernel 2.4.25, and I suspect for .23 & .24
> as well, although I'm not sure.
>
> I've just tried the Debian kernel 2.4.25 sources compiled with gcc 2.95
> and the kernel.org 2.4.25 sources compiled with gcc 3.3.3. The problem
> occurs with both.

OK. That direction is then closed.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
