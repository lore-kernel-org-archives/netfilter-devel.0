From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH RFC 2/4] netlink: add generic object description
 infrastructure
Date: Wed, 7 Feb 2018 17:28:20 -0800
Message-ID: <6b52d0e8-de06-0b9c-0874-d65865a36ae9@infradead.org>
References: <20180207013713.2432-1-pablo@netfilter.org>
 <20180207013713.2432-3-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180207013713.2432-3-pablo@netfilter.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 02/06/2018 05:37 PM, Pablo Neira Ayuso wrote:
> This patch allows netlink busses to provide object descriptions to
> userspace, in terms of supported attributes and its corresponding
> datatypes.
> 
> Userspace sends a requests that looks like:
> 
> 	netlink header
> 	NLA_DESC_REQ_BUS
> 	NLA_DESC_REQ_DATA
> 
> Where NLA_DESC_REQ_BUS is the netlink bus/protocol number, eg.
> NETLINK_NETFILTER, and NLA_DESC_REQ_DATA is an attribute layout is
> specific to the bus that you are inspecting, this is useful for both
> nfnetlink and genetlink since they need to what subsystem in the bus
> specifically you're targeting to.
> 
> Then, the netlink description subsystem response via netlink dump looks
> like this:
> 
> 	netlink header
> 	NLA_DESC_NUM_OBJS
> 	NLA_DESC_OBJS (nest)
> 		NLA_DESC_LIST_ITEM (nest)
> 			NLA_DESC_OBJ_ID
> 			NLA_DESC_OBJ_ATTRS_MAX
> 			NLA_DESC_OBJ_ATTRS (nest)
> 				NLA_DESC_LIST_ITEM (nest)
> 					NLA_DESC_ATTR_NUM
> 					NLA_DESC_ATTR_TYPE
> 					NLA_DESC_ATTR_LEN
> 					NLA_DESC_ATTR_MAXVAL
> 					NLA_DESC_ATTR_NEST_ID
> 		NLA_DESC_LIST_ITEM (nest)
> 			...
> 
> Each object definition is composed of an unique ID, the number of
> attributes and the list of attribute definitions.
> 
> The NETLINK_DESC bus provides a generic interface to retrieve the list
> of existing objects and its attributes via netlink dump. This new
> description family autoloads module dependencies based on what userspace
> requests.
> 
> Each bus needs to register a struct nl_desc_subsys definition, that
> provides the lookup and parse callbacks. These route the description
> requests to the corresponding backend subsystem for genetlink and
> nfnetlink. The lookup callback returns struct nl_desc_objs that provides
> the array of object descriptions.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/net_namespace.h  |   1 +
>  include/net/nldesc.h         | 160 ++++++++++++++
>  include/uapi/linux/netlink.h |  67 ++++++
>  net/netlink/Makefile         |   2 +-
>  net/netlink/desc.c           | 499 +++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 728 insertions(+), 1 deletion(-)
>  create mode 100644 include/net/nldesc.h
>  create mode 100644 net/netlink/desc.c
> 

> diff --git a/include/net/nldesc.h b/include/net/nldesc.h
> new file mode 100644
> index 000000000000..19306a648f10
> --- /dev/null
> +++ b/include/net/nldesc.h
> @@ -0,0 +1,160 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __NET_NLDESC_H
> +#define __NET_NLDESC_H
> +
> +#include <linux/types.h>
> +
> +struct nl_desc_cmd;
> +struct nl_desc_obj;
> +
> +struct nl_desc_cmds {
> +	int				max;
> +	const struct nl_desc_cmd	*table;
> +};
> +
> +struct nl_desc_objs {
> +	int				max;
> +	const struct nl_desc_obj	**table;
> +};
> +
> +struct nl_desc_req {
> +	u32				bus;
> +};
> +
> +struct net;
> +struct sk_buff;
> +struct nlmsghdr;
> +struct nlattr;
> +

> +
> +/**
> + * struct nl_desc_obj - netlink object description
> + * @id: unique ID to identify this netlink object
> + * @max: number of attributes to describe this object

      @attr_max:

> + * @attrs: array of attribute descriptions
> + */
> +struct nl_desc_obj {
> +	u16				id;
> +	u16				attr_max;
> +	const struct nl_desc_attr	*attrs;
> +};


Is there a test program for this?
Maybe add it to tools/testing/ ?

thanks,
-- 
~Randy
