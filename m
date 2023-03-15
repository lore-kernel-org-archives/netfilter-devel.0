Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F26C61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Mar 2023 21:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjCOVox (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Mar 2023 17:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbjCOVov (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2023 17:44:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65D161AA7
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2023 14:44:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pcYvP-0000uK-PZ; Wed, 15 Mar 2023 22:44:47 +0100
Date:   Wed, 15 Mar 2023 22:44:47 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ulogd2 v2] pcap: prevent crashes when output `FILE *` is
 null
Message-ID: <ZBI8T5tl2eXKIrHf@strlen.de>
References: <20230102121941.105586-1-jeremy@azazel.net>
 <20230112180204.761520-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112180204.761520-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> If ulogd2 receives a signal it will attempt to re-open the pcap output
> file.  If this fails (because the permissions or ownership have changed
> for example), the FILE pointer will be null and when the next packet
> comes in, the null pointer will be passed to fwrite and ulogd will
> crash.
> 
> Instead, check that the pointer is not null before using it.  If it is
> null, then periodically attempt to open it again.  We only return an
> error from interp_pcap on those occasions when we try and fail to open
> the output file, in order to avoid spamming the ulogd log-file every
> time a packet isn't written.
> 
> Link: https://bugs.launchpad.net/ubuntu/+source/ulogd2/+bug/1429778
>
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  Change since v1: correct subject-prefix.
>  
>  output/pcap/ulogd_output_PCAP.c | 49 +++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
> index e7798f20c8fc..5b2ca64d3393 100644
> --- a/output/pcap/ulogd_output_PCAP.c
> +++ b/output/pcap/ulogd_output_PCAP.c
> @@ -82,6 +82,8 @@ struct pcap_sf_pkthdr {
>  #define ULOGD_PCAP_SYNC_DEFAULT	0
>  #endif
>  
> +#define MAX_OUTFILE_CHECK_DELTA 64
> +
>  #define NIPQUAD(addr) \
>  	((unsigned char *)&addr)[0], \
>  	((unsigned char *)&addr)[1], \
> @@ -107,6 +109,7 @@ static struct config_keyset pcap_kset = {
>  };
>  
>  struct pcap_instance {
> +	time_t last_outfile_check, next_outfile_check_delta;
>  	FILE *of;
>  };
>  
> @@ -142,12 +145,53 @@ static struct ulogd_key pcap_keys[INTR_IDS] = {
>  
>  #define GET_FLAGS(res, x)	(res[x].u.source->flags)
>  
> +static int append_create_outfile(struct ulogd_pluginstance *);
> +
> +static int
> +check_outfile(struct ulogd_pluginstance *upi)
> +{
> +	struct pcap_instance *pi = (struct pcap_instance *) &upi->private;
> +	time_t now;
> +	int ret;
> +
> +	if (pi->of)
> +		return 0;

I think its better to fix this at the source, i.e. in
signal_handler_task().  It should probably *first* try to open the file,
and only close the old one if that worked.

Does that make sense to you?
