Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AA1CD6E54
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 10:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbjJKKZB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 06:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjJKKZA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 06:25:00 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D776592
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:24:58 -0700 (PDT)
Received: from [78.30.34.192] (port=60818 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qqWOc-00B78Q-GP; Wed, 11 Oct 2023 12:24:57 +0200
Date:   Wed, 11 Oct 2023 12:24:53 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: Re: [PATCH conntrack] conntrack: label update requires a previous
 label in place
Message-ID: <ZSZ39VSJWfPjeizQ@calendula>
References: <20231011095503.131168-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231011095503.131168-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 11, 2023 at 11:55:03AM +0200, Pablo Neira Ayuso wrote:
> You have to set an initial label if you plan to update it later on.  If
> conntrack comes with no initial label, then it is not possible to attach
> it later because conntrack extensions are created by the time the new
> entry is created.
> 
> Skip entries with no label to skip ENOSPC error for conntracks that have
> no initial label (this is assuming a scenario with conntracks with and
> _without_ labels is possible, and the conntrack command line tool is used
> to update all entries regardless they have or not an initial label, e.g.
> conntrack -U --label-add "testlabel".

Still not fully correct.

Current behaviour is:

If there is at least one rule in the ruleset that uses the connlabel,
then connlabel conntrack extension is always allocated.

I wonder if this needs a sysctl toggle just like
nf_conntrack_timestamp. Otherwise I am not sure how to document this.

>  # conntrack -U --label-add testlabel --dst 9.9.9.9
>  icmp     1 13 src=192.168.2.130 dst=9.9.9.9 type=8 code=0 id=50997 src=9.9.9.9 dst=192.168.2.130 type=0 code=0 id=50997 mark=0 use=2 labels=default,testlabel
> conntrack v1.4.8 (conntrack-tools): 1 flow entries have been updated.
>  # conntrack -C
>  8
> 
> Note the remaining 7 conntracks have no label, hence, they could not be
> updated.
> 
> Update manpage to document this behaviour.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1622
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  conntrack.8     | 2 ++
>  src/conntrack.c | 4 ++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/conntrack.8 b/conntrack.8
> index 031eaa4e9fef..97c60079889f 100644
> --- a/conntrack.8
> +++ b/conntrack.8
> @@ -193,6 +193,8 @@ Use multiple \-l options to specify multiple labels that need to be set.
>  Specify the conntrack label to add to the selected conntracks.
>  This option is only available in conjunction with "\-I, \-\-create",
>  "\-A, \-\-add" or "\-U, \-\-update".
> +You must set a default label for conntracks initially if you plan to update it
> +later. "\-U, \-\-update" on conntracks with no initial entry will be ignored.
>  .TP
>  .BI "--label-del " "[LABEL]"
>  Specify the conntrack label to delete from the selected conntracks.
> diff --git a/src/conntrack.c b/src/conntrack.c
> index f9758d78d39b..06c2fee7ac4b 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -2195,6 +2195,10 @@ static int mnl_nfct_update_cb(const struct nlmsghdr *nlh, void *data)
>  		/* the entry has vanish in middle of the update */
>  		if (errno == ENOENT)
>  			goto destroy_ok;
> +		else if (!(cmd->options & (CT_OPT_ADD_LABEL | CT_OPT_DEL_LABEL)) &&
> +			 errno == ENOSPC)

This check is also not correct, this needs a v3. I have to check is
ATTRS_CONNLABEL is set and cmd->options & (CT_OPT_ADD_LABEL |
CT_OPT_DEL_LABEL) too, then check for ENOSPC, to avoid for bogus
error reports to userspace.

> +			goto destroy_ok;
> +
>  		exit_error(OTHER_PROBLEM,
>  			   "Operation failed: %s",
>  			   err2str(errno, CT_UPDATE));
> -- 
> 2.30.2
> 
