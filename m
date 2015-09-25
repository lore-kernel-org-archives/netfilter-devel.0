From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Fetching interface name
Date: Fri, 25 Sep 2015 12:22:52 +0200
Message-ID: <20150925102252.GA3768@salvia>
References: <5604D75E.8000809@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: coreteam@netfilter.org, eric@netfilter.org,
	netfilter-devel@vger.kernel.org
To: Vikas <vikas.c.kumar@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55549 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbbIYKQE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Sep 2015 06:16:04 -0400
Content-Disposition: inline
In-Reply-To: <5604D75E.8000809@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc'ing netfilter-devel for development questions.

On Fri, Sep 25, 2015 at 10:40:54AM +0530, Vikas wrote:
> Hi,
> 
> In the netlink infra I could see these attributes:
> 
>  enum nfqnl_attr_type {
> 0034     NFQA_UNSPEC,0035     NFQA_PACKET_HDR,
> 0036     NFQA_VERDICT_HDR,       /* nfqnl_msg_verdict_hrd */
> 0037     NFQA_MARK,          /* __u32 nfmark */
> 0038     NFQA_TIMESTAMP,         /* nfqnl_msg_packet_timestamp */
> 0039*NFQA_IFINDEX_INDEV*,     /* __u32 ifindex */
> 0040*NFQA_IFINDEX_OUTDEV*,        /* __u32 ifindex */
> 0041     NFQA_IFINDEX_PHYSINDEV,     /* __u32 ifindex */
> 0042     NFQA_IFINDEX_PHYSOUTDEV,    /* __u32 ifindex */
> 0043     NFQA_HWADDR,            /* nfqnl_msg_packet_hw */
> 0044     NFQA_PAYLOAD,           /* opaque data payload */
> 0045     NFQA_CT,            /* nf_conntrack_netlink.h */
> 0046     NFQA_CT_INFO,           /* enum ip_conntrack_info */
> 0047     NFQA_CAP_LEN,           /* __u32 length of captured packet */
> 0048     NFQA_SKB_INFO,          /* __u32 skb meta information */
> 0049     NFQA_EXP,           /* nf_conntrack_netlink.h */
> 0050
> 0051     __NFQA_MAX
> 0052 };
> 
> Currently we are doing this to get the input/putput interface index:
>    input_interface_index = mnl_attr_get_u32(tb[NFQA_IFINDEX_INDEV]);    // where tb being a nlattr structure: struct nlattr *tb[NFQA_MAX]
>    output_interface_index = mnl_attr_get_u32(tb[NFQA_IFINDEX_OUTDEV]);
> 
> Is there a way(or any attribute like NFQA_IFINDEX_INDEV/OUTDEV) by
> which we can get the input/output interface*name*?  I don't want to
> use kernel call: if_indextoname() to map index to name, because it
> may be time consuming.

It should be easy to build a cache of ifindex in userspace and
maintain it up to date. So you don't need to use if_indextoname()
since it generates quite a lot of netlink traffic between kernel and
userspace.

You can probably contribute some example to libmnl that we can apply
to the tree. You can use this change I made quite recently as
reference for that code:

http://git.netfilter.org/nftables/commit/?id=3ed296118a065caff5600e60d4f7ef18e137f9a0
