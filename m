From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next 1/2] br_netfilter: add struct netns_brnf
Date: Tue, 27 Nov 2018 01:20:47 +0100
Message-ID: <20181127002047.7jzpfy32oupsthtj@salvia>
References: <20181107134859.19896-1-christian@brauner.io>
 <20181107134859.19896-2-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        tyhicks@canonical.com, kadlec@blackhole.kfki.hu, fw@strlen.de,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com
To: Christian Brauner <christian@brauner.io>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181107134859.19896-2-christian@brauner.io>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Wed, Nov 07, 2018 at 02:48:58PM +0100, Christian Brauner wrote:
[...]
> diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
> index ca043342c0eb..eedbd1ac940e 100644
> --- a/include/net/netns/netfilter.h
> +++ b/include/net/netns/netfilter.h
> @@ -35,4 +35,20 @@ struct netns_nf {
>  	bool			defrag_ipv6;
>  #endif
>  };
> +
> +struct netns_brnf {
> +#ifdef CONFIG_SYSCTL
> +	struct ctl_table_header *ctl_hdr;
> +#endif
> +
> +	/* default value is 1 */
> +	int call_iptables;
> +	int call_ip6tables;
> +	int call_arptables;
> +
> +	/* default value is 0 */
> +	int filter_vlan_tagged;
> +	int filter_pppoe_tagged;
> +	int pass_vlan_indev;
> +};

I have spun on this several times, wondering if there's a way to avoid
scratching these many bytes per netns to expose these sysctl entries
that are plain on/off toggles... You said this:

>Currently, the /proc/sys/net/bridge folder is only created in the
>initial network namespace

I think we can add one single sysctl to expose these as flags from net
namespaces. Idea is to keep the existing (legacy) sysctl entries for
init_net only, and add a new single new one that exposes these as flags
(should be also available for consistency in init_net I'd suggest).
Flags could be map in this way, eg.

        0x1     call_iptables
        0x2     call_ip6tables
        0x4     call_arptables
        0x8     filter_vlan_tagged
        ...

Also documentation would be good to have for this.

Would this idea fly for you? Thanks.
