From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netfilter: ctnetlink: deliver events for conntracks changed from
 userspace
Date: Mon, 06 Apr 2009 16:39:52 +0200
Message-ID: <49DA1438.6010508@netfilter.org>
References: <49D9F64E.4050304@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090501050003040304080902"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39962 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755549AbZDFOkP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:40:15 -0400
In-Reply-To: <49D9F64E.4050304@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090501050003040304080902
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Pablo, I'm looking at a regression introduced by this patch
> and I'm not sure about the intentions:
> 
>> +int nf_ct_expect_related(struct nf_conntrack_expect *expect)
>> +{
>> +       int ret;
>> +
>> +       spin_lock_bh(&nf_conntrack_lock);
>> +       ret = __nf_ct_expect_check(expect);
>> +       if (ret < 0)
>> +               goto out;
> 
> This is unfortunately broken since we return 0 when refreshing an
> existing expectation. This will create an identical expectation
> for each refresh.

Oh sorry.

>>         nf_ct_expect_insert(expect);
>> +       atomic_inc(&expect->use);
> 
> This I don't understand - the caller is holding a reference, why
> do we need another one?

I thought that the expectation timer may expire while delivering the
event, but that cannot happen since we still hold the reference until
the expectation setup is finished (nf_ct_expect_alloc() gets the
refcount, later nf_ct_expect_put() puts it).

>> +       spin_unlock_bh(&nf_conntrack_lock);
>>         nf_ct_expect_event(IPEXP_NEW, expect);
>> -       ret = 0;
>> +       nf_ct_expect_put(expect);
>> +       return ret;
>>  out:
>>         spin_unlock_bh(&nf_conntrack_lock);
>>         return ret;
>>  }
>>  EXPORT_SYMBOL_GPL(nf_ct_expect_related);
>>  
>> +int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
>> +                               u32 pid, int report)
>> +{
>> +       int ret;
>> +
>> +       spin_lock_bh(&nf_conntrack_lock);
>> +       ret = __nf_ct_expect_check(expect);
>> +       if (ret < 0)
>> +               goto out;
> 
> Same problem
> 
>> +       nf_ct_expect_insert(expect);
>> +out:
>> +       spin_unlock_bh(&nf_conntrack_lock);
>> +       if (ret == 0)
>> +               nf_ct_expect_event_report(IPEXP_NEW, expect, pid,
>> report);
> 
> But here we don't take the reference, despite having the exact
> same situation.

I don't find an answer for that, likely that I got confused for some
reason, sorry.

> The next question would be - why do we need those two functions at
> all? Aside from the apparently unnecessary reference counting, the
> only difference is reporting, and that actually uses the exact
> same code path.

Is the patch attached on the right track?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------090501050003040304080902
Content-Type: text/x-diff;
 name="x.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x.patch"

netfilter: ctnetlink: fix regression in expectation handling

This patch fixes a regression (introduced by myself) that results
in an expectation re-insertion since __nf_ct_expect_check() may
return 0 for expectation timer refreshing.

This patch also removes a unnecessary refcount bump that
prentended to avoid a possible race condition with event delivery
and expectation timers (as said, not needed since we hold a
reference to the object since until we finish the expectation
setup). This also merges nf_ct_expect_related_report() and
nf_ct_expect_related() which look basically the same.

Reported-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack_expect.h |    5 ++++-
 net/netfilter/nf_conntrack_expect.c         |   30 +++++----------------------
 2 files changed, 10 insertions(+), 25 deletions(-)


diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index ab17a15..a965280 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -99,9 +99,12 @@ void nf_ct_expect_init(struct nf_conntrack_expect *, unsigned int, u_int8_t,
 		       const union nf_inet_addr *,
 		       u_int8_t, const __be16 *, const __be16 *);
 void nf_ct_expect_put(struct nf_conntrack_expect *exp);
-int nf_ct_expect_related(struct nf_conntrack_expect *expect);
 int nf_ct_expect_related_report(struct nf_conntrack_expect *expect, 
 				u32 pid, int report);
+static inline int nf_ct_expect_related(struct nf_conntrack_expect *expect)
+{
+	return nf_ct_expect_related_report(expect, 0, 0);
+}
 
 #endif /*_NF_CONNTRACK_EXPECT_H*/
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 357ba39..0e2caad 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -372,7 +372,7 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 	struct net *net = nf_ct_exp_net(expect);
 	struct hlist_node *n;
 	unsigned int h;
-	int ret = 0;
+	int ret = 1;
 
 	if (!master_help->helper) {
 		ret = -ESHUTDOWN;
@@ -412,41 +412,23 @@ out:
 	return ret;
 }
 
-int nf_ct_expect_related(struct nf_conntrack_expect *expect)
+int nf_ct_expect_related_report(struct nf_conntrack_expect *expect, 
+				u32 pid, int report)
 {
 	int ret;
 
 	spin_lock_bh(&nf_conntrack_lock);
 	ret = __nf_ct_expect_check(expect);
-	if (ret < 0)
+	if (ret <= 0)
 		goto out;
 
+	ret = 0;
 	nf_ct_expect_insert(expect);
-	atomic_inc(&expect->use);
-	spin_unlock_bh(&nf_conntrack_lock);
-	nf_ct_expect_event(IPEXP_NEW, expect);
-	nf_ct_expect_put(expect);
-	return ret;
-out:
 	spin_unlock_bh(&nf_conntrack_lock);
+	nf_ct_expect_event_report(IPEXP_NEW, expect, pid, report);
 	return ret;
-}
-EXPORT_SYMBOL_GPL(nf_ct_expect_related);
-
-int nf_ct_expect_related_report(struct nf_conntrack_expect *expect, 
-				u32 pid, int report)
-{
-	int ret;
-
-	spin_lock_bh(&nf_conntrack_lock);
-	ret = __nf_ct_expect_check(expect);
-	if (ret < 0)
-		goto out;
-	nf_ct_expect_insert(expect);
 out:
 	spin_unlock_bh(&nf_conntrack_lock);
-	if (ret == 0)
-		nf_ct_expect_event_report(IPEXP_NEW, expect, pid, report);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_related_report);

--------------090501050003040304080902--
