Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A7CC43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 02:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C67E820673
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 02:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfFXC3y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Jun 2019 22:29:54 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50384 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727095AbfFXC3y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Jun 2019 22:29:54 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hfBzR-00051G-EK; Mon, 24 Jun 2019 01:33:41 +0200
Date:   Mon, 24 Jun 2019 01:33:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] meta: Introduce new conditions 'time', 'day' and
 'hour'
Message-ID: <20190623233341.qdltyw2iaepkp5kp@breakpoint.cc>
References: <20190623162544.11604-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623162544.11604-1-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> These keywords introduce new checks for a timestamp, an absolute date (which is converted to a timestamp),
> an hour in the day (which is converted to the number of seconds since midnight) and a day of week.
> 
> When converting an ISO date (eg. 2019-06-06 17:00) to a timestamp,
> we need to substract it the GMT difference in seconds, that is, the value
> of the 'tm_gmtoff' field in the tm structure. This is because the kernel
> doesn't know about time zones. And hence the kernel manages different timestamps
> than those that are advertised in userspace when running, for instance, date +%s.
> 
> The same conversion needs to be done when converting hours (e.g 17:00) to seconds since midnight
> as well.
> 
> We also introduce a new command line option (-t, --seconds) to show the actual
> timestamps when printing the values, rather than the ISO dates, or the hour.
> 
> Some usage examples:
> 
> 	time < "2019-06-06 17:00" drop;
> 	time < "2019-06-06 17:20:20" drop;
> 	time < 12341234 drop;
> 	day "Sat" drop;
> 	day 6 drop;
> 	hour >= 17:00 drop;
> 	hour >= "17:00:01" drop;
> 	hour >= 63000 drop;
> 
> Signed-off-by: Ander Juaristi <a@juaristi.eus>
> ---
>  include/datatype.h                  |   3 +
>  include/linux/netfilter/nf_tables.h |   6 +
>  include/meta.h                      |   3 +
>  include/nftables.h                  |   5 +
>  include/nftables/libnftables.h      |   1 +
>  src/datatype.c                      |   3 +
>  src/main.c                          |  11 +-
>  src/meta.c                          | 286 ++++++++++++++++++++++++++++
>  src/parser_bison.y                  |   4 +
>  src/scanner.l                       |   4 +-
>  10 files changed, 324 insertions(+), 2 deletions(-)
> 
> diff --git a/include/datatype.h b/include/datatype.h
> index 63617eb..a102f3f 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -90,6 +90,9 @@ enum datatypes {
>  	TYPE_CT_EVENTBIT,
>  	TYPE_IFNAME,
>  	TYPE_IGMP_TYPE,
> +	TYPE_TIME_TYPE,
> +	TYPE_HOUR_TYPE,
> +	TYPE_DAY_TYPE,
>  	__TYPE_MAX
>  };
>  #define TYPE_MAX		(__TYPE_MAX - 1)
> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> index 7bdb234..ce621ed 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
> @@ -793,6 +793,9 @@ enum nft_exthdr_attributes {
>   * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
>   * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
> + * @NFT_META_TIME: a UNIX timestamp
> + * @NFT_META_TIME_DAY: day of week
> + * @NFT_META_TIME_HOUR: hour of day
>   */
>  enum nft_meta_keys {
>  	NFT_META_LEN,
> @@ -823,6 +826,9 @@ enum nft_meta_keys {
>  	NFT_META_SECPATH,
>  	NFT_META_IIFKIND,
>  	NFT_META_OIFKIND,
> +	NFT_META_TIME,
> +	NFT_META_TIME_DAY,
> +	NFT_META_TIME_HOUR,
>  };
>  
>  /**
> diff --git a/include/meta.h b/include/meta.h
> index a49b4ff..a62a130 100644
> --- a/include/meta.h
> +++ b/include/meta.h
> @@ -41,6 +41,9 @@ extern const struct datatype uid_type;
>  extern const struct datatype devgroup_type;
>  extern const struct datatype pkttype_type;
>  extern const struct datatype ifname_type;
> +extern const struct datatype date_type;
> +extern const struct datatype hour_type;
> +extern const struct datatype day_type;
>  
>  extern struct symbol_table *devgroup_tbl;
>  
> diff --git a/include/nftables.h b/include/nftables.h
> index ed446e2..52aff12 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -62,6 +62,11 @@ static inline bool nft_output_guid(const struct output_ctx *octx)
>  	return octx->flags & NFT_CTX_OUTPUT_GUID;
>  }
>  
> +static inline bool nft_output_seconds(const struct output_ctx *octx)
> +{
> +	return octx->flags & NFT_CTX_OUTPUT_SECONDS;
> +}
> +
>  static inline bool nft_output_numeric_proto(const struct output_ctx *octx)
>  {
>  	return octx->flags & NFT_CTX_OUTPUT_NUMERIC_PROTO;
> diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
> index e39c588..87d4ff5 100644
> --- a/include/nftables/libnftables.h
> +++ b/include/nftables/libnftables.h
> @@ -52,6 +52,7 @@ enum {
>  	NFT_CTX_OUTPUT_NUMERIC_PROTO	= (1 << 7),
>  	NFT_CTX_OUTPUT_NUMERIC_PRIO     = (1 << 8),
>  	NFT_CTX_OUTPUT_NUMERIC_SYMBOL	= (1 << 9),
> +	NFT_CTX_OUTPUT_SECONDS          = (1 << 10),
>  	NFT_CTX_OUTPUT_NUMERIC_ALL	= (NFT_CTX_OUTPUT_NUMERIC_PROTO |
>  					   NFT_CTX_OUTPUT_NUMERIC_PRIO |
>  					   NFT_CTX_OUTPUT_NUMERIC_SYMBOL),
> diff --git a/src/datatype.c b/src/datatype.c
> index 6d6826e..2ee7a8f 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -71,6 +71,9 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
>  	[TYPE_BOOLEAN]		= &boolean_type,
>  	[TYPE_IFNAME]		= &ifname_type,
>  	[TYPE_IGMP_TYPE]	= &igmp_type_type,
> +	[TYPE_TIME_TYPE]	= &date_type,
> +	[TYPE_HOUR_TYPE]	= &hour_type,
> +	[TYPE_DAY_TYPE]		= &day_type,

TYPE_FOO_TYPE looks weird, maybe use

TYPE_TIME_DATE
TYPE_TIME_HOUR
TYPE_TIME_DAY

?

> +static void day_type_print(const struct expr *expr, struct output_ctx *octx)
> +{
> +	const char *days[] = {
> +		"Sunday",
> +		"Monday",
> +		"Tuesday",
> +		"Wednesday",
> +		"Thursday",
> +		"Friday",
> +		"Saturday"
> +	};
> +	uint8_t daynum = mpz_get_uint8(expr->value),
> +		 numdays = sizeof(days) / (3 * 3);

numdays = array_size(days) ?

> +#define MIN(a, b) (a < b ? a : b)

There is min() in include/utils.h.

	> +	};
> +	int daynum = -1, numdays = (sizeof(days) / 7) - 1;

numdays = array_size(days)

> +static void __hour_type_print_r(int hours, int minutes, int seconds, char *out)
> +{
> +	if (minutes == 60)
> +		return __hour_type_print_r(++hours, 0, seconds, out);
> +	else if (minutes > 60)
> +		return __hour_type_print_r((int) (minutes / 60), minutes % 60, seconds, out);
> +
> +	if (seconds == 60)
> +		return __hour_type_print_r(hours, ++minutes, 0, out);
> +	else if (seconds > 60)
> +		return __hour_type_print_r(hours, (int) (seconds / 60), seconds % 60, out);
> +
> +	if (seconds == 0)
> +		snprintf(out, 6, "%02d:%02d", hours, minutes);
> +	else
> +		snprintf(out, 9, "%02d:%02d:%02d", hours, minutes, seconds);
> +}

I think it would be preferrable to pass a size_t buflen here and use
that rather than the magic buffer sizes in snrintf().

> +const struct datatype date_type = {
> +	.type = TYPE_TIME_TYPE,
> +	.name = "time",
> +	.desc = "Relative time of packet reception",
> +	.byteorder = BYTEORDER_HOST_ENDIAN,
> +	.size = 8 * BITS_PER_BYTE,

Probably better to use sizeof(uint64_t) * BITS_PER_BYTE here.

Otherwise this looks good to me.  Once libnftnl support is ready and the
grammar accepted we also need an update to the documentation and a few
test cases for this. (in tests/py/ ).
