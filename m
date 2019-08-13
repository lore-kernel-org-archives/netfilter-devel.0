Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701DAC32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D84A20665
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfHMTKK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 15:10:10 -0400
Received: from correo.us.es ([193.147.175.20]:35478 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbfHMTKJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 15:10:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 34C3CDA73F
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:10:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26607DA7E1
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:10:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1C2A4DA72F; Tue, 13 Aug 2019 21:10:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15F9ADA72F;
        Tue, 13 Aug 2019 21:10:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 21:10:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E27D94265A2F;
        Tue, 13 Aug 2019 21:10:04 +0200 (CEST)
Date:   Tue, 13 Aug 2019 21:10:04 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] netfilter: nft_meta: support for time matching
Message-ID: <20190813191004.jltzdpmcagp443pm@salvia>
References: <20190813183820.6659-1-a@juaristi.eus>
 <20190813183820.6659-2-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813183820.6659-2-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Just a few nitpicks and we go :-)

On Tue, Aug 13, 2019 at 08:38:20PM +0200, Ander Juaristi wrote:
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 82abaa183fc3..67ae55e08518 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -799,6 +799,9 @@ enum nft_exthdr_attributes {
>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
>   * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
>   * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
> + * @NFT_META_TIME: a UNIX timestamp

    * @NFT_META_TIME: time since 1970 (in nanoseconds)

Probably rename this to NFT_META_TIME_NS I'd suggest.

> + * @NFT_META_TIME_DAY: day of week

  + * @NFT_META_TIME_DAY: day of week (from 0 = Sunday to 6 = Saturday)

> + * @NFT_META_TIME_HOUR: hour of day

  + * @NFT_META_TIME_HOUR: hour of the day (in seconds)

>   */
>  enum nft_meta_keys {
>  	NFT_META_LEN,
> @@ -831,6 +834,9 @@ enum nft_meta_keys {
>  	NFT_META_OIFKIND,
>  	NFT_META_BRI_IIFPVID,
>  	NFT_META_BRI_IIFVPROTO,
> +	NFT_META_TIME,
> +	NFT_META_TIME_DAY,
> +	NFT_META_TIME_HOUR,
>  };
>  
>  /**
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index f1b1d948c07b..3e665a1a744a 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -28,6 +28,27 @@
>  
>  static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);

Probably a few constant definitions to be used in nft_meta_weekday().

#define NFT_NETA_SECS_PER_MINUTE        60
#define NFT_META_SECS_PER_HOUR          3600
#define NFT_META_SECS_PER_DAY           86400
#define NFT_META_DAYS_PER_WEEK          7

these numbers are easy to guess, but this helps along time to read
this code.

> +static u8 nft_meta_weekday(unsigned long secs)
> +{
> +	u8 wday;
> +	unsigned int dse;

Reverse definition, from longest to shortest line:

	unsigned int dse;
	u8 wday;

> +	secs -= 60 * sys_tz.tz_minuteswest;
> +	dse = secs / 86400;
> +	wday = (4 + dse) % 7;
> +
> +	return wday;
> +}
> +
> +static u32 nft_meta_hour(unsigned long secs)
> +{
> +	struct tm tm;
> +
> +	time64_to_tm(secs, 0, &tm);
> +
> +	return tm.tm_hour * 3600 + tm.tm_min * 60 + tm.tm_sec;
> +}
> +
>  void nft_meta_get_eval(const struct nft_expr *expr,
>  		       struct nft_regs *regs,
>  		       const struct nft_pktinfo *pkt)
> @@ -226,6 +247,15 @@ void nft_meta_get_eval(const struct nft_expr *expr,
>  			goto err;
>  		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
>  		break;
> +	case NFT_META_TIME:
> +		nft_reg_store64(dest, ktime_get_real_ns());
> +		break;
> +	case NFT_META_TIME_DAY:
> +		nft_reg_store8(dest, nft_meta_weekday(get_seconds()));
> +		break;
> +	case NFT_META_TIME_HOUR:
> +		*dest = nft_meta_hour(get_seconds());
> +		break;
>  	default:
>  		WARN_ON(1);
>  		goto err;
> @@ -338,6 +368,15 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
>  		len = sizeof(u8);
>  		break;
>  #endif
> +	case NFT_META_TIME:
> +		len = sizeof(u64);
> +		break;
> +	case NFT_META_TIME_DAY:
> +		len = sizeof(u8);
> +		break;
> +	case NFT_META_TIME_HOUR:
> +		len = sizeof(u32);
> +		break;
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> -- 
> 2.17.1
> 
