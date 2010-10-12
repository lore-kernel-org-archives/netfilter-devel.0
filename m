From: Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH 5/5] secmark: export secctx, drop secmark in procfs
Date: Tue, 12 Oct 2010 19:19:56 -0400
Message-ID: <1286925596.5133.102.camel@sifl>
References: <20101012154008.26943.44399.stgit@paris.rdu.redhat.com>
	 <20101012154035.26943.35175.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, jmorris@namei.org,
	selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jengelh@medozas.de,
	linux-security-module@vger.kernel.org, mr.dash.four@googlemail.com,
	pablo@netfilter.org
To: Eric Paris <eparis@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:12683 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab0JLXUE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Oct 2010 19:20:04 -0400
In-Reply-To: <20101012154035.26943.35175.stgit@paris.rdu.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2010-10-12 at 11:40 -0400, Eric Paris wrote:
> The current secmark code exports a secmark= field which just indicates if
> there is special labeling on a packet or not.  We drop this field as it
> isn't particularly useful and instead export a new field secctx= which is
> the actual human readable text label.

Looks reasonable to me, just some small nits/questions below ...

> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
> 
>  .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   27 ++++++++++++++++++--
>  net/netfilter/nf_conntrack_standalone.c            |   27 ++++++++++++++++++--
>  2 files changed, 48 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
> index 244f7cb..2ca510e 100644
> --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
> +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
> @@ -11,6 +11,7 @@
>  #include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
>  #include <linux/percpu.h>
> +#include <linux/security.h>
>  #include <net/net_namespace.h>
>  
>  #include <linux/netfilter.h>
> @@ -87,6 +88,28 @@ static void ct_seq_stop(struct seq_file *s, void *v)
>  	rcu_read_unlock();
>  }
>  
> +#ifdef CONFIG_NF_CONNTRACK_SECMARK
> +static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
> +{
> +	int len, ret;
> +	char *secctx;
> +
> +	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);

Here you define len as an int but the prototype calls for a u32 - is
this going to cause any compiler warnings?

> +	if (ret)
> +		return ret;
> +
> +	ret = seq_printf(s, "secctx=%s ", secctx);
> +
> +	security_release_secctx(secctx, len);
> +	return ret;
> +}
> +#else
> +static inline int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
> +{
> +	return 0;
> +}
> +#endif
> +
>  static int ct_seq_show(struct seq_file *s, void *v)
>  {
>  	struct nf_conntrack_tuple_hash *hash = v;
> @@ -148,10 +171,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
>  		goto release;
>  #endif
>  
> -#ifdef CONFIG_NF_CONNTRACK_SECMARK
> -	if (seq_printf(s, "secmark=%u ", ct->secmark))
> +	if (ct_show_secctx(s, ct))
>  		goto release;
> -#endif
>  
>  	if (seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use)))
>  		goto release;
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index eb973fc..a6985da 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -15,6 +15,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/percpu.h>
>  #include <linux/netdevice.h>
> +#include <linux/security.h>
>  #include <net/net_namespace.h>
>  #ifdef CONFIG_SYSCTL
>  #include <linux/sysctl.h>
> @@ -108,6 +109,28 @@ static void ct_seq_stop(struct seq_file *s, void *v)
>  	rcu_read_unlock();
>  }
>  
> +#ifdef CONFIG_NF_CONNTRACK_SECMARK
> +static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
> +{
> +	int len, ret;
> +	char *secctx;
> +
> +	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);

Same concern as above.

> +	if (ret)
> +		return ret;
> +
> +	ret = seq_printf(s, "secctx=%s ", secctx);
> +
> +	security_release_secctx(secctx, len);
> +	return ret;
> +}
> +#else
> +static inline int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
> +{
> +	return 0;
> +}
> +#endif
> +
>  /* return 0 on success, 1 in case of error */
>  static int ct_seq_show(struct seq_file *s, void *v)
>  {
> @@ -168,10 +191,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
>  		goto release;
>  #endif
>  
> -#ifdef CONFIG_NF_CONNTRACK_SECMARK
> -	if (seq_printf(s, "secmark=%u ", ct->secmark))
> +	if (ct_show_secctx(s, ct))
>  		goto release;
> -#endif
>  
>  #ifdef CONFIG_NF_CONNTRACK_ZONES
>  	if (seq_printf(s, "zone=%u ", nf_ct_zone(ct)))
> 

-- 
paul moore
linux @ hp


