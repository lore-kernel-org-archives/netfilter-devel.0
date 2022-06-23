Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9CBC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 19:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiFWTkM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 15:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiFWTj6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 15:39:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A708427B0F
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 12:29:22 -0700 (PDT)
Date:   Thu, 23 Jun 2022 21:29:19 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Subject: Re: [PATCH 4/6] conntrack: fix protocol number parsing
Message-ID: <YrS/DwKyTUQ7oFyk@salvia>
References: <20220623175000.49259-1-mikhail.sennikovskii@ionos.com>
 <20220623175000.49259-5-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220623175000.49259-5-mikhail.sennikovskii@ionos.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 23, 2022 at 07:49:58PM +0200, Mikhail Sennikovsky wrote:
> Before this commit it was possible to successfully create a ct entry
> passing -p 256 and -p some_nonsense.
> In both cases an entry with the protocol=0 would be created.
> 
> Do not allow invalid protocol values to -p option.
> 
> Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
> ---
>  src/conntrack.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/src/conntrack.c b/src/conntrack.c
> index 500e736..dca7da6 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -882,6 +882,24 @@ static int ct_save_snprintf(char *buf, size_t len,
>  
>  extern struct ctproto_handler ct_proto_unknown;
>  
> +static int parse_proto_num(const char *str)
> +{
> +	char *endptr;
> +	long val;
> +
> +	errno = 0;
> +	val = strtol(str, &endptr, 0);
> +	if ((errno == ERANGE && (val == LONG_MAX || val == LONG_MIN)) ||
> +	    (errno != 0 && val == 0) ||
> +	    endptr == str ||
> +	    *endptr != '\0' ||
> +	    val >= IPPROTO_MAX) {

There might be a more simple way to do error reporting for strtoul?

> +		return -1;
> +	}
> +
> +	return val;
> +}
> +
>  static struct ctproto_handler *findproto(char *name, int *pnum)
>  {
>  	struct ctproto_handler *cur;
> @@ -901,8 +919,8 @@ static struct ctproto_handler *findproto(char *name, int *pnum)
>  		return &ct_proto_unknown;
>  	}
>  	/* using a protocol number? */
> -	protonum = atoi(name);
> -	if (protonum >= 0 && protonum <= IPPROTO_MAX) {
> +	protonum = parse_proto_num(name);
> +	if (protonum >= 0) {
>  		/* try lookup by number, perhaps this protocol is supported */
>  		list_for_each_entry(cur, &proto_list, head) {
>  			if (cur->protonum == protonum) {
> -- 
> 2.25.1
> 
