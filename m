Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63C8C6FD1F
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Mar 2023 19:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCPTCl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCPTCk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Mar 2023 15:02:40 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED38DE2502
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Mar 2023 12:02:19 -0700 (PDT)
Date:   Thu, 16 Mar 2023 20:02:15 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ulogd2 v3 1/2] pcap: simplify opening of output file
Message-ID: <ZBNnt5POeEw1sr0v@salvia>
References: <20230316110754.260967-1-jeremy@azazel.net>
 <20230316110754.260967-2-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230316110754.260967-2-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 16, 2023 at 11:07:53AM +0000, Jeremy Sowden wrote:
> Instead of statting the file, and choosing the mode with which to open
> it and whether to write the PCAP header based on the result, always open
> it with mode "a" and _then_ stat it.  This simplifies the flow-control
> and avoids a race between statting and opening.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  output/pcap/ulogd_output_PCAP.c | 42 ++++++++++++---------------------
>  1 file changed, 15 insertions(+), 27 deletions(-)
> 
> diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
> index e7798f20c8fc..220fc6dec5fe 100644
> --- a/output/pcap/ulogd_output_PCAP.c
> +++ b/output/pcap/ulogd_output_PCAP.c
> @@ -220,33 +220,21 @@ static int append_create_outfile(struct ulogd_pluginstance *upi)
>  {
>  	struct pcap_instance *pi = (struct pcap_instance *) &upi->private;
>  	char *filename = upi->config_kset->ces[0].u.string;
> -	struct stat st_dummy;
> -	int exist = 0;
> -
> -	if (stat(filename, &st_dummy) == 0 && st_dummy.st_size > 0)
> -		exist = 1;
> -
> -	if (!exist) {
> -		pi->of = fopen(filename, "w");
> -		if (!pi->of) {
> -			ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n",
> -				  filename,
> -				  strerror(errno));
> -			return -EPERM;
> -		}
> -		if (!write_pcap_header(pi)) {
> -			ulogd_log(ULOGD_ERROR, "can't write pcap header: %s\n",
> -				  strerror(errno));
> -			return -ENOSPC;
> -		}
> -	} else {
> -		pi->of = fopen(filename, "a");
> -		if (!pi->of) {
> -			ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n", 
> -				filename,
> -				strerror(errno));
> -			return -EPERM;
> -		}		
> +	struct stat st_of;
> +
> +	pi->of = fopen(filename, "a");
> +	if (!pi->of) {
> +		ulogd_log(ULOGD_ERROR, "can't open pcap file %s: %s\n",
> +			  filename,
> +			  strerror(errno));
> +		return -EPERM;
> +	}
> +	if (fstat(fileno(pi->of), &st_of) == 0 && st_of.st_size == 0) {
> +	    if (!write_pcap_header(pi)) {
        ^^^^
coding style nitpick, it can be fixed before applying it.

> +		    ulogd_log(ULOGD_ERROR, "can't write pcap header: %s\n",
> +			      strerror(errno));
> +		    return -ENOSPC;
> +	    }
>  	}
>  
>  	return 0;
> -- 
> 2.39.2
> 
