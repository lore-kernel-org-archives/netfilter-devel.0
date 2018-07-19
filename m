From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH RFC/RFT net-next 00/17] net: Convert neighbor tables to
 per-namespace
Date: Thu, 19 Jul 2018 09:49:09 -0600
Message-ID: <996fe2a0-391d-d596-dbfd-7d330e3098bf@gmail.com>
References: <20180717120651.15748-1-dsahern@kernel.org>
 <15730.1531961643@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, nikita.leshchenko@oracle.com,
        roopa@cumulusnetworks.com, stephen@networkplumber.org,
        idosch@mellanox.com, jiri@mellanox.com, saeedm@mellanox.com,
        alex.aring@gmail.com, linux-wpan@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Michael Richardson <mcr@sandelman.ca>, dsahern@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <15730.1531961643@localhost>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 7/18/18 6:54 PM, Michael Richardson wrote:
>> Remove open use of arp_tbl and nd_tbl in favor of the new
>> ipv{4,6}_neigh_table helpers. Since the existence of the IPv6 table
>> is managed by the core networking, the IS_ENABLED checks for IPv6
>> can be removed in favor of "is the table non-NULL".
> 
> What's the advantage of changing this check? (I am ignorant)
> 

Just makes the code simpler.

The current nd_tbl is a global owned by the ipv6 code
(net/ipv6/ndisc.c). If CONFIG_IPV6 is not enabled, then nd_tbl is not
defined which leads code referencing it to use if checks like this:

#if IS_ENABLED(CONFIG_IPV6)
		if (!p->dev || (p->tbl != &nd_tbl && p->tbl != &arp_tbl))
#else
		if (!p->dev || p->tbl != &arp_tbl)
#endif

With the neigh_find_table approach the IS_ENABLED can be removed in
favor of 'if (tbl)'. If tbl is set, then ipv6 is loaded and initialized.
