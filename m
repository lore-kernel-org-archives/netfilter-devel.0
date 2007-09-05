From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Makefile for man pages of xtables extensions
Date: Wed, 05 Sep 2007 15:45:16 +0200
Message-ID: <46DEB2EC.6080107@trash.net>
References: <46DC0293.6010307@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: panther@balabit.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46DC0293.6010307@balabit.hu>
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

Laszlo Attila Toth wrote:
> Hello,
> 
> I made this patch to include all available matches and targets to
> iptables.8 and ip6tables.8 man pages. The source file is lixt_*.c but
> the man page is libipt_*.man or libip6t.man as expected.


Thanks for taking care of this. Mid term we should probably also
move to a single source file for the xtables manpages, they *should*
be identical anyways.

> But I found that in the generated man pages of the svn version of
> modules the title is
>   ... (not supported, see Patch-O-Matic)
> for instance helper, length, limit etc. Is it intended?


No, matches and targets available in the kernel should not be
marked as not supported. Care to send another patch to fix this?

> --- iptables.orig/extensions/Makefile	2007-08-07 10:03:05.000000000 +0200
> +++ iptables/extensions/Makefile	2007-09-03 14:28:44.000000000 +0200
> @@ -29,6 +29,11 @@
>  PF6_EXT_MAN_ALL_MATCHES:=$(foreach T,$(PF6_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q register_match6 extensions/libip6t_$(T).c  && echo $(T)))
>  PF6_EXT_MAN_ALL_TARGETS:=$(foreach T,$(PF6_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q register_target6 extensions/libip6t_$(T).c && echo $(T)))
>  
> +PF_EXT_MAN_ALL_MATCHES+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q register_match extensions/libxt_$(T).c  && echo $(T)))
> +PF_EXT_MAN_ALL_TARGETS+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q register_target extensions/libxt_$(T).c && echo $(T)))
> +PF6_EXT_MAN_ALL_MATCHES+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q register_match6 extensions/libxt_$(T).c  && echo $(T)))
> +PF6_EXT_MAN_ALL_TARGETS+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q register_target6 extensions/libxt_$(T).c && echo $(T)))


This doesn't work for IPv6 extensions. We use xtables_register_match
for both IPv4 and IPv6. I've changed this in your patch and applied it.
Thanks again.
