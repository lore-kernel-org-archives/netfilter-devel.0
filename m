From: "fenglg" <flg2932946@163.com>
Subject: i don't know whether it is a bug?
Date: Mon, 19 May 2008 19:27:59 +0800
Message-ID: <48316799.01FDFE.05405@m5-82.163.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
To: "netfilter-devel" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m5-82.163.com ([202.108.5.82]:49554 "HELO m5-82.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756677AbYESLmV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 07:42:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter-devel:
    I use conntrack-tools-0.9.6, libnetfilter_conntrack-0.0.89. I find there is the defination of "conntrack attributes" in libnetfilter_conntrack-0.0.89/include/libnetfilter_conntrack/libnetfilter_conntrack.h.

/* conntrack attributes */
enum nf_conntrack_attr {
	ATTR_ORIG_IPV4_SRC = 0,			/* u32 bits */
	ATTR_IPV4_SRC = ATTR_ORIG_IPV4_SRC,	/* alias */
	ATTR_ORIG_IPV4_DST,			/* u32 bits */
	ATTR_IPV4_DST = ATTR_ORIG_IPV4_DST,	/* alias */
	ATTR_REPL_IPV4_SRC,			/* u32 bits */
	ATTR_REPL_IPV4_DST,			/* u32 bits */
	ATTR_ORIG_IPV6_SRC = 4,			/* u128 bits */
	ATTR_IPV6_SRC = ATTR_ORIG_IPV6_SRC,	/* alias */
	ATTR_ORIG_IPV6_DST,			/* u128 bits */
	ATTR_IPV6_DST = ATTR_ORIG_IPV6_DST,	/* alias */
	ATTR_REPL_IPV6_SRC,			/* u128 bits */
	ATTR_REPL_IPV6_DST,			/* u128 bits */
	ATTR_ORIG_PORT_SRC = 8,			/* u16 bits */
	ATTR_PORT_SRC = ATTR_ORIG_PORT_SRC,	/* alias */
	ATTR_ORIG_PORT_DST,			/* u16 bits */
	ATTR_PORT_DST = ATTR_ORIG_PORT_DST,	/* alias */
	ATTR_REPL_PORT_SRC,			/* u16 bits */
	ATTR_REPL_PORT_DST,			/* u16 bits */
	ATTR_ICMP_TYPE = 12,			/* u8 bits */
	ATTR_ICMP_CODE,				/* u8 bits */
	ATTR_ICMP_ID,				/* u16 bits */
	ATTR_ORIG_L3PROTO,			/* u8 bits */
	ATTR_L3PROTO = ATTR_ORIG_L3PROTO,	/* alias */
	ATTR_REPL_L3PROTO = 16,			/* u8 bits */
	ATTR_ORIG_L4PROTO,			/* u8 bits */
	ATTR_L4PROTO = ATTR_ORIG_L4PROTO,	/* alias */
	ATTR_REPL_L4PROTO,			/* u8 bits */
	ATTR_TCP_STATE,				/* u8 bits */
	ATTR_SNAT_IPV4 = 20,			/* u32 bits */
	ATTR_DNAT_IPV4,				/* u32 bits */
	ATTR_SNAT_PORT,				/* u16 bits */
	ATTR_DNAT_PORT,				/* u16 bits */
	ATTR_TIMEOUT = 24,			/* u32 bits */
	ATTR_MARK,				/* u32 bits */
	ATTR_ORIG_COUNTER_PACKETS,		/* u32 bits */
	ATTR_REPL_COUNTER_PACKETS,		/* u32 bits */
	ATTR_ORIG_COUNTER_BYTES = 28,		/* u32 bits */
	ATTR_REPL_COUNTER_BYTES,		/* u32 bits */
	ATTR_USE,				/* u32 bits */
	ATTR_ID,				/* u32 bits */
	ATTR_STATUS = 32,			/* u32 bits  */
	ATTR_TCP_FLAGS_ORIG,			/* u8 bits */
	ATTR_TCP_FLAGS_REPL,			/* u8 bits */
	ATTR_TCP_MASK_ORIG,			/* u8 bits */
	ATTR_TCP_MASK_REPL = 36,		/* u8 bits */
	ATTR_MASTER_IPV4_SRC,			/* u32 bits */
	ATTR_MASTER_IPV4_DST,			/* u32 bits */
	ATTR_MASTER_IPV6_SRC,			/* u128 bits */
	ATTR_MASTER_IPV6_DST = 40,		/* u128 bits */
	ATTR_MASTER_PORT_SRC,			/* u16 bits */
	ATTR_MASTER_PORT_DST,			/* u16 bits */
	ATTR_MASTER_L3PROTO,			/* u8 bits */
	ATTR_MASTER_L4PROTO = 44,		/* u8 bits */
	ATTR_SECMARK,				/* u32 bits */
	ATTR_ORIG_NAT_SEQ_CORRECTION_POS,	/* u32 bits */
	ATTR_ORIG_NAT_SEQ_OFFSET_BEFORE,	/* u32 bits */
	ATTR_ORIG_NAT_SEQ_OFFSET_AFTER = 48,	/* u32 bits */
	ATTR_REPL_NAT_SEQ_CORRECTION_POS,	/* u32 bits */
	ATTR_REPL_NAT_SEQ_OFFSET_BEFORE,	/* u32 bits */
	ATTR_REPL_NAT_SEQ_OFFSET_AFTER,		/* u32 bits */
	ATTR_MAX
};

    The conntrack attributes are used in conntrack-tools-0.9.6/src/build.c.
/* XXX: ICMP not supported */
void build_netpld(struct nf_conntrack *ct, struct netpld *pld, int query)
{
	if (nfct_attr_is_set(ct, ATTR_IPV4_SRC))
		__build_pointer_be(ct, pld, ATTR_IPV4_SRC, sizeof(uint32_t));
	........
	/* setup the master conntrack */
	if (nfct_attr_is_set(ct, ATTR_MASTER_IPV4_SRC))
		__build_u32(ct, pld, ATTR_MASTER_IPV4_SRC);
	........
}
    The __build_u32 will use get_attr_array[type](ct) which is in libnetfilter_conntrack-0.0.89/src/conntrack/api.c. But the defination of get_attr_array has not ATTR_MASTER_IPV4_SRC.
get_attr get_attr_array[] = {
	[ATTR_ORIG_IPV4_SRC]		= get_attr_orig_ipv4_src,
	[ATTR_ORIG_IPV4_DST] 		= get_attr_orig_ipv4_dst,
	[ATTR_REPL_IPV4_SRC]		= get_attr_repl_ipv4_src,
	[ATTR_REPL_IPV4_DST]		= get_attr_repl_ipv4_dst,
	[ATTR_ORIG_IPV6_SRC]		= get_attr_orig_ipv6_src,
	[ATTR_ORIG_IPV6_DST]		= get_attr_orig_ipv6_dst,
	[ATTR_REPL_IPV6_SRC]		= get_attr_repl_ipv6_src,
	[ATTR_REPL_IPV6_DST]		= get_attr_repl_ipv6_dst,
	[ATTR_ORIG_PORT_SRC]		= get_attr_orig_port_src,
	[ATTR_ORIG_PORT_DST]		= get_attr_orig_port_dst,
	[ATTR_REPL_PORT_SRC]		= get_attr_repl_port_src,
	[ATTR_REPL_PORT_DST]		= get_attr_repl_port_dst,
	[ATTR_ICMP_TYPE]		= get_attr_icmp_type,
	[ATTR_ICMP_CODE]		= get_attr_icmp_code,
	[ATTR_ICMP_ID]			= get_attr_icmp_id,
	[ATTR_ORIG_L3PROTO]		= get_attr_orig_l3proto,
	[ATTR_REPL_L3PROTO]		= get_attr_repl_l3proto,
	[ATTR_ORIG_L4PROTO]		= get_attr_orig_l4proto,
	[ATTR_REPL_L4PROTO]		= get_attr_repl_l4proto,
	[ATTR_TCP_STATE]		= get_attr_tcp_state,
	[ATTR_SNAT_IPV4]		= get_attr_snat_ipv4,
	[ATTR_DNAT_IPV4]		= get_attr_dnat_ipv4,
	[ATTR_SNAT_PORT]		= get_attr_snat_port,
	[ATTR_DNAT_PORT]		= get_attr_dnat_port,
	[ATTR_TIMEOUT]			= get_attr_timeout,
	[ATTR_MARK]			= get_attr_mark,
	[ATTR_ORIG_COUNTER_PACKETS] 	= get_attr_orig_counter_packets,
	[ATTR_ORIG_COUNTER_BYTES]	= get_attr_orig_counter_bytes,
	[ATTR_REPL_COUNTER_PACKETS]	= get_attr_repl_counter_packets,
	[ATTR_REPL_COUNTER_BYTES]	= get_attr_repl_counter_bytes,
	[ATTR_USE]			= get_attr_use,
	[ATTR_STATUS]			= get_attr_status,
	[ATTR_TCP_FLAGS_ORIG]		= get_attr_tcp_flags_orig,
	[ATTR_TCP_FLAGS_REPL]		= get_attr_tcp_flags_repl,
	[ATTR_TCP_MASK_ORIG]		= get_attr_tcp_mask_orig,
	[ATTR_TCP_MASK_REPL]		= get_attr_tcp_mask_repl,
	[ATTR_SECMARK]			= get_attr_secmark,
	[ATTR_ORIG_NAT_SEQ_CORRECTION_POS]	= get_attr_orig_cor_pos,
	[ATTR_ORIG_NAT_SEQ_OFFSET_BEFORE]	= get_attr_orig_off_bfr,
	[ATTR_ORIG_NAT_SEQ_OFFSET_AFTER]	= get_attr_orig_off_aft,
	[ATTR_REPL_NAT_SEQ_CORRECTION_POS]	= get_attr_repl_cor_pos,
	[ATTR_REPL_NAT_SEQ_OFFSET_BEFORE]	= get_attr_repl_off_bfr,
	[ATTR_REPL_NAT_SEQ_OFFSET_AFTER]	= get_attr_repl_off_aft,
};
    If there is a ftp-data connection, then the conntrackd will down.
    conntrackd[22302]: segfault at 0 ip 00000000 sp bf94259c error 4 in conntrackd[8048000+1d000]
	

fenglg
2008-05-19


