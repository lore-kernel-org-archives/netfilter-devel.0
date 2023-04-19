Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E8B2C6FD18
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Apr 2023 10:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbjDSKLe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Apr 2023 06:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbjDSKLc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2023 06:11:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA99EE7
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2023 03:11:30 -0700 (PDT)
Date:   Wed, 19 Apr 2023 12:11:27 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tzung-Bi Shih <tzungbi@kernel.org>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        jiejiang@chromium.org, jasongustaman@chromium.org,
        garrick@chromium.org
Subject: Re: [PATCH v3] netfilter: conntrack: fix wrong ct->timeout value
Message-ID: <ZD++Tztor/BvG+ZY@calendula>
References: <20230419051526.3170053-1-tzungbi@kernel.org>
 <ZD+a+R6+OgXm4QFZ@calendula>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3Y3LdtmN9jgRrot4"
Content-Disposition: inline
In-Reply-To: <ZD+a+R6+OgXm4QFZ@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--3Y3LdtmN9jgRrot4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Apr 19, 2023 at 09:40:44AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Apr 19, 2023 at 01:15:26PM +0800, Tzung-Bi Shih wrote:
> > (struct nf_conn)->timeout is an interval before the conntrack
> > confirmed.  After confirmed, it becomes a timestamp[1].
> > 
> > It is observed that timeout of an unconfirmed conntrack:
> > - Set by calling ctnetlink_change_timeout().  As a result,
> >   `nfct_time_stamp` was wrongly added to `ct->timeout` twice[2].
> > - Get by calling ctnetlink_dump_timeout().  As a result,
> >   `nfct_time_stamp` was wrongly subtracted[3].
> > 
> > Separate the 2 cases in:
> > - Setting `ct->timeout` in __nf_ct_set_timeout().
> > - Getting `ct->timeout` in ctnetlink_dump_timeout().
> 
> Applied, thanks

I have to amend this patch, I have to collapsed the attached chunk.
Otherwise conntrack creation via ctnetlink breaks.


--3Y3LdtmN9jgRrot4
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d3ee18854698..d65290646f63 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2253,9 +2253,6 @@ ctnetlink_create_conntrack(struct net *net,
 	if (!cda[CTA_TIMEOUT])
 		goto err1;
 
-	timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
-	__nf_ct_set_timeout(ct, timeout);
-
 	rcu_read_lock();
  	if (cda[CTA_HELP]) {
 		char *helpname = NULL;
@@ -2319,6 +2316,9 @@ ctnetlink_create_conntrack(struct net *net,
 	/* we must add conntrack extensions before confirmation. */
 	ct->status |= IPS_CONFIRMED;
 
+	timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
+	__nf_ct_set_timeout(ct, timeout);
+
 	if (cda[CTA_STATUS]) {
 		err = ctnetlink_change_status(ct, cda);
 		if (err < 0)

--3Y3LdtmN9jgRrot4--
