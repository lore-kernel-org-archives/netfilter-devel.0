From: Dmitry Mishin <dim@sw.ru>
Subject: Re: [Devel] Re: [PATCH 1/2] iptables 32bit compat layer
Date: Tue, 21 Feb 2006 12:04:49 +0300
Message-ID: <200602211204.50118.dim@sw.ru>
References: <200602201110.39092.dim@openvz.org> <200602201655.27093.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Arnd Bergmann <arnd@arndb.de>, Mishin Dmitry <dim@openvz.org>,
	akpm@osdl.org, netfilter-devel@lists.netfilter.org,
	rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161446AbWBUJE5@vger.kernel.org>
To: devel@openvz.org, dev@openvz.org
In-Reply-To: <200602201655.27093.arnd@arndb.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Monday 20 February 2006 18:55, Arnd Bergmann wrote:
> On Monday 20 February 2006 09:10, Mishin Dmitry wrote:
> > --- ./include/linux/netfilter/x_tables.h.iptcompat=A0=A0=A0=A0=A0=A0=
2006-02-15
> > 16:16:02.000000000 +0300 +++
> > ./include/linux/netfilter/x_tables.h=A0=A0=A0=A0=A0=A0=A0=A02006-02=
-15 18:53:09.000000000
> > +0300 struct xt_match
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct list_head list;
> > @@ -118,6 +125,10 @@ struct xt_match
> > =A0=A0=A0=A0=A0=A0=A0=A0/* Called when entry of this type deleted. =
*/
> > =A0=A0=A0=A0=A0=A0=A0=A0void (*destroy)(void *matchinfo, unsigned i=
nt matchinfosize);
> > =A0
> > +#ifdef CONFIG_COMPAT
> > +=A0=A0=A0=A0=A0=A0=A0/* Called when userspace align differs from k=
ernel space one */
> > +=A0=A0=A0=A0=A0=A0=A0int (*compat)(void *match, void **dstptr, int=
 *size, int
> > convert); +#endif
> > =A0=A0=A0=A0=A0=A0=A0=A0/* Set this to THIS_MODULE if you are a mod=
ule, otherwise NULL */
> > =A0=A0=A0=A0=A0=A0=A0=A0struct module *me;
> > =A0};
>
> Is CONFIG_COMPAT the right conditional here? If the code is only used
> for architectures that have different aligments, it should not need b=
e
> compiled in for the other architectures.
So, I'll define ARCH_HAS_FUNNY_64_ALIGNMENT in x86_64 and ia64 code and=
 will=20
check it, as Andi suggested.

>
> > @@ -154,6 +165,10 @@ struct xt_target
> > =A0=A0=A0=A0=A0=A0=A0=A0/* Called when entry of this type deleted. =
*/
> > =A0=A0=A0=A0=A0=A0=A0=A0void (*destroy)(void *targinfo, unsigned in=
t targinfosize);
> > =A0
> > +#ifdef CONFIG_COMPAT
> > +=A0=A0=A0=A0=A0=A0=A0/* Called when userspace align differs from k=
ernel space one */
> > +=A0=A0=A0=A0=A0=A0=A0int (*compat)(void *target, void **dstptr, in=
t *size, int
> > convert); +#endif
> > =A0=A0=A0=A0=A0=A0=A0=A0/* Set this to THIS_MODULE if you are a mod=
ule, otherwise NULL */
> > =A0=A0=A0=A0=A0=A0=A0=A0struct module *me;
> > =A0};
> > @@ -233,6 +248,34 @@ extern void xt_proto_fini(int af);
> > =A0extern struct xt_table_info *xt_alloc_table_info(unsigned int si=
ze);
> > =A0extern void xt_free_table_info(struct xt_table_info *info);
> > =A0
> > +#ifdef CONFIG_COMPAT
> > +#include <net/compat.h>
> > +
> > +/* FIXME: this works only on 32 bit tasks
> > + * need to change whole approach in order to calculate align as fu=
nction
> > of + * current task alignment */
> > +
> > +struct compat_xt_counters
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0u_int32_t cnt[4];
> > +};
>
> Hmm, maybe we should have something like
>
> typedef u64 __attribute__((aligned(4))) compat_u64;
>
> in order to get the right alignment on the architectures
> where it makes a difference. Do all compiler versions
> get that right?
good point. I don't know this and that's why tried to avoid use of 'ali=
gned'=20
attribute.

>
> > ---
> > ./include/linux/netfilter_ipv4/ip_tables.h.iptcompat=A0=A0=A0=A0=A0=
=A0=A0=A02006-02-15
> > 16:06:41.000000000 +0300 +++
> > ./include/linux/netfilter_ipv4/ip_tables.h=A0=A02006-02-15 16:37:12=
=2E000000000
> > +0300 @@ -364,5 +365,62 @@ extern unsigned int ipt_do_table(struct
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 void *userdata);
> > =A0
> > =A0#define IPT_ALIGN(s) XT_ALIGN(s)
> > +
> > +#ifdef CONFIG_COMPAT
> > +#include <net/compat.h>
> > +
> > +struct compat_ipt_getinfo
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0char name[IPT_TABLE_MAXNAMELEN];
> > +=A0=A0=A0=A0=A0=A0=A0compat_uint_t valid_hooks;
> > +=A0=A0=A0=A0=A0=A0=A0compat_uint_t hook_entry[NF_IP_NUMHOOKS];
> > +=A0=A0=A0=A0=A0=A0=A0compat_uint_t underflow[NF_IP_NUMHOOKS];
> > +=A0=A0=A0=A0=A0=A0=A0compat_uint_t num_entries;
> > +=A0=A0=A0=A0=A0=A0=A0compat_uint_t size;
> > +};
>
> This structure looks like it does not need any
> conversions. You should probably just use
> struct ipt_getinfo then.
I just saw compat_uint_t use in net/compat.c and thought, that it is a =
good=20
style to use it. Does anybody know arch, where sizeof(compat_uint_t) !=3D=
 4?

>
> > +
> > +struct compat_ipt_entry_match
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0union {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0u_int16_t match_size;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0char name[IPT_FUNCTION_MAXNAMELEN];
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} user;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0u_int16_t match_size;
> > +=A0=A0=A0=A0=A0=A0=A0} u;
> > +=A0=A0=A0=A0=A0=A0=A0unsigned char data[0];
> > +};
> > +
> > +struct compat_ipt_entry_target
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0union {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0u_int16_t target_size;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0char name[IPT_FUNCTION_MAXNAMELEN];
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} user;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0u_int16_t target_size=
;
> > +=A0=A0=A0=A0=A0=A0=A0} u;
> > +=A0=A0=A0=A0=A0=A0=A0unsigned char data[0];
> > +};
>
> Dito
Disagree, ipt_entry_match and ipt_entry_target contain pointers which m=
ake=20
their alignment equal 8 byte on 64bits architectures.

>
> > +#define COMPAT_IPT_ALIGN(s) =A0=A0=A0COMPAT_XT_ALIGN(s)
> > +
> > +extern int ipt_match_align_compat(void *match, void **dstptr,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int *size, int off, i=
nt convert);
> > +extern int ipt_target_align_compat(void *target, void **dstptr,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int *size, int off, i=
nt convert);
> > +
> > +#endif /* CONFIG_COMPAT */
> > =A0#endif /*__KERNEL__*/
> > =A0#endif /* _IPTABLES_H */
> > --- ./include/net/compat.h.iptcompat=A0=A0=A0=A02006-01-03 06:21:10=
=2E000000000
> > +0300 +++ ./include/net/compat.h=A0=A0=A0=A0=A0=A02006-02-15 18:45:=
49.000000000 +0300
> > @@ -23,6 +23,14 @@ struct compat_cmsghdr {
> > =A0=A0=A0=A0=A0=A0=A0=A0compat_int_t=A0=A0=A0=A0cmsg_type;
> > =A0};
> > =A0
> > +#if defined(CONFIG_X86_64)
> > +#define is_current_32bits() (current_thread_info()->flags & _TIF_I=
A32)
> > +#elif defined(CONFIG_IA64)
> > +#define is_current_32bits() (IS_IA32_PROCESS(ia64_task_regs(curren=
t)))
> > +#else
> > +#define is_current_32bits()=A0=A0=A0=A00
> > +#endif
> > +
>
> This definition looks very wrong to me. For x86_64, the right thing t=
o
> check should be TS_COMPAT, no _TIF_IA32, since you can also call the =
64 bit
> syscall entry point from a i386 task running on x86_64. For most othe=
r
> architectures, is_current_32bits returns something that is not reflec=
ted in
> the name. I would e.g. expect the function to return '1' on i386 and =
the
> correct task state on other compat platforms, instead of a bogus '0'.
>
> There have been long discussions about the inclusions of the
> 'is_compat_task' macro. Let's at least not define a second function t=
hat
> does almost the same but gets it wrong.
>
> I would much rather have either an extra 'compat' argument to to
> sock_setsockopt and proto_ops->setsockopt than to spread the use
> of is_compat_task further.
Another weak place in my code. is_compat_task() approach has one advant=
age -=20
it doesn't require a lot of current code modifications.
>
> > =A0#else /* defined(CONFIG_COMPAT) */
> > =A0#define compat_msghdr=A0=A0msghdr=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
* to avoid compiler warnings */
> > =A0#endif /* defined(CONFIG_COMPAT) */
> > --- ./net/compat.c.iptcompat=A0=A0=A0=A02006-01-03 06:21:10.0000000=
00 +0300
> > +++ ./net/compat.c=A0=A0=A0=A0=A0=A02006-02-15 16:38:45.000000000 +=
0300
> > @@ -308,107 +308,6 @@ void scm_detach_fds_compat(struct msghdr
> > =A0}
> > =A0
> > =A0/*
> > - * For now, we assume that the compatibility and native version
> > - * of struct ipt_entry are the same - sfr. =A0FIXME
> > - */
> > -struct compat_ipt_replace {
> > -=A0=A0=A0=A0=A0=A0=A0char=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0name[IPT_TABLE_MAXNAMELEN];
> > -=A0=A0=A0=A0=A0=A0=A0u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0valid_hooks;
> > -=A0=A0=A0=A0=A0=A0=A0u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0num_entries;
> > -=A0=A0=A0=A0=A0=A0=A0u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0size;
> > -=A0=A0=A0=A0=A0=A0=A0u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0hook_entry[NF_IP_NUMHOOKS];
> > -=A0=A0=A0=A0=A0=A0=A0u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0underflow[NF_IP_NUMHOOKS];
> > -=A0=A0=A0=A0=A0=A0=A0u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0num_counters;
> > -=A0=A0=A0=A0=A0=A0=A0compat_uptr_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
counters;=A0=A0=A0=A0=A0=A0=A0/* struct ipt_counters *
> > */ -=A0=A0=A0=A0=A0=A0=A0struct ipt_entry=A0=A0=A0=A0=A0=A0=A0=A0en=
tries[0];
> > -};
>
> Is the FIXME above the only reason that the code needs to be changed?
> What is the reason that you did not just address this in the
> compat_sys_setsockopt implementation?
Code above doesn't work. iptables with version >=3D 1.3 does alignment =
checks as=20
well as kernel does. So, we can't simply put entries with 8 bytes align=
ment=20
to userspace or with 4 bytes alignment to kernel - we need translate th=
em=20
entry by entry. So, I tried to do this the most correct way - that user=
space=20
will hide its alignment from kernel and vice versa, with not only=20
SET_REPLACE, but also GET_INFO, GET_ENTRIES and SET_COUNTERS translatio=
n.
=46irst implementation was exactly in compat_sys_setsockopt, but David =
asked me=20
to do this in netfilter code itself.

>
> 	Arnd <><
>
> _______________________________________________
> Devel mailing list
> Devel@openvz.org
> https://openvz.org/mailman/listinfo/devel

--=20
Thanks,
Dmitry.
