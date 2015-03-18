From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] Add revision field for xt_entry_target
Date: Wed, 18 Mar 2015 10:44:49 +0100
Message-ID: <20150318094449.GA7279@salvia>
References: <A43879EB4A7F5F449E2CA8148EA79E516C88A2@G08CNEXMBPEKD01.g08.fujitsu.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Zhang, Chunyu" <zhangcy@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60863 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbbCRJk7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2015 05:40:59 -0400
Content-Disposition: inline
In-Reply-To: <A43879EB4A7F5F449E2CA8148EA79E516C88A2@G08CNEXMBPEKD01.g08.fujitsu.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 18, 2015 at 02:47:33AM +0000, Zhang, Chunyu wrote:
> >> diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
> >> index 0acda66..ccf8cd0 100644
> >> --- a/include/linux/netfilter_arp/arp_tables.h
> >> +++ b/include/linux/netfilter_arp/arp_tables.h
> >> @@ -19,7 +19,7 @@
> >> 
> >>  #include <linux/netfilter_arp.h>
> >> 
> >> -#define ARPT_FUNCTION_MAXNAMELEN 30
> >> +#define ARPT_FUNCTION_MAXNAMELEN 29
> >>  #define ARPT_TABLE_MAXNAMELEN 32
> >> 
> >>  #define ARPT_DEV_ADDR_LEN_MAX 16
> >> @@ -69,6 +69,8 @@ struct arpt_entry_target
> >> 
> >>                      /* Used by userspace */
> >>                      char name[ARPT_FUNCTION_MAXNAMELEN];
> >> +
> >> +                    u_int8_t revision;
> >
> >This structure is not exposed to userspace and I don't find any client
> >of it in this code:
> >
> >include/uapi/linux/netfilter_arp/arp_tables.h:#define arpt_entry_target xt_entry_target
> >
> >and arp_tables uses xt_entry_target all the time.
>
> revision is used to mark_tg in kernel file : kernel-3.14/net/netfilter/xt_mark.c

Forget it, I got confused by the net/netfilter/xt_repldata.h trickery,
sorry. Please, resubmit this patch once you have extended the
userspace arp mark extension to exactly mirror what mark can do in
iptables/ip6tables.

Thanks.
