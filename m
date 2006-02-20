From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] iptables 32bit compat layer
Date: Mon, 20 Feb 2006 16:55:26 +0100
Message-ID: <200602201655.27093.arnd@arndb.de>
References: <200602201110.39092.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	rusty@rustcorp.com.au, akpm@osdl.org, devel@openvz.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030301AbWBTQOF@vger.kernel.org>
To: Mishin Dmitry <dim@openvz.org>
In-Reply-To: <200602201110.39092.dim@openvz.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Monday 20 February 2006 09:10, Mishin Dmitry wrote:
> --- ./include/linux/netfilter/x_tables.h.iptcompat=A0=A0=A0=A0=A0=A02=
006-02-15 16:16:02.000000000 +0300
> +++ ./include/linux/netfilter/x_tables.h=A0=A0=A0=A0=A0=A0=A0=A02006-=
02-15 18:53:09.000000000 +0300
> =A0struct xt_match
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct list_head list;
> @@ -118,6 +125,10 @@ struct xt_match
> =A0=A0=A0=A0=A0=A0=A0=A0/* Called when entry of this type deleted. */
> =A0=A0=A0=A0=A0=A0=A0=A0void (*destroy)(void *matchinfo, unsigned int=
 matchinfosize);
> =A0
> +#ifdef CONFIG_COMPAT
> +=A0=A0=A0=A0=A0=A0=A0/* Called when userspace align differs from ker=
nel space one */
> +=A0=A0=A0=A0=A0=A0=A0int (*compat)(void *match, void **dstptr, int *=
size, int convert);
> +#endif
> =A0=A0=A0=A0=A0=A0=A0=A0/* Set this to THIS_MODULE if you are a modul=
e, otherwise NULL */
> =A0=A0=A0=A0=A0=A0=A0=A0struct module *me;
> =A0};

Is CONFIG_COMPAT the right conditional here? If the code is only used
for architectures that have different aligments, it should not need be
compiled in for the other architectures.

> @@ -154,6 +165,10 @@ struct xt_target
> =A0=A0=A0=A0=A0=A0=A0=A0/* Called when entry of this type deleted. */
> =A0=A0=A0=A0=A0=A0=A0=A0void (*destroy)(void *targinfo, unsigned int =
targinfosize);
> =A0
> +#ifdef CONFIG_COMPAT
> +=A0=A0=A0=A0=A0=A0=A0/* Called when userspace align differs from ker=
nel space one */
> +=A0=A0=A0=A0=A0=A0=A0int (*compat)(void *target, void **dstptr, int =
*size, int convert);
> +#endif
> =A0=A0=A0=A0=A0=A0=A0=A0/* Set this to THIS_MODULE if you are a modul=
e, otherwise NULL */
> =A0=A0=A0=A0=A0=A0=A0=A0struct module *me;
> =A0};
> @@ -233,6 +248,34 @@ extern void xt_proto_fini(int af);
> =A0extern struct xt_table_info *xt_alloc_table_info(unsigned int size=
);
> =A0extern void xt_free_table_info(struct xt_table_info *info);
> =A0
> +#ifdef CONFIG_COMPAT
> +#include <net/compat.h>
> +
> +/* FIXME: this works only on 32 bit tasks
> + * need to change whole approach in order to calculate align as func=
tion of
> + * current task alignment */
> +
> +struct compat_xt_counters
> +{
> +=A0=A0=A0=A0=A0=A0=A0u_int32_t cnt[4];
> +};

Hmm, maybe we should have something like

typedef u64 __attribute__((aligned(4))) compat_u64;

in order to get the right alignment on the architectures
where it makes a difference. Do all compiler versions
get that right?

> --- ./include/linux/netfilter_ipv4/ip_tables.h.iptcompat=A0=A0=A0=A0=A0=
=A0=A0=A02006-02-15 16:06:41.000000000 +0300
> +++ ./include/linux/netfilter_ipv4/ip_tables.h=A0=A02006-02-15 16:37:=
12.000000000 +0300
> @@ -364,5 +365,62 @@ extern unsigned int ipt_do_table(struct=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 void *userdata);
> =A0
> =A0#define IPT_ALIGN(s) XT_ALIGN(s)
> +
> +#ifdef CONFIG_COMPAT
> +#include <net/compat.h>
> +
> +struct compat_ipt_getinfo
> +{
> +=A0=A0=A0=A0=A0=A0=A0char name[IPT_TABLE_MAXNAMELEN];
> +=A0=A0=A0=A0=A0=A0=A0compat_uint_t valid_hooks;
> +=A0=A0=A0=A0=A0=A0=A0compat_uint_t hook_entry[NF_IP_NUMHOOKS];
> +=A0=A0=A0=A0=A0=A0=A0compat_uint_t underflow[NF_IP_NUMHOOKS];
> +=A0=A0=A0=A0=A0=A0=A0compat_uint_t num_entries;
> +=A0=A0=A0=A0=A0=A0=A0compat_uint_t size;
> +};

This structure looks like it does not need any
conversions. You should probably just use=20
struct ipt_getinfo then.

> +
> +struct compat_ipt_entry_match
> +{
> +=A0=A0=A0=A0=A0=A0=A0union {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
u_int16_t match_size;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
char name[IPT_FUNCTION_MAXNAMELEN];
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} user;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0u_int16_t match_size;
> +=A0=A0=A0=A0=A0=A0=A0} u;
> +=A0=A0=A0=A0=A0=A0=A0unsigned char data[0];
> +};
> +
> +struct compat_ipt_entry_target
> +{
> +=A0=A0=A0=A0=A0=A0=A0union {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
u_int16_t target_size;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
char name[IPT_FUNCTION_MAXNAMELEN];
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} user;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0u_int16_t target_size;
> +=A0=A0=A0=A0=A0=A0=A0} u;
> +=A0=A0=A0=A0=A0=A0=A0unsigned char data[0];
> +};

Dito

> +#define COMPAT_IPT_ALIGN(s) =A0=A0=A0COMPAT_XT_ALIGN(s)
> +
> +extern int ipt_match_align_compat(void *match, void **dstptr,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int *size, int off, int=
 convert);
> +extern int ipt_target_align_compat(void *target, void **dstptr,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int *size, int off, int=
 convert);
> +
> +#endif /* CONFIG_COMPAT */
> =A0#endif /*__KERNEL__*/
> =A0#endif /* _IPTABLES_H */
> --- ./include/net/compat.h.iptcompat=A0=A0=A0=A02006-01-03 06:21:10.0=
00000000 +0300
> +++ ./include/net/compat.h=A0=A0=A0=A0=A0=A02006-02-15 18:45:49.00000=
0000 +0300
> @@ -23,6 +23,14 @@ struct compat_cmsghdr {
> =A0=A0=A0=A0=A0=A0=A0=A0compat_int_t=A0=A0=A0=A0cmsg_type;
> =A0};
> =A0
> +#if defined(CONFIG_X86_64)
> +#define is_current_32bits() (current_thread_info()->flags & _TIF_IA3=
2)
> +#elif defined(CONFIG_IA64)
> +#define is_current_32bits() (IS_IA32_PROCESS(ia64_task_regs(current)=
))
> +#else
> +#define is_current_32bits()=A0=A0=A0=A00
> +#endif
> +

This definition looks very wrong to me. For x86_64, the right thing to =
check
should be TS_COMPAT, no _TIF_IA32, since you can also call the 64 bit
syscall entry point from a i386 task running on x86_64. For most other
architectures, is_current_32bits returns something that is not reflecte=
d
in the name. I would e.g. expect the function to return '1' on i386 and
the correct task state on other compat platforms, instead of a bogus '0=
'.

There have been long discussions about the inclusions of the 'is_compat=
_task'
macro. Let's at least not define a second function that does almost the
same but gets it wrong.

I would much rather have either an extra 'compat' argument to to
sock_setsockopt and proto_ops->setsockopt than to spread the use
of is_compat_task further.

> =A0#else /* defined(CONFIG_COMPAT) */
> =A0#define compat_msghdr=A0=A0msghdr=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* =
to avoid compiler warnings */
> =A0#endif /* defined(CONFIG_COMPAT) */
> --- ./net/compat.c.iptcompat=A0=A0=A0=A02006-01-03 06:21:10.000000000=
 +0300
> +++ ./net/compat.c=A0=A0=A0=A0=A0=A02006-02-15 16:38:45.000000000 +03=
00
> @@ -308,107 +308,6 @@ void scm_detach_fds_compat(struct msghdr
> =A0}
> =A0
> =A0/*
> - * For now, we assume that the compatibility and native version
> - * of struct ipt_entry are the same - sfr. =A0FIXME
> - */
> -struct compat_ipt_replace {
> -=A0=A0=A0=A0=A0=A0=A0char=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0name[IPT_TABLE_MAXNAMELEN];
> -=A0=A0=A0=A0=A0=A0=A0u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0valid_hooks;
> -=A0=A0=A0=A0=A0=A0=A0u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0num_entries;
> -=A0=A0=A0=A0=A0=A0=A0u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0size;
> -=A0=A0=A0=A0=A0=A0=A0u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0hook_entry[NF_IP_NUMHOOKS];
> -=A0=A0=A0=A0=A0=A0=A0u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0underflow[NF_IP_NUMHOOKS];
> -=A0=A0=A0=A0=A0=A0=A0u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0num_counters;
> -=A0=A0=A0=A0=A0=A0=A0compat_uptr_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ounters;=A0=A0=A0=A0=A0=A0=A0/* struct ipt_counters * */
> -=A0=A0=A0=A0=A0=A0=A0struct ipt_entry=A0=A0=A0=A0=A0=A0=A0=A0entries=
[0];
> -};

Is the FIXME above the only reason that the code needs to be changed?
What is the reason that you did not just address this in the=20
compat_sys_setsockopt implementation?

	Arnd <><
