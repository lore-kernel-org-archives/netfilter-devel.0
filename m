From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH] netfilter: xt_hashlimit: handle iptables-restore of hash
 with same name
Date: Thu, 14 Aug 2014 16:09:57 +0200
Message-ID: <20140814140956.GA16567@imap.eitzenberger.org>
References: <1406004850-31336-1-git-send-email-johunt@akamai.com>
 <20140724084927.GB18404@breakpoint.cc>
 <ffaf5ee3-2af6-4747-bdd1-481ed87e68aa@email.android.com>
 <53D28C97.9000009@akamai.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Cc: Patrick McHardy <kaber@trash.net>, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	Harald Welte <laforge@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:57229 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaHNOKB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:10:01 -0400
Content-Disposition: inline
In-Reply-To: <53D28C97.9000009@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Sorry for answering late.  I somehow managed to ignore the thread.

First of all: I have the same problem with my ruleset, and I have
fixed it with the patch attached, fixing my use-case.

> >True, but it's a bug that has existed forever and I've seen scripts that actually rely on this.
> >
> >I'm not sure if we can silently change this behaviour.
> 
> Can you elaborate on what behavior they're relying on? It'd be
> helpful to know in case my approach can't be used we might be able
> to come up with an alternative.

There are two cases to consider: 1) the case Patrick and Florian are
talking about: two rules using the same hashtable <NAME>, but with
different parameters, and 2) updating an existing hashtable <NAME>,
with a single or multiple rules using it.

For case 1) the current behaviour actually makes more sense: the
first rule using hashtable <NAME> determines the parameters actually
being used.  Any subsequent rule using hashtable <NAME> automatically
uses the same parameters, even if specifying different parameters in
iptables-restore.

For case 2) the behaviour is unexpected: when using iptables-restore
to update an already existing hashtable <NAME> the updates are
ignored.

And from your description my understanding is that the latter case
is what you tried to solve with your patch.  And this is also what I
tried to solve with my patch.  In my case I simply have to make sure
when writing each rule that I use each hashtable only once.

Find attached the version I am currently using.

Cheers,

/Holger


--OXfL5xGRrasGEqWY
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="hashlimit-fix-update.diff"

Index: linux-3.8.y/net/netfilter/xt_hashlimit.c
===================================================================
--- linux-3.8.y.orig/net/netfilter/xt_hashlimit.c
+++ linux-3.8.y/net/netfilter/xt_hashlimit.c
@@ -214,6 +214,18 @@ dsthash_free(struct xt_hashlimit_htable
 }
 static void htable_gc(unsigned long htlong);
 
+static void
+htable_update_cfg(struct xt_hashlimit_htable *hinfo,
+		  const struct xt_hashlimit_mtinfo1 *minfo)
+{
+	/* copy match config into hashtable config */
+	memcpy(&hinfo->cfg, &minfo->cfg, sizeof(hinfo->cfg));
+	if (hinfo->cfg.max == 0)
+		hinfo->cfg.max = 8 * hinfo->cfg.size;
+	else if (hinfo->cfg.max < hinfo->cfg.size)
+		hinfo->cfg.max = hinfo->cfg.size;
+}
+
 static int htable_create(struct net *net, struct xt_hashlimit_mtinfo1 *minfo,
 			 u_int8_t family)
 {
@@ -239,13 +251,8 @@ static int htable_create(struct net *net
 		return -ENOMEM;
 	minfo->hinfo = hinfo;
 
-	/* copy match config into hashtable config */
-	memcpy(&hinfo->cfg, &minfo->cfg, sizeof(hinfo->cfg));
 	hinfo->cfg.size = size;
-	if (hinfo->cfg.max == 0)
-		hinfo->cfg.max = 8 * hinfo->cfg.size;
-	else if (hinfo->cfg.max < hinfo->cfg.size)
-		hinfo->cfg.max = hinfo->cfg.size;
+	htable_update_cfg(hinfo, minfo);
 
 	for (i = 0; i < hinfo->cfg.size; i++)
 		INIT_HLIST_HEAD(&hinfo->hash[i]);
@@ -318,6 +325,27 @@ static void htable_gc(unsigned long htlo
 	add_timer(&ht->timer);
 }
 
+static int
+htable_update(struct xt_hashlimit_mtinfo1 *minfo,
+	      u_int8_t family)
+{
+	struct xt_hashlimit_htable *hinfo = minfo->hinfo;
+
+	if (hinfo == NULL)
+		return -ENOENT;
+
+	if (minfo->cfg.size && hinfo->cfg.size != minfo->cfg.size)
+		return -EBUSY;
+	if (hinfo->family != family)
+		return -EBUSY;
+
+	hinfo->use++;
+	htable_update_cfg(hinfo, minfo);
+	htable_selective_cleanup(hinfo, select_all);
+
+	return 0;
+}
+
 static void htable_destroy(struct xt_hashlimit_htable *hinfo)
 {
 	struct hashlimit_net *hashlimit_net = hashlimit_pernet(hinfo->net);
@@ -691,20 +719,28 @@ static int hashlimit_mt_check(const stru
 	info->hinfo = htable_find_get(net, info->name, par->family);
 	if (info->hinfo == NULL) {
 		ret = htable_create(net, info, par->family);
-		if (ret < 0) {
-			mutex_unlock(&hashlimit_mutex);
-			return ret;
-		}
+		if (ret < 0)
+			goto err_unlock;
+	} else {
+		ret = htable_update(info, par->family);
+		if (ret < 0)
+			goto err_unlock;
 	}
+
 	mutex_unlock(&hashlimit_mutex);
 	return 0;
+
+err_unlock:
+	mutex_unlock(&hashlimit_mutex);
+	return ret;
 }
 
 static void hashlimit_mt_destroy(const struct xt_mtdtor_param *par)
 {
-	const struct xt_hashlimit_mtinfo1 *info = par->matchinfo;
+	struct xt_hashlimit_mtinfo1 *info = par->matchinfo;
 
 	htable_put(info->hinfo);
+	info->hinfo = NULL;
 }
 
 static struct xt_match hashlimit_mt_reg[] __read_mostly = {

--OXfL5xGRrasGEqWY--
