From: Eric Leblond <eric@regit.org>
Subject: Re: [ulogd PATCH 12/13] nfct: introduce new out keys for ipfix
 timestamp
Date: Sun, 01 Jun 2014 12:28:32 +0200
Message-ID: <1401618512.2562.3.camel@ice-age2.regit.org>
References: <20140308010344.GA4415@gmail.com>
	 <20140428113936.GA12523@gmail.com> <20140428115621.GM12523@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:38027 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaFAK2m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2014 06:28:42 -0400
In-Reply-To: <20140428115621.GM12523@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

First of all, sorry for the delay in the review. Don't hesitate to ping
me back to speed up the answer.

I'm agree with most of your patches but not with this one:
      * It causes useless computation for most output supporting NFCT
        (which don't use this value).
      * It will also cause the log all keys module like JSON to log a
        supplementary (ad useless) fields

It will be better to introduce a new filter module. That will produce
the wanted key from the existing timestamp key.

On Mon, 2014-04-28 at 20:56 +0900, Ken-ichirou MATSUZAWA wrote:
> Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  input/flow/ulogd_inpflow_NFCT.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
> index 4f4301e..b31c46f 100644
> --- a/input/flow/ulogd_inpflow_NFCT.c
> +++ b/input/flow/ulogd_inpflow_NFCT.c
> @@ -186,8 +186,10 @@ enum nfct_keys {
>  	NFCT_CT_EVENT,
>  	NFCT_FLOW_START_SEC,
>  	NFCT_FLOW_START_USEC,
> +	NFCT_FLOW_START_MCSEC,
>  	NFCT_FLOW_END_SEC,
>  	NFCT_FLOW_END_USEC,
> +	NFCT_FLOW_END_MCSEC,
>  	NFCT_OOB_FAMILY,
>  	NFCT_OOB_PROTOCOL,
>  	NFCT_CT,
> @@ -379,6 +381,11 @@ static struct ulogd_key nfct_okeys[] = {
>  		.type 	= ULOGD_RET_UINT32,
>  		.flags 	= ULOGD_RETF_NONE,
>  		.name	= "flow.start.usec",
> +	},
> +	{
> +		.type 	= ULOGD_RET_UINT64,
> +		.flags 	= ULOGD_RETF_NONE,
> +		.name	= "flow.start.mcsec",
>  		.ipfix	= {
>  			.vendor		= IPFIX_VENDOR_IETF,
>  			.field_id	= IPFIX_flowStartMicroSeconds,
> @@ -397,6 +404,11 @@ static struct ulogd_key nfct_okeys[] = {
>  		.type	= ULOGD_RET_UINT32,
>  		.flags	= ULOGD_RETF_NONE,
>  		.name	= "flow.end.usec",
> +	},
> +	{
> +		.type	= ULOGD_RET_UINT64,
> +		.flags	= ULOGD_RETF_NONE,
> +		.name	= "flow.end.mcsec",
>  		.ipfix	= {
>  			.vendor		= IPFIX_VENDOR_IETF,
>  			.field_id	= IPFIX_flowEndMicroSeconds,
> @@ -485,6 +497,13 @@ static int compare(const void *data1, const void *data2)
>  	return nfct_cmp(u1->ct, ct, NFCT_CMP_ORIG | NFCT_CMP_REPL);
>  }
>  
> +static inline uint64_t tv2ntp(const struct timeval t)
> +{
> +	/* RFC7101 - 6.1.10. dateTimeNanoseconds */
> +	return (uint64_t) (t.tv_sec << 32)
> +		+ (t.tv_usec << 32) / (NSEC_PER_SEC / 1000);
> +}
> +
>  /* only the main_upi plugin instance contains the correct private data. */
>  static int propagate_ct(struct ulogd_pluginstance *main_upi,
>  			struct ulogd_pluginstance *upi,
> @@ -579,12 +598,16 @@ static int propagate_ct(struct ulogd_pluginstance *main_upi,
>  				     ts->time[START].tv_sec);
>  			okey_set_u32(&ret[NFCT_FLOW_START_USEC],
>  				     ts->time[START].tv_usec);
> +			okey_set_u64(&ret[NFCT_FLOW_START_MCSEC],
> +				     tv2ntp(ts->time[START]));
>  		}
>  		if (ts->time[STOP].tv_sec) {
>  			okey_set_u32(&ret[NFCT_FLOW_END_SEC],
>  				     ts->time[STOP].tv_sec);
>  			okey_set_u32(&ret[NFCT_FLOW_END_USEC],
>  				     ts->time[STOP].tv_usec);
> +			okey_set_u64(&ret[NFCT_FLOW_END_MCSEC],
> +				     tv2ntp(ts->time[STOP]));
>  		}
>  	}
>  	okey_set_ptr(&ret[NFCT_CT], cpi->ct);


BR,
-- 
Eric Leblond <eric@regit.org>

