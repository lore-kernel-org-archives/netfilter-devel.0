Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2115C76196
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Apr 2023 09:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjDJJb0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Apr 2023 05:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjDJJbZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2023 05:31:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EC5E113
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2023 02:31:24 -0700 (PDT)
Date:   Mon, 10 Apr 2023 11:31:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tzung-Bi Shih <tzungbi@kernel.org>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        jiejiang@chromium.org, jasongustaman@chromium.org,
        garrick@chromium.org
Subject: Re: [PATCH] netfilter: conntrack: fix wrong ct->timeout value
Message-ID: <ZDPXad/8beRw78yX@calendula>
References: <20230410060935.253503-1-tzungbi@kernel.org>
 <ZDPJ2rHi5fOqu4ga@calendula>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zoUjdoHZcrIexqcI"
Content-Disposition: inline
In-Reply-To: <ZDPJ2rHi5fOqu4ga@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--zoUjdoHZcrIexqcI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Apr 10, 2023 at 10:33:32AM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Mon, Apr 10, 2023 at 02:09:35PM +0800, Tzung-Bi Shih wrote:
> > (struct nf_conn)->timeout is an interval before the conntrack
> > confirmed.  After confirmed, it becomes a timestamp[1].
> > 
> > It is observed that timeout of an unconfirmed conntrack have been
> > altered by calling ctnetlink_change_timeout().  As a result,
> > `nfct_time_stamp` was wrongly added to `ct->timeout` twice[2].
> > 
> > Differentiate the 2 cases in all `ct->timeout` accesses.
> 
> You can just skip refreshing the timeout for unconfirmed conntrack
> entries in ctnetlink_change_timeout().

Something like this patch probably?

--zoUjdoHZcrIexqcI
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bfc3aaa2c872..6556f5f30844 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2466,7 +2466,8 @@ static int ctnetlink_new_conntrack(struct sk_buff *skb,
 
 	err = -EEXIST;
 	ct = nf_ct_tuplehash_to_ctrack(h);
-	if (!(info->nlh->nlmsg_flags & NLM_F_EXCL)) {
+	if (!(info->nlh->nlmsg_flags & NLM_F_EXCL) &&
+	    nf_ct_is_confirmed(ct)) {
 		err = ctnetlink_change_conntrack(ct, cda);
 		if (err == 0) {
 			nf_conntrack_eventmask_report((1 << IPCT_REPLY) |

--zoUjdoHZcrIexqcI--
