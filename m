Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D15C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA15560FE4
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236385AbhCaUWv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 16:22:51 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48918 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236379AbhCaUWf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 16:22:35 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8110663E47;
        Wed, 31 Mar 2021 22:22:19 +0200 (CEST)
Date:   Wed, 31 Mar 2021 22:22:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        twoerner@redhat.com, tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [PATCH v5] audit: log nftables configuration change events once
 per table
Message-ID: <20210331202230.GA4109@salvia>
References: <28de34275f58b45fd4626a92ccae96b6d2b4e287.1616702731.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <28de34275f58b45fd4626a92ccae96b6d2b4e287.1616702731.git.rgb@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Mar 26, 2021 at 01:38:59PM -0400, Richard Guy Briggs wrote:
> Reduce logging of nftables events to a level similar to iptables.
> Restore the table field to list the table, adding the generation.
> 
> Indicate the op as the most significant operation in the event.

There's a UAF, Florian reported. I'm attaching an incremental fix.

nf_tables_commit_audit_collect() refers to the trans object which
might have been already released.

--OXfL5xGRrasGEqWY
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix-uaf.patch"

commit e4d272948d25b66d86fc241cefd95281bfb1079e
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Wed Mar 31 22:19:51 2021 +0200

    netfilter: nf_tables: use-after-free
    
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5dd4bb7cabf5..01674c0d9103 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8063,6 +8063,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	net->nft.gencursor = nft_gencursor_next(net);
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+		nf_tables_commit_audit_collect(&adl, trans->ctx.table,
+					       trans->msg_type);
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
@@ -8211,8 +8213,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			}
 			break;
 		}
-		nf_tables_commit_audit_collect(&adl, trans->ctx.table,
-					       trans->msg_type);
 	}
 
 	nft_commit_notify(net, NETLINK_CB(skb).portid);

--OXfL5xGRrasGEqWY--
