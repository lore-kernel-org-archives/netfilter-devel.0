From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: helper: Fix incorrect helper name.
Date: Tue, 24 May 2016 11:23:51 +0200
Message-ID: <20160524092351.GA2105@salvia>
References: <1463231956-26867-1-git-send-email-ap420073@gmail.com>
 <20160517103842.GA3324@salvia>
 <CAMArcTUm9PeVD3+Vq7g0OffqxUZQJYRJs304jAF90LXH1Xj1YA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Cc: Patrick McHardy <kaber@trash.net>, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46869 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbcEXJX6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2016 05:23:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 670C41EFDAF
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:23:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 527A015D639
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:23:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B8C4015D622
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:23:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAMArcTUm9PeVD3+Vq7g0OffqxUZQJYRJs304jAF90LXH1Xj1YA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 23, 2016 at 12:03:55AM +0900, Taehee Yoo wrote:
> 2016-05-17 19:38 GMT+09:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > On Sat, May 14, 2016 at 10:19:16PM +0900, Taehee Yoo wrote:
> >> when register to helper, each helper adds port to name.
> >> correct form is 'protocol name-port' but irc, sip and tftp adds
> >> a iterator value. so it fix it.
> >
> > Could you track since when this works in this way?
> >
> > This inconsistency has been probably there since long time ago, and we
> > expose this names through iptables -m helper.
> >
> > What I mean is: I understand this is inconsistent, but if we change
> > this now, we may break existing rulesets.
> 
> 
> Thank you for your review.
> And Apologize for late reply.
> 
> I agree that patch destroys so much rulesets.
> but I want to solve the issue that is helper cannot check duplicated
> helper rules.
> nf_conntrack_helper_register() checks name && l3num && protonum to
> check duplicated rules.
> but tftp, sip and irc helper always have unique helper name because
> that includes iterator value.
> (tftp-1, tftp-2, tftp-3 ...)
> helper-name is good method to check duplicated rules.
> but we need another check method to solve this issue and keep rulsets.
> so far, my idea is that using help callback function's pointer address.
> pseudo code is : "if (port && l3num && protonum && help)"
> 
> Do you have any advice?

Probably something like this?

The idea is to compare the helper name, stripping off the '-value'
from the name so we catch if the user specific duplicated ports via
module option, which is what is causing problems to you, right?

--tThc/1wpZn/ma/RB
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index f703adb..5785034 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -361,9 +361,9 @@ EXPORT_SYMBOL_GPL(nf_ct_helper_log);
 
 int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
-	int ret = 0;
 	struct nf_conntrack_helper *cur;
 	unsigned int h = helper_hash(&me->tuple);
+	int ret = 0, len;
 
 	BUG_ON(me->expect_policy == NULL);
 	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
@@ -371,7 +371,13 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 
 	mutex_lock(&nf_ct_helper_mutex);
 	hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
-		if (strncmp(cur->name, me->name, NF_CT_HELPER_NAME_LEN) == 0 &&
+		slash = strchr(cur->name, '-');
+		if (slash)
+			len = slash - cur->name;
+		else
+			len = NF_CT_HELPER_NAME_LEN;
+
+		if (strncmp(cur->name, me->name, len) == 0 &&
 		    cur->tuple.src.l3num == me->tuple.src.l3num &&
 		    cur->tuple.dst.protonum == me->tuple.dst.protonum) {
 			ret = -EEXIST;

--tThc/1wpZn/ma/RB--
