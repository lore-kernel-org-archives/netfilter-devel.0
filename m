From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] netfilter: use IS_ENABLED() macro
Date: Mon, 30 Jun 2014 08:56:44 +0800
Message-ID: <53B0B5CC.5060406@cn.fujitsu.com>
References: <53AD0623.5090104@cn.fujitsu.com> <20140627105018.GA6058@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6384 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753316AbaF3BAN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Jun 2014 21:00:13 -0400
In-Reply-To: <20140627105018.GA6058@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/27/2014 06:50 PM, Pablo Neira Ayuso wrote:
> On Fri, Jun 27, 2014 at 01:50:27PM +0800, Duan Jiong wrote:
>>
>> replace:
>>  #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
>> with
>>  #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
> 
> Could you also send a new version including these?

ok, i will send v2 patch.

Thanks,
  Duan

> 
> net/ipv4/netfilter/nf_defrag_ipv4.c:#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
> net/ipv4/netfilter/nf_defrag_ipv4.c:#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
> net/ipv4/netfilter/nf_defrag_ipv4.c:#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
> net/ipv4/netfilter/nf_defrag_ipv4.c:#if !defined(CONFIG_NF_NAT) && !defined(CONFIG_NF_NAT_MODULE)
> 
> Thanks.
> 

