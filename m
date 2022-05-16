Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA02CC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 16:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiEPQL4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 12:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245722AbiEPQLy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 12:11:54 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23614381BD
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 09:11:52 -0700 (PDT)
Date:   Mon, 16 May 2022 18:11:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] conntrack: remove -o userspace
Message-ID: <YoJ3xRq89iVuUC1M@salvia>
References: <20220516153901.173460-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220516153901.173460-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 16, 2022 at 05:39:01PM +0200, Florian Westphal wrote:
> This flag makes life a lot harder because lack of the flag hides
> very useful information.  Remove it and always tag events triggered
> by userspace flush.
> 
> Option is still parsed for backwards compatibility sake.

OK, if you prefer it this way.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  conntrack.8     | 2 +-
>  src/conntrack.c | 7 +++----
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/conntrack.8 b/conntrack.8
> index c3214ee0c886..0db427b7b9ea 100644
> --- a/conntrack.8
> +++ b/conntrack.8
> @@ -114,7 +114,7 @@ Load entries from a given file. To read from stdin, "\-" should be specified.
>  Atomically zero counters after reading them.  This option is only valid in
>  combination with the "\-L, \-\-dump" command options.
>  .TP
> -.BI "-o, --output [extended,xml,save,timestamp,id,ktimestamp,labels,userspace] "
> +.BI "-o, --output [extended,xml,save,timestamp,id,ktimestamp,labels] "
>  Display output in a certain format. With the extended output option, this tool
>  displays the layer 3 information. With ktimestamp, it displays the in-kernel
>  timestamp available since 2.6.38 (you can enable it via the \fBsysctl(8)\fP
> diff --git a/src/conntrack.c b/src/conntrack.c
> index a77354344290..bd02b139dc97 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -1128,8 +1128,7 @@ enum {
>  	_O_ID	= (1 << 3),
>  	_O_KTMS	= (1 << 4),
>  	_O_CL	= (1 << 5),
> -	_O_US	= (1 << 6),
> -	_O_SAVE	= (1 << 7),
> +	_O_SAVE	= (1 << 6),
>  };
>  
>  enum {
> @@ -1149,7 +1148,7 @@ static struct parse_parameter {
>  	{ {"ALL", "NEW", "UPDATES", "DESTROY"}, 4,
>  	  { CT_EVENT_F_ALL, CT_EVENT_F_NEW, CT_EVENT_F_UPD, CT_EVENT_F_DEL } },
>  	{ {"xml", "extended", "timestamp", "id", "ktimestamp", "labels", "userspace", "save"}, 8,
> -	  { _O_XML, _O_EXT, _O_TMS, _O_ID, _O_KTMS, _O_CL, _O_US, _O_SAVE },
> +	  { _O_XML, _O_EXT, _O_TMS, _O_ID, _O_KTMS, _O_CL, 0, _O_SAVE },
>  	},
>  };
>  
> @@ -1978,7 +1977,7 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
>  
>  	nfct_snprintf_labels(buf, sizeof(buf), ct, type, op_type, op_flags, labelmap);
>  done:
> -	if ((output_mask & _O_US) && nlh->nlmsg_pid) {
> +	if (nlh->nlmsg_pid) {
>  		char *prog = get_progname(nlh->nlmsg_pid);
>  
>  		if (prog)
> -- 
> 2.35.3
> 
