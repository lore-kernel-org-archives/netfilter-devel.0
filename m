From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH nf-next v2 02/10] netfilter: nf_log: prepar net namespace
 support for nf_log
Date: Mon, 08 Apr 2013 10:46:46 +0800
Message-ID: <51622F96.1090805@cn.fujitsu.com>
References: <1364205048-32632-1-git-send-email-gaofeng@cn.fujitsu.com> <1364205048-32632-2-git-send-email-gaofeng@cn.fujitsu.com> <20130405183005.GB4853@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20290 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934637Ab3DHCp4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Apr 2013 22:45:56 -0400
In-Reply-To: <20130405183005.GB4853@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2013/04/06 02:30, Pablo Neira Ayuso wrote:
> On Mon, Mar 25, 2013 at 05:50:40PM +0800, Gao feng wrote:
>> This patch adds netns support for nf_log,contains
>> four major changes.
>>
>> 1,nf_log_register is split to two functions:
>>   nf_log_register and nf_log_set.
>>   The new nf_log_register is used only for register nf_logger,
>>   nf_log_set is used for setting pernet nf_loggers.
>>
>>   Because the moudules that use the nf_log_register should be
>>   changed to use these new functions, and in order not to
>>   change the behavior. only allow to set the nf_loggers of
>>   init net.
>>
>> 2,Add net as a parameter of nf_log_bind_pf,only allow init net
>>   to bind the nflogger to the proto family.
>>
>> 3,Some l4proto such as tcp,udp... use nf_log_packet to log
>>   the invalid packets, we need pass proper netns to the
>>   nf_log_packet. Since other netns except init net has
>>   no nflogger binding to the proto, we only allow nf_log_packet
>>   handle the log request which comes from init net.
>>
>> 4,Make the sysctl net/netfilter/nf_log pernet.
> 
> Applied with some changes (see below), thanks.
> 
>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
>> ---
>>  include/net/netfilter/nf_log.h                 |  14 +-
>>  include/net/netns/netfilter.h                  |   7 +
>>  net/bridge/netfilter/ebt_log.c                 |   7 +-
>>  net/bridge/netfilter/ebt_nflog.c               |   5 +-
>>  net/ipv4/netfilter/ip_tables.c                 |   3 +-
>>  net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   8 +-
>>  net/ipv6/netfilter/ip6_tables.c                |   3 +-
>>  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   7 +-
>>  net/netfilter/nf_conntrack_helper.c            |   2 +-
>>  net/netfilter/nf_conntrack_proto_dccp.c        |   9 +-
>>  net/netfilter/nf_conntrack_proto_tcp.c         |  18 +-
>>  net/netfilter/nf_conntrack_proto_udp.c         |   6 +-
>>  net/netfilter/nf_conntrack_proto_udplite.c     |   8 +-
>>  net/netfilter/nf_log.c                         | 223 ++++++++++++++++++-------
>>  net/netfilter/nfnetlink_log.c                  |   5 +-
>>  net/netfilter/xt_osf.c                         |   6 +-
>>  16 files changed, 231 insertions(+), 100 deletions(-)
>>
>> diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
>> index e991bd0..31f1fb9 100644
>> --- a/include/net/netfilter/nf_log.h
>> +++ b/include/net/netfilter/nf_log.h
>> @@ -49,12 +49,18 @@ struct nf_logger {
>>  int nf_log_register(u_int8_t pf, struct nf_logger *logger);
>>  void nf_log_unregister(struct nf_logger *logger);
>>  
>> -int nf_log_bind_pf(u_int8_t pf, const struct nf_logger *logger);
>> -void nf_log_unbind_pf(u_int8_t pf);
>> +void nf_log_set(struct net *net, u_int8_t pf,
>> +		const struct nf_logger *logger);
>> +void nf_log_unset(struct net *net, const struct nf_logger *logger);
>> +
>> +int nf_log_bind_pf(struct net *net, u_int8_t pf,
>> +		   const struct nf_logger *logger);
>> +void nf_log_unbind_pf(struct net *net, u_int8_t pf);
>>  
>>  /* Calls the registered backend logging function */
>> -__printf(7, 8)
>> -void nf_log_packet(u_int8_t pf,
>> +__printf(8, 9)
>> +void nf_log_packet(struct net *net,
>> +		   u_int8_t pf,
>>  		   unsigned int hooknum,
>>  		   const struct sk_buff *skb,
>>  		   const struct net_device *in,
>> diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
>> index 248ca1c..8874002 100644
>> --- a/include/net/netns/netfilter.h
>> +++ b/include/net/netns/netfilter.h
>> @@ -2,10 +2,17 @@
>>  #define __NETNS_NETFILTER_H
>>  
>>  #include <linux/proc_fs.h>
>> +#include <linux/netfilter.h>
>> +
>> +struct nf_logger;
>>  
>>  struct netns_nf {
>>  #if defined CONFIG_PROC_FS
>>  	struct proc_dir_entry *proc_netfilter;
>>  #endif
>> +	const struct nf_logger __rcu *nf_loggers[NFPROTO_NUMPROTO];
>> +#ifdef CONFIG_SYSCTL
>> +	struct ctl_table_header *nf_log_dir_header;
>> +#endif
>>  };
>>  #endif
>> diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
>> index 92de5e5..08e5ea5 100644
>> --- a/net/bridge/netfilter/ebt_log.c
>> +++ b/net/bridge/netfilter/ebt_log.c
>> @@ -176,17 +176,18 @@ ebt_log_tg(struct sk_buff *skb, const struct xt_action_param *par)
>>  {
>>  	const struct ebt_log_info *info = par->targinfo;
>>  	struct nf_loginfo li;
>> +	struct net *net = dev_net(par->in ? par->in : par->out);
>>  
>>  	li.type = NF_LOG_TYPE_LOG;
>>  	li.u.log.level = info->loglevel;
>>  	li.u.log.logflags = info->bitmask;
>>  
>>  	if (info->bitmask & EBT_LOG_NFLOG)
>> -		nf_log_packet(NFPROTO_BRIDGE, par->hooknum, skb, par->in,
>> -		              par->out, &li, "%s", info->prefix);
>> +		nf_log_packet(net, NFPROTO_BRIDGE, par->hooknum, skb,
>> +			      par->in, par->out, &li, "%s", info->prefix);
>>  	else
>>  		ebt_log_packet(NFPROTO_BRIDGE, par->hooknum, skb, par->in,
>> -		               par->out, &li, info->prefix);
>> +			       par->out, &li, info->prefix);
>>  	return EBT_CONTINUE;
>>  }
>>  
>> diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
>> index 5be68bb..59ac795 100644
>> --- a/net/bridge/netfilter/ebt_nflog.c
>> +++ b/net/bridge/netfilter/ebt_nflog.c
>> @@ -24,14 +24,15 @@ ebt_nflog_tg(struct sk_buff *skb, const struct xt_action_param *par)
>>  {
>>  	const struct ebt_nflog_info *info = par->targinfo;
>>  	struct nf_loginfo li;
>> +	struct net *net = dev_net(par->in ? par->in : par->out);
>>  
>>  	li.type = NF_LOG_TYPE_ULOG;
>>  	li.u.ulog.copy_len = info->len;
>>  	li.u.ulog.group = info->group;
>>  	li.u.ulog.qthreshold = info->threshold;
>>  
>> -	nf_log_packet(PF_BRIDGE, par->hooknum, skb, par->in, par->out,
>> -	              &li, "%s", info->prefix);
>> +	nf_log_packet(net, PF_BRIDGE, par->hooknum, skb, par->in,
>> +		      par->out, &li, "%s", info->prefix);
>>  	return EBT_CONTINUE;
>>  }
>>  
>> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
>> index 3efcf87..b371593 100644
>> --- a/net/ipv4/netfilter/ip_tables.c
>> +++ b/net/ipv4/netfilter/ip_tables.c
>> @@ -259,6 +259,7 @@ static void trace_packet(const struct sk_buff *skb,
>>  	const char *hookname, *chainname, *comment;
>>  	const struct ipt_entry *iter;
>>  	unsigned int rulenum = 0;
>> +	struct net *net = dev_net(in ? in : out);
>>  
>>  	table_base = private->entries[smp_processor_id()];
>>  	root = get_entry(table_base, private->hook_entry[hook]);
>> @@ -271,7 +272,7 @@ static void trace_packet(const struct sk_buff *skb,
>>  		    &chainname, &comment, &rulenum) != 0)
>>  			break;
>>  
>> -	nf_log_packet(AF_INET, hook, skb, in, out, &trace_loginfo,
>> +	nf_log_packet(net, AF_INET, hook, skb, in, out, &trace_loginfo,
>>  		      "TRACE: %s:%s:%s:%u ",
>>  		      tablename, chainname, comment, rulenum);
>>  }
>> diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
>> index 5241d99..c2cd63d 100644
>> --- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
>> +++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
>> @@ -187,8 +187,8 @@ icmp_error(struct net *net, struct nf_conn *tmpl,
>>  	icmph = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_ih), &_ih);
>>  	if (icmph == NULL) {
>>  		if (LOG_INVALID(net, IPPROTO_ICMP))
>> -			nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
>> -				      "nf_ct_icmp: short packet ");
>> +			nf_log_packet(net, PF_INET, 0, skb, NULL, NULL,
>> +				      NULL, "nf_ct_icmp: short packet ");
>>  		return -NF_ACCEPT;
>>  	}
>>  
>> @@ -196,7 +196,7 @@ icmp_error(struct net *net, struct nf_conn *tmpl,
>>  	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
>>  	    nf_ip_checksum(skb, hooknum, dataoff, 0)) {
>>  		if (LOG_INVALID(net, IPPROTO_ICMP))
>> -			nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, PF_INET, 0, skb, NULL, NULL, NULL,
>>  				      "nf_ct_icmp: bad HW ICMP checksum ");
>>  		return -NF_ACCEPT;
>>  	}
>> @@ -209,7 +209,7 @@ icmp_error(struct net *net, struct nf_conn *tmpl,
>>  	 */
>>  	if (icmph->type > NR_ICMP_TYPES) {
>>  		if (LOG_INVALID(net, IPPROTO_ICMP))
>> -			nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, PF_INET, 0, skb, NULL, NULL, NULL,
>>  				      "nf_ct_icmp: invalid ICMP type ");
>>  		return -NF_ACCEPT;
>>  	}
>> diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
>> index 341b54a..8861b1e 100644
>> --- a/net/ipv6/netfilter/ip6_tables.c
>> +++ b/net/ipv6/netfilter/ip6_tables.c
>> @@ -284,6 +284,7 @@ static void trace_packet(const struct sk_buff *skb,
>>  	const char *hookname, *chainname, *comment;
>>  	const struct ip6t_entry *iter;
>>  	unsigned int rulenum = 0;
>> +	struct net *net = dev_net(in ? in : out);
>>  
>>  	table_base = private->entries[smp_processor_id()];
>>  	root = get_entry(table_base, private->hook_entry[hook]);
>> @@ -296,7 +297,7 @@ static void trace_packet(const struct sk_buff *skb,
>>  		    &chainname, &comment, &rulenum) != 0)
>>  			break;
>>  
>> -	nf_log_packet(AF_INET6, hook, skb, in, out, &trace_loginfo,
>> +	nf_log_packet(net, AF_INET6, hook, skb, in, out, &trace_loginfo,
>>  		      "TRACE: %s:%s:%s:%u ",
>>  		      tablename, chainname, comment, rulenum);
>>  }
>> diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
>> index 24df3dd..b3807c5 100644
>> --- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
>> +++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
>> @@ -131,7 +131,8 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
>>  			 type + 128);
>>  		nf_ct_dump_tuple_ipv6(&ct->tuplehash[0].tuple);
>>  		if (LOG_INVALID(nf_ct_net(ct), IPPROTO_ICMPV6))
>> -			nf_log_packet(PF_INET6, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(nf_ct_net(ct), PF_INET6, 0, skb, NULL,
>> +				      NULL, NULL,
>>  				      "nf_ct_icmpv6: invalid new with type %d ",
>>  				      type + 128);
>>  		return false;
>> @@ -203,7 +204,7 @@ icmpv6_error(struct net *net, struct nf_conn *tmpl,
>>  	icmp6h = skb_header_pointer(skb, dataoff, sizeof(_ih), &_ih);
>>  	if (icmp6h == NULL) {
>>  		if (LOG_INVALID(net, IPPROTO_ICMPV6))
>> -		nf_log_packet(PF_INET6, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
>>  			      "nf_ct_icmpv6: short packet ");
>>  		return -NF_ACCEPT;
>>  	}
>> @@ -211,7 +212,7 @@ icmpv6_error(struct net *net, struct nf_conn *tmpl,
>>  	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
>>  	    nf_ip6_checksum(skb, hooknum, dataoff, IPPROTO_ICMPV6)) {
>>  		if (LOG_INVALID(net, IPPROTO_ICMPV6))
>> -			nf_log_packet(PF_INET6, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, PF_INET6, 0, skb, NULL, NULL, NULL,
>>  				      "nf_ct_icmpv6: ICMPv6 checksum failed ");
>>  		return -NF_ACCEPT;
>>  	}
>> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
>> index 94b4b98..a0b1c5c 100644
>> --- a/net/netfilter/nf_conntrack_helper.c
>> +++ b/net/netfilter/nf_conntrack_helper.c
>> @@ -353,7 +353,7 @@ void nf_ct_helper_log(struct sk_buff *skb, const struct nf_conn *ct,
>>  	/* rcu_read_lock()ed by nf_hook_slow */
>>  	helper = rcu_dereference(help->helper);
>>  
>> -	nf_log_packet(nf_ct_l3num(ct), 0, skb, NULL, NULL, NULL,
>> +	nf_log_packet(nf_ct_net(ct), nf_ct_l3num(ct), 0, skb, NULL, NULL, NULL,
>>  		      "nf_ct_%s: dropping packet: %pV ", helper->name, &vaf);
>>  
>>  	va_end(args);
>> diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
>> index 432f957..7358dc3 100644
>> --- a/net/netfilter/nf_conntrack_proto_dccp.c
>> +++ b/net/netfilter/nf_conntrack_proto_dccp.c
>> @@ -456,7 +456,8 @@ static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
>>  
>>  out_invalid:
>>  	if (LOG_INVALID(net, IPPROTO_DCCP))
>> -		nf_log_packet(nf_ct_l3num(ct), 0, skb, NULL, NULL, NULL, msg);
>> +		nf_log_packet(net, nf_ct_l3num(ct), 0, skb, NULL, NULL,
>> +			      NULL, msg);
>>  	return false;
>>  }
>>  
>> @@ -542,13 +543,13 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
>>  
>>  		spin_unlock_bh(&ct->lock);
>>  		if (LOG_INVALID(net, IPPROTO_DCCP))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				      "nf_ct_dccp: invalid packet ignored ");
>>  		return NF_ACCEPT;
>>  	case CT_DCCP_INVALID:
>>  		spin_unlock_bh(&ct->lock);
>>  		if (LOG_INVALID(net, IPPROTO_DCCP))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				      "nf_ct_dccp: invalid state transition ");
>>  		return -NF_ACCEPT;
>>  	}
>> @@ -613,7 +614,7 @@ static int dccp_error(struct net *net, struct nf_conn *tmpl,
>>  
>>  out_invalid:
>>  	if (LOG_INVALID(net, IPPROTO_DCCP))
>> -		nf_log_packet(pf, 0, skb, NULL, NULL, NULL, msg);
>> +		nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL, msg);
>>  	return -NF_ACCEPT;
>>  }
>>  
>> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
>> index 83876e9..f021a20 100644
>> --- a/net/netfilter/nf_conntrack_proto_tcp.c
>> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
>> @@ -720,7 +720,7 @@ static bool tcp_in_window(const struct nf_conn *ct,
>>  		    tn->tcp_be_liberal)
>>  			res = true;
>>  		if (!res && LOG_INVALID(net, IPPROTO_TCP))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  			"nf_ct_tcp: %s ",
>>  			before(seq, sender->td_maxend + 1) ?
>>  			after(end, sender->td_end - receiver->td_maxwin - 1) ?
>> @@ -772,7 +772,7 @@ static int tcp_error(struct net *net, struct nf_conn *tmpl,
>>  	th = skb_header_pointer(skb, dataoff, sizeof(_tcph), &_tcph);
>>  	if (th == NULL) {
>>  		if (LOG_INVALID(net, IPPROTO_TCP))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				"nf_ct_tcp: short packet ");
>>  		return -NF_ACCEPT;
>>  	}
>> @@ -780,7 +780,7 @@ static int tcp_error(struct net *net, struct nf_conn *tmpl,
>>  	/* Not whole TCP header or malformed packet */
>>  	if (th->doff*4 < sizeof(struct tcphdr) || tcplen < th->doff*4) {
>>  		if (LOG_INVALID(net, IPPROTO_TCP))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				"nf_ct_tcp: truncated/malformed packet ");
>>  		return -NF_ACCEPT;
>>  	}
>> @@ -793,7 +793,7 @@ static int tcp_error(struct net *net, struct nf_conn *tmpl,
>>  	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
>>  	    nf_checksum(skb, hooknum, dataoff, IPPROTO_TCP, pf)) {
>>  		if (LOG_INVALID(net, IPPROTO_TCP))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				  "nf_ct_tcp: bad TCP checksum ");
>>  		return -NF_ACCEPT;
>>  	}
>> @@ -802,7 +802,7 @@ static int tcp_error(struct net *net, struct nf_conn *tmpl,
>>  	tcpflags = (tcp_flag_byte(th) & ~(TCPHDR_ECE|TCPHDR_CWR|TCPHDR_PSH));
>>  	if (!tcp_valid_flags[tcpflags]) {
>>  		if (LOG_INVALID(net, IPPROTO_TCP))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				  "nf_ct_tcp: invalid TCP flag combination ");
>>  		return -NF_ACCEPT;
>>  	}
>> @@ -949,7 +949,7 @@ static int tcp_packet(struct nf_conn *ct,
>>  		}
>>  		spin_unlock_bh(&ct->lock);
>>  		if (LOG_INVALID(net, IPPROTO_TCP))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				  "nf_ct_tcp: invalid packet ignored in "
>>  				  "state %s ", tcp_conntrack_names[old_state]);
>>  		return NF_ACCEPT;
>> @@ -959,7 +959,7 @@ static int tcp_packet(struct nf_conn *ct,
>>  			 dir, get_conntrack_index(th), old_state);
>>  		spin_unlock_bh(&ct->lock);
>>  		if (LOG_INVALID(net, IPPROTO_TCP))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				  "nf_ct_tcp: invalid state ");
>>  		return -NF_ACCEPT;
>>  	case TCP_CONNTRACK_CLOSE:
>> @@ -969,8 +969,8 @@ static int tcp_packet(struct nf_conn *ct,
>>  			/* Invalid RST  */
>>  			spin_unlock_bh(&ct->lock);
>>  			if (LOG_INVALID(net, IPPROTO_TCP))
>> -				nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> -					  "nf_ct_tcp: invalid RST ");
>> +				nf_log_packet(net, pf, 0, skb, NULL, NULL,
>> +					      NULL, "nf_ct_tcp: invalid RST ");
>>  			return -NF_ACCEPT;
>>  		}
>>  		if (index == TCP_RST_SET
>> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
>> index 59623cc..fee4322 100644
>> --- a/net/netfilter/nf_conntrack_proto_udp.c
>> +++ b/net/netfilter/nf_conntrack_proto_udp.c
>> @@ -119,7 +119,7 @@ static int udp_error(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
>>  	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
>>  	if (hdr == NULL) {
>>  		if (LOG_INVALID(net, IPPROTO_UDP))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				      "nf_ct_udp: short packet ");
>>  		return -NF_ACCEPT;
>>  	}
>> @@ -127,7 +127,7 @@ static int udp_error(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
>>  	/* Truncated/malformed packets */
>>  	if (ntohs(hdr->len) > udplen || ntohs(hdr->len) < sizeof(*hdr)) {
>>  		if (LOG_INVALID(net, IPPROTO_UDP))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				"nf_ct_udp: truncated/malformed packet ");
>>  		return -NF_ACCEPT;
>>  	}
>> @@ -143,7 +143,7 @@ static int udp_error(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
>>  	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
>>  	    nf_checksum(skb, hooknum, dataoff, IPPROTO_UDP, pf)) {
>>  		if (LOG_INVALID(net, IPPROTO_UDP))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				"nf_ct_udp: bad UDP checksum ");
>>  		return -NF_ACCEPT;
>>  	}
>> diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
>> index 1574895..c29d359 100644
>> --- a/net/netfilter/nf_conntrack_proto_udplite.c
>> +++ b/net/netfilter/nf_conntrack_proto_udplite.c
>> @@ -131,7 +131,7 @@ static int udplite_error(struct net *net, struct nf_conn *tmpl,
>>  	hdr = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
>>  	if (hdr == NULL) {
>>  		if (LOG_INVALID(net, IPPROTO_UDPLITE))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				      "nf_ct_udplite: short packet ");
>>  		return -NF_ACCEPT;
>>  	}
>> @@ -141,7 +141,7 @@ static int udplite_error(struct net *net, struct nf_conn *tmpl,
>>  		cscov = udplen;
>>  	else if (cscov < sizeof(*hdr) || cscov > udplen) {
>>  		if (LOG_INVALID(net, IPPROTO_UDPLITE))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				"nf_ct_udplite: invalid checksum coverage ");
>>  		return -NF_ACCEPT;
>>  	}
>> @@ -149,7 +149,7 @@ static int udplite_error(struct net *net, struct nf_conn *tmpl,
>>  	/* UDPLITE mandates checksums */
>>  	if (!hdr->check) {
>>  		if (LOG_INVALID(net, IPPROTO_UDPLITE))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				      "nf_ct_udplite: checksum missing ");
>>  		return -NF_ACCEPT;
>>  	}
>> @@ -159,7 +159,7 @@ static int udplite_error(struct net *net, struct nf_conn *tmpl,
>>  	    nf_checksum_partial(skb, hooknum, dataoff, cscov, IPPROTO_UDP,
>>  	    			pf)) {
>>  		if (LOG_INVALID(net, IPPROTO_UDPLITE))
>> -			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>> +			nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
>>  				      "nf_ct_udplite: bad UDPLite checksum ");
>>  		return -NF_ACCEPT;
>>  	}
>> diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
>> index 9e31269..2aa1fc1 100644
>> --- a/net/netfilter/nf_log.c
>> +++ b/net/netfilter/nf_log.c
>> @@ -16,7 +16,6 @@
>>  #define NF_LOG_PREFIXLEN		128
>>  #define NFLOGGER_NAME_LEN		64
>>  
>> -static const struct nf_logger __rcu *nf_loggers[NFPROTO_NUMPROTO] __read_mostly;
>>  static struct list_head nf_loggers_l[NFPROTO_NUMPROTO] __read_mostly;
>>  static DEFINE_MUTEX(nf_log_mutex);
>>  
>> @@ -32,13 +31,50 @@ static struct nf_logger *__find_logger(int pf, const char *str_logger)
>>  	return NULL;
>>  }
>>  
>> +void nf_log_set(struct net *net, u_int8_t pf, const struct nf_logger *logger)
>> +{
>> +	if (!net_eq(net, &init_net))
>> +		return;
>> +
>> +	if (pf != NFPROTO_UNSPEC) {
>> +		const struct nf_logger *log;
>> +		mutex_lock(&nf_log_mutex);
>> +		log = rcu_dereference_protected(net->nf.nf_loggers[pf],
>> +			lockdep_is_held(&nf_log_mutex));
>> +		if (log == NULL)
>> +			rcu_assign_pointer(net->nf.nf_loggers[pf], logger);
>> +
>> +		mutex_unlock(&nf_log_mutex);
>> +	}
>> +}
>> +EXPORT_SYMBOL(nf_log_set);
>> +
>> +void nf_log_unset(struct net *net, const struct nf_logger *logger)
>> +{
>> +	int i;
>> +	const struct nf_logger *log;
>> +
>> +	if (!net_eq(net, &init_net))
>> +		return;
>> +
>> +	mutex_lock(&nf_log_mutex);
>> +	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
>> +		log = rcu_dereference_protected(net->nf.nf_loggers[i],
>> +				lockdep_is_held(&nf_log_mutex));
>> +		if (log == logger)
>> +			RCU_INIT_POINTER(net->nf.nf_loggers[i], NULL);
>> +	}
>> +	mutex_unlock(&nf_log_mutex);
>> +	synchronize_rcu();
>> +}
>> +EXPORT_SYMBOL(nf_log_unset);
>> +
>>  /* return EEXIST if the same logger is registered, 0 on success. */
>>  int nf_log_register(u_int8_t pf, struct nf_logger *logger)
>>  {
>> -	const struct nf_logger *llog;
>>  	int i;
>>  
>> -	if (pf >= ARRAY_SIZE(nf_loggers))
>> +	if (pf >= ARRAY_SIZE(init_net.nf.nf_loggers))
>>  		return -EINVAL;
>>  
>>  	for (i = 0; i < ARRAY_SIZE(logger->list); i++)
>> @@ -52,63 +88,62 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
>>  	} else {
>>  		/* register at end of list to honor first register win */
>>  		list_add_tail(&logger->list[pf], &nf_loggers_l[pf]);
>> -		llog = rcu_dereference_protected(nf_loggers[pf],
>> -						 lockdep_is_held(&nf_log_mutex));
>> -		if (llog == NULL)
>> -			rcu_assign_pointer(nf_loggers[pf], logger);
>>  	}
>>  
>>  	mutex_unlock(&nf_log_mutex);
>>  
>> +	nf_log_set(&init_net, pf, logger);
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL(nf_log_register);
>>  
>>  void nf_log_unregister(struct nf_logger *logger)
>>  {
>> -	const struct nf_logger *c_logger;
>>  	int i;
>>  
>>  	mutex_lock(&nf_log_mutex);
>> -	for (i = 0; i < ARRAY_SIZE(nf_loggers); i++) {
>> -		c_logger = rcu_dereference_protected(nf_loggers[i],
>> -						     lockdep_is_held(&nf_log_mutex));
>> -		if (c_logger == logger)
>> -			RCU_INIT_POINTER(nf_loggers[i], NULL);
>> +	for (i = 0; i < NFPROTO_NUMPROTO; i++)
>>  		list_del(&logger->list[i]);
>> -	}
>>  	mutex_unlock(&nf_log_mutex);
>>  
>> -	synchronize_rcu();
>> +	nf_log_unset(&init_net, logger);
>>  }
>>  EXPORT_SYMBOL(nf_log_unregister);
>>  
>> -int nf_log_bind_pf(u_int8_t pf, const struct nf_logger *logger)
>> +int nf_log_bind_pf(struct net *net, u_int8_t pf,
>> +		   const struct nf_logger *logger)
>>  {
>> -	if (pf >= ARRAY_SIZE(nf_loggers))
>> +	if (!net_eq(net, &init_net))
>> +		return 0;
>> +
>> +	if (pf >= ARRAY_SIZE(net->nf.nf_loggers))
>>  		return -EINVAL;
>>  	mutex_lock(&nf_log_mutex);
>>  	if (__find_logger(pf, logger->name) == NULL) {
>>  		mutex_unlock(&nf_log_mutex);
>>  		return -ENOENT;
>>  	}
>> -	rcu_assign_pointer(nf_loggers[pf], logger);
>> +	rcu_assign_pointer(net->nf.nf_loggers[pf], logger);
>>  	mutex_unlock(&nf_log_mutex);
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL(nf_log_bind_pf);
>>  
>> -void nf_log_unbind_pf(u_int8_t pf)
>> +void nf_log_unbind_pf(struct net *net, u_int8_t pf)
>>  {
>> -	if (pf >= ARRAY_SIZE(nf_loggers))
>> +	if (!net_eq(net, &init_net))
>> +		return;
>> +
>> +	if (pf >= ARRAY_SIZE(net->nf.nf_loggers))
>>  		return;
>>  	mutex_lock(&nf_log_mutex);
>> -	RCU_INIT_POINTER(nf_loggers[pf], NULL);
>> +	RCU_INIT_POINTER(net->nf.nf_loggers[pf], NULL);
>>  	mutex_unlock(&nf_log_mutex);
>>  }
>>  EXPORT_SYMBOL(nf_log_unbind_pf);
>>  
>> -void nf_log_packet(u_int8_t pf,
>> +void nf_log_packet(struct net *net,
>> +		   u_int8_t pf,
>>  		   unsigned int hooknum,
>>  		   const struct sk_buff *skb,
>>  		   const struct net_device *in,
>> @@ -120,8 +155,11 @@ void nf_log_packet(u_int8_t pf,
>>  	char prefix[NF_LOG_PREFIXLEN];
>>  	const struct nf_logger *logger;
>>  
>> +	if (!net_eq(net, &init_net))
>> +		return;
>> +
>>  	rcu_read_lock();
>> -	logger = rcu_dereference(nf_loggers[pf]);
>> +	logger = rcu_dereference(net->nf.nf_loggers[pf]);
>>  	if (logger) {
>>  		va_start(args, fmt);
>>  		vsnprintf(prefix, sizeof(prefix), fmt, args);
>> @@ -135,9 +173,11 @@ EXPORT_SYMBOL(nf_log_packet);
>>  #ifdef CONFIG_PROC_FS
>>  static void *seq_start(struct seq_file *seq, loff_t *pos)
>>  {
>> +	struct net *net = seq_file_net(seq);
>> +
>>  	mutex_lock(&nf_log_mutex);
>>  
>> -	if (*pos >= ARRAY_SIZE(nf_loggers))
>> +	if (*pos >= ARRAY_SIZE(net->nf.nf_loggers))
>>  		return NULL;
>>  
>>  	return pos;
>> @@ -145,9 +185,11 @@ static void *seq_start(struct seq_file *seq, loff_t *pos)
>>  
>>  static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
>>  {
>> +	struct net *net = seq_file_net(s);
>> +
>>  	(*pos)++;
>>  
>> -	if (*pos >= ARRAY_SIZE(nf_loggers))
>> +	if (*pos >= ARRAY_SIZE(net->nf.nf_loggers))
>>  		return NULL;
>>  
>>  	return pos;
>> @@ -164,8 +206,9 @@ static int seq_show(struct seq_file *s, void *v)
>>  	const struct nf_logger *logger;
>>  	struct nf_logger *t;
>>  	int ret;
>> +	struct net *net = seq_file_net(s);
>>  
>> -	logger = rcu_dereference_protected(nf_loggers[*pos],
>> +	logger = rcu_dereference_protected(net->nf.nf_loggers[*pos],
>>  					   lockdep_is_held(&nf_log_mutex));
>>  
>>  	if (!logger)
>> @@ -199,7 +242,8 @@ static const struct seq_operations nflog_seq_ops = {
>>  
>>  static int nflog_open(struct inode *inode, struct file *file)
>>  {
>> -	return seq_open(file, &nflog_seq_ops);
>> +	return seq_open_net(inode, file, &nflog_seq_ops,
>> +			    sizeof(struct seq_net_private));
>>  }
>>  
>>  static const struct file_operations nflog_file_ops = {
>> @@ -207,7 +251,7 @@ static const struct file_operations nflog_file_ops = {
>>  	.open	 = nflog_open,
>>  	.read	 = seq_read,
>>  	.llseek	 = seq_lseek,
>> -	.release = seq_release,
>> +	.release = seq_release_net,
>>  };
>>  
>>  
>> @@ -216,7 +260,6 @@ static const struct file_operations nflog_file_ops = {
>>  #ifdef CONFIG_SYSCTL
>>  static char nf_log_sysctl_fnames[NFPROTO_NUMPROTO-NFPROTO_UNSPEC][3];
>>  static struct ctl_table nf_log_sysctl_table[NFPROTO_NUMPROTO+1];
>> -static struct ctl_table_header *nf_log_dir_header;
>>  
>>  static int nf_log_proc_dostring(ctl_table *table, int write,
>>  			 void __user *buffer, size_t *lenp, loff_t *ppos)
>> @@ -226,15 +269,19 @@ static int nf_log_proc_dostring(ctl_table *table, int write,
>>  	size_t size = *lenp;
>>  	int r = 0;
>>  	int tindex = (unsigned long)table->extra1;
>> +	struct net *net = current->nsproxy->net_ns;
>>  
>>  	if (write) {
>> +		if (!net_eq(net, &init_net))
>> +			return -EPERM;
>> +
>>  		if (size > sizeof(buf))
>>  			size = sizeof(buf);
>>  		if (copy_from_user(buf, buffer, size))
>>  			return -EFAULT;
>>  
>>  		if (!strcmp(buf, "NONE")) {
>> -			nf_log_unbind_pf(tindex);
>> +			nf_log_unbind_pf(net, tindex);
>>  			return 0;
>>  		}
>>  		mutex_lock(&nf_log_mutex);
>> @@ -243,11 +290,11 @@ static int nf_log_proc_dostring(ctl_table *table, int write,
>>  			mutex_unlock(&nf_log_mutex);
>>  			return -ENOENT;
>>  		}
>> -		rcu_assign_pointer(nf_loggers[tindex], logger);
>> +		rcu_assign_pointer(net->nf.nf_loggers[tindex], logger);
>>  		mutex_unlock(&nf_log_mutex);
>>  	} else {
>>  		mutex_lock(&nf_log_mutex);
>> -		logger = rcu_dereference_protected(nf_loggers[tindex],
>> +		logger = rcu_dereference_protected(net->nf.nf_loggers[tindex],
>>  						   lockdep_is_held(&nf_log_mutex));
>>  		if (!logger)
>>  			table->data = "NONE";
>> @@ -260,49 +307,111 @@ static int nf_log_proc_dostring(ctl_table *table, int write,
>>  	return r;
>>  }
>>  
>> -static __init int netfilter_log_sysctl_init(void)
>> +static int netfilter_log_sysctl_init(struct net *net)
>>  {
>>  	int i;
>> -
>> -	for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
>> -		snprintf(nf_log_sysctl_fnames[i-NFPROTO_UNSPEC], 3, "%d", i);
>> -		nf_log_sysctl_table[i].procname	=
>> -			nf_log_sysctl_fnames[i-NFPROTO_UNSPEC];
>> -		nf_log_sysctl_table[i].data = NULL;
>> -		nf_log_sysctl_table[i].maxlen =
>> -			NFLOGGER_NAME_LEN * sizeof(char);
>> -		nf_log_sysctl_table[i].mode = 0644;
>> -		nf_log_sysctl_table[i].proc_handler = nf_log_proc_dostring;
>> -		nf_log_sysctl_table[i].extra1 = (void *)(unsigned long) i;
>> +	struct ctl_table *table;
>> +
>> +	table = nf_log_sysctl_table;
>> +	if (!net_eq(net, &init_net)) {
>> +		table = kmemdup(nf_log_sysctl_table,
>> +				 sizeof(nf_log_sysctl_table),
>> +				 GFP_KERNEL);
>> +		if (!table)
>> +			goto err_alloc;
>> +	} else {
>> +		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
>> +			snprintf(nf_log_sysctl_fnames[i-NFPROTO_UNSPEC],
>> +				 3, "%d", i);
> 
> This is not your fault actually. While at it, I have removed
> -NFPROTO_UNSPEC (it's zero, so that substraction provides nothing).
> 

Ok,thanks for your work :)

>> +			nf_log_sysctl_table[i].procname	=
>> +				nf_log_sysctl_fnames[i-NFPROTO_UNSPEC];
>> +			nf_log_sysctl_table[i].data = NULL;
>> +			nf_log_sysctl_table[i].maxlen =
>> +				NFLOGGER_NAME_LEN * sizeof(char);
>> +			nf_log_sysctl_table[i].mode = 0644;
>> +			nf_log_sysctl_table[i].proc_handler =
>> +				nf_log_proc_dostring;
>> +			nf_log_sysctl_table[i].extra1 =
>> +				(void *)(unsigned long) i;
>> +		}
>>  	}
>>  
>> -	nf_log_dir_header = register_net_sysctl(&init_net, "net/netfilter/nf_log",
>> -				       nf_log_sysctl_table);
>> -	if (!nf_log_dir_header)
>> -		return -ENOMEM;
>> +	net->nf.nf_log_dir_header = register_net_sysctl(net,
>> +						"net/netfilter/nf_log",
>> +						table);
>> +	if (!net->nf.nf_log_dir_header)
>> +		goto err_reg;
>>  
>>  	return 0;
>> +err_reg:
>> +	if (!net_eq(net, &init_net))
>> +		kfree(table);
>> +err_alloc:
>> +	return -ENOMEM;
>> +}
>> +
>> +static void netfilter_log_sysctl_exit(struct net *net)
>> +{
>> +	struct ctl_table *table;
>> +
>> +	table = net->nf.nf_log_dir_header->ctl_table_arg;
>> +	unregister_net_sysctl_table(net->nf.nf_log_dir_header);
>> +	if (!net_eq(net, &init_net))
>> +		kfree(table);
>>  }
>>  #else
>> -static __init int netfilter_log_sysctl_init(void)
>> +static int netfilter_log_sysctl_init(struct net *net)
>>  {
>>  	return 0;
>>  }
>> +
>> +static void netfilter_log_sysctl_exit(struct net *net)
>> +{
>> +}
>>  #endif /* CONFIG_SYSCTL */
>>  
>> -int __init netfilter_log_init(void)
>> +static int __net_init nf_log_net_init(struct net *net)
>>  {
>> -	int i, r;
>> +	int ret = -ENOMEM;
>>  #ifdef CONFIG_PROC_FS
>>  	if (!proc_create("nf_log", S_IRUGO,
>> -			 proc_net_netfilter, &nflog_file_ops))
>> -		return -1;
>> +			 net->nf.proc_netfilter, &nflog_file_ops))
>> +		goto out_proc;
>>  #endif
>> +	ret = netfilter_log_sysctl_init(net);
>> +	if (ret < 0)
>> +		goto out_sysctl;
>> +	return 0;
>> +out_sysctl:
>> +#ifdef CONFIG_PROC_FS
> 
> removed this ifdef. The function remove_proc_entry already defines an
> empty function if CONFIG_PROC_FS is not set.
> 

Thanks for the hand.

>> +	/*
>> +	 * For init net, Erros will trigger panic,
>> +	 * unrool on error is unnecessary,
>> +	 */
> 
> Fixed English typos in this sentence.
> 
>> +	if (!net_eq(net, &init_net))
>> +		remove_proc_entry("nf_log", net->nf.proc_netfilter);
>> +out_proc:
>> +#endif
>> +	return ret;
>> +}
>> +
>> +static void __net_exit nf_log_net_exit(struct net *net)
>> +{
>> +	netfilter_log_sysctl_exit(net);
>> +	remove_proc_entry("nf_log", net->nf.proc_netfilter);
>> +}
>>  
>> -	/* Errors will trigger panic, unroll on error is unnecessary. */
>> -	r = netfilter_log_sysctl_init();
>> -	if (r < 0)
>> -		return r;
>> +static struct pernet_operations nf_log_net_ops = {
>> +	.init = nf_log_net_init,
>> +	.exit = nf_log_net_exit,
>> +};
>> +
>> +int __init netfilter_log_init(void)
>> +{
>> +	int i, ret;
> 
> Please, add empty line after variable declaration next time.
> 

Thanks again, I must miss this place...

Thanks!
