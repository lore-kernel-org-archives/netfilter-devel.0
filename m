Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCF9C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 19:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E883D20685
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 19:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfCRTlp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:41:45 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59213 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727610AbfCRTlp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 15:41:45 -0400
Received: from cpe-2606-a000-111b-405a-9816-2c85-c514-8f7a.dyn6.twc.com ([2606:a000:111b:405a:9816:2c85:c514:8f7a] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1h5y8f-0000mt-Co; Mon, 18 Mar 2019 15:41:39 -0400
Date:   Mon, 18 Mar 2019 15:41:09 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com
Subject: Re: [PATCH ghak90 V5 07/10] audit: add containerid support for user
 records
Message-ID: <20190318194109.GD4111@hmswarspite.think-freely.org>
References: <cover.1552665316.git.rgb@redhat.com>
 <e724de2037db0fd72fef7154c83615a742417d31.1552665316.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e724de2037db0fd72fef7154c83615a742417d31.1552665316.git.rgb@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 15, 2019 at 02:29:55PM -0400, Richard Guy Briggs wrote:
> Add audit container identifier auxiliary record to user event standalone
> records.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/audit.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index cfa659b3f6c4..cf448599ef34 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1142,12 +1142,6 @@ static void audit_log_common_recv_msg(struct audit_context *context,
>  	audit_log_task_context(*ab);
>  }
>  
> -static inline void audit_log_user_recv_msg(struct audit_buffer **ab,
> -					   u16 msg_type)
> -{
> -	audit_log_common_recv_msg(NULL, ab, msg_type);
> -}
> -
>  int is_audit_feature_set(int i)
>  {
>  	return af.features & AUDIT_FEATURE_TO_MASK(i);
> @@ -1409,13 +1403,16 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  
>  		err = audit_filter(msg_type, AUDIT_FILTER_USER);
>  		if (err == 1) { /* match or error */
> +			struct audit_context *context;
> +
>  			err = 0;
>  			if (msg_type == AUDIT_USER_TTY) {
>  				err = tty_audit_push();
>  				if (err)
>  					break;
>  			}
> -			audit_log_user_recv_msg(&ab, msg_type);
> +			context = audit_alloc_local(GFP_KERNEL);
> +			audit_log_common_recv_msg(context, &ab, msg_type);
>  			if (msg_type != AUDIT_USER_TTY)
>  				audit_log_format(ab, " msg='%.*s'",
>  						 AUDIT_MESSAGE_TEXT_MAX,
> @@ -1431,6 +1428,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  				audit_log_n_untrustedstring(ab, data, size);
>  			}
>  			audit_log_end(ab);
> +			audit_log_contid(context, audit_get_contid(current));
> +			audit_free_context(context);
>  		}
>  		break;
>  	case AUDIT_ADD_RULE:
> -- 
> 1.8.3.1
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

