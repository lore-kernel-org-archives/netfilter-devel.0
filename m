From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] netfilter: nf_ct_helper: warn when not applying
 default helper assignment
Date: Wed, 25 Jan 2017 21:40:49 -0800
Message-ID: <1485409249.12563.96.camel@perches.com>
References: <alpine.LSU.2.20.1701240038080.25515@cbobk.fhfr.pm>
         <CA+55aFyDbDxcT+OjcxLxJ87MsFgNi0WWNoBSzZvWgA+yuQSXkg@mail.gmail.com>
         <20170124012859.GA6375@salvia>
         <alpine.LSU.2.20.1701240827240.25515@cbobk.fhfr.pm>
         <alpine.LSU.2.20.1701241115050.25515@cbobk.fhfr.pm>
         <CA+55aFxiM=GscZtvGkWnSfo3L4MTK0J6OFR5VbisZ1feTCBW9g@mail.gmail.com>
         <alpine.LSU.2.20.1701252136460.25515@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        info@jablonka.cz, eric@regit.org
To: Jiri Kosina <jikos@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.20.1701252136460.25515@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2017-01-25 at 21:43 +0100, Jiri Kosina wrote:
> Rewrite the code a little bit as suggested by Linus, so that we avoid
> spaghettiing the code even more -- namely the whole decision making
> process regarding helper selection (either automatic or not) is being
> separated, so that the whole logic can be simplified and code (condition)
> duplication reduced.
[]
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
[]
> @@ -188,6 +188,39 @@ struct nf_conn_help *
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_helper_ext_add);
>  
> +static struct nf_conntrack_helper *find_auto_helper(struct nf_conn *ct)
> +{
> +	return __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
> +}
> +
> +static struct nf_conntrack_helper *ct_lookup_helper(struct nf_conn *ct, struct net *net)
> +{
> +	struct nf_conntrack_helper *ret;
> +
> +	if (!net->ct.sysctl_auto_assign_helper) {
> +		if (net->ct.auto_assign_helper_warned)
> +			return NULL;
> +		if (!find_auto_helper(ct))
> +			return NULL;
> +		pr_info("nf_conntrack: default automatic helper assignment "
> +			"has been turned off for security reasons and CT-based "
> +			" firewall rule not found. Use the iptables CT target "
> +			"to attach helpers instead.\n");
> +		net->ct.auto_assign_helper_warned = 1;
> +		return NULL;
> +	}
> +
> +	ret = find_auto_helper(ct);
> +	if (!ret || net->ct.auto_assign_helper_warned)
> +		return ret;
> +	pr_info("nf_conntrack: automatic helper assignment is deprecated and it will "
> +		"be removed soon. Use the iptables CT target to attach helpers "
> +		" instead.\n");
> +	net->ct.auto_assign_helper_warned = 1;
> +	return ret;
> +}

There are whitespece defects concatenating these multi-line strings.

How about an exit block that emits the message like

{
	[...]
	const char *msg;

	[...]

	if (!net->ct.sysctl_auto_assign_helper) {
		if (net->ct.auto_assign_helper_warned)
			return NULL;
		if (!find_auto_helper(ct))
			return NULL;
		msg = "default automatic helper assignment has been turned off for security reasons and CT-based firewall rule not found";
		ret = NULL;
	} else {
		ret = find_auto_helper(ct);
		if (!ret || net->ct.auto_assign_helper_warned)
			return ret;
		msg = "automatic helper assignment is deprecated and it will be removed soon";
		net->ct.auto_assign_helper_warned = 1;
	}

	pr_info("nf_conntrack: %s.  Use the iptables CT target to attach helpers instead.\n", msg);
	return ret;
}
