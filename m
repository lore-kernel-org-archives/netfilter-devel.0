From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH net-next 1/2] br_netfilter: add struct netns_brnf
Date: Tue, 27 Nov 2018 03:20:45 +0100
Message-ID: <20181127022043.mzpqxlknqxcl6fmg@brauner.io>
References: <20181107134859.19896-1-christian@brauner.io>
 <20181107134859.19896-2-christian@brauner.io>
 <20181127002047.7jzpfy32oupsthtj@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        tyhicks@canonical.com, kadlec@blackhole.kfki.hu, fw@strlen.de,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181127002047.7jzpfy32oupsthtj@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Nov 27, 2018 at 01:20:47AM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Wed, Nov 07, 2018 at 02:48:58PM +0100, Christian Brauner wrote:
> [...]
> > diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
> > index ca043342c0eb..eedbd1ac940e 100644
> > --- a/include/net/netns/netfilter.h
> > +++ b/include/net/netns/netfilter.h
> > @@ -35,4 +35,20 @@ struct netns_nf {
> >  	bool			defrag_ipv6;
> >  #endif
> >  };
> > +
> > +struct netns_brnf {
> > +#ifdef CONFIG_SYSCTL
> > +	struct ctl_table_header *ctl_hdr;
> > +#endif
> > +
> > +	/* default value is 1 */
> > +	int call_iptables;
> > +	int call_ip6tables;
> > +	int call_arptables;
> > +
> > +	/* default value is 0 */
> > +	int filter_vlan_tagged;
> > +	int filter_pppoe_tagged;
> > +	int pass_vlan_indev;
> > +};
> 
> I have spun on this several times, wondering if there's a way to avoid
> scratching these many bytes per netns to expose these sysctl entries
> that are plain on/off toggles... You said this:
> 
> >Currently, the /proc/sys/net/bridge folder is only created in the
> >initial network namespace
> 
> I think we can add one single sysctl to expose these as flags from net
> namespaces. Idea is to keep the existing (legacy) sysctl entries for
> init_net only, and add a new single new one that exposes these as flags
> (should be also available for consistency in init_net I'd suggest).
> Flags could be map in this way, eg.
> 
>         0x1     call_iptables
>         0x2     call_ip6tables
>         0x4     call_arptables
>         0x8     filter_vlan_tagged
>         ...
> 
> Also documentation would be good to have for this.
> 
> Would this idea fly for you? Thanks.

My suggestion is to keep these files per network namespace but have a
single flag argument in struct netns_brnf:
+struct netns_brnf {
+#ifdef CONFIG_SYSCTL
+        struct ctl_table_header *ctl_hdr;
+#endif
+
+       /* default value is 1 */
+       unsigned int filter_flags;
+};

#define BRNF_CALL_IPTABLES    0x1
#define BRNF_CALL_IP6TABLES   0x2
#define BRNF_CALL_ARPTABLES   0x4
#define BRNF_CALL_VLAN_TAGGED 0x8

a write to the corresponding file would then cause the flag to be set or
unset in filter_flags.
This way we are a) space-efficient internally not bloating struct net
while b) not breaking running tools in non-initial network namespaces
that expect the files to be there. b) is really the important bit here. :)

Christian
