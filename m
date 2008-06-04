From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] libnfnetlink byte alignment
Date: Wed, 04 Jun 2008 23:42:42 +0200
Message-ID: <48470C52.1080306@netfilter.org>
References: <1212488448.29489.40.camel@pumper.lan.luxnet.ch> <484541E0.3020900@trash.net> <48465802.2010005@gmx.ch>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010609020005020805000305"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53111 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751075AbYFDVmy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:42:54 -0400
In-Reply-To: <48465802.2010005@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010609020005020805000305
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Fabian Hugelshofer wrote:
> Patrick McHardy wrote:
>> Fabian Hugelshofer wrote:
>>> Aligns buffers to maximum alignment of architecture to make the cast of
>>> char pointers to struct pointers more portable.
>>>
>>> Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
>>
>> They all seem fine to me, but a union might make it look
>> a bit nicer :)
> 
> In libnfnetlink the union does not make sense, because multiple casts
> are done from the same buffer at different locations.
> 
> For libnetfilter-(conntrack|log) the union would be possible:
> 
> Original (aligned):
> << code begin >>
> char buf[...] __attribute__ ((aligned));
> struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
> 
> nfnl_fill_hdr(h->nfnlssh, nmh, 0, pf, queuenum, ...);
> << code end >>
> 
> Union style:
> << code begin >>
> union {
>     char buf[...];
>     struct nlmsghdr nmh;
> } u;
> 
> nfnl_fill_hdr(h->nfnlssh, &u.nmh, 0, pf, queuenum, ...);
> << code end >>
> 
> I can rewrite it like this, if desired...

Please, use union wherever it is possible. BTW, it seems to me that the
conntrack-tools may suffer from the same portability problem. The
(supposed) fix, which is attached, is ugly but union does not help since
the size of struct nf_conntrack is not known. I do not find a way to do
this cleanly without removing the use of the stack for temporary object
allocation.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010609020005020805000305
Content-Type: text/plain;
 name="y"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="y"

diff --git a/src/cache_wt.c b/src/cache_wt.c
index 65a1fc4..9c1b69c 100644
--- a/src/cache_wt.c
+++ b/src/cache_wt.c
@@ -28,7 +28,7 @@
 static void add_wt(struct us_conntrack *u)
 {
 	int ret;
-	char __ct[nfct_maxsize()];
+	char __ct[nfct_maxsize()] __attribute__((aligned));
 	struct nf_conntrack *ct = (struct nf_conntrack *)(void*) __ct;
 
 	ret = nl_exist_conntrack(u->ct);
@@ -56,7 +56,7 @@ static void add_wt(struct us_conntrack *u)
 
 static void upd_wt(struct us_conntrack *u)
 {
-	char __ct[nfct_maxsize()];
+	char __ct[nfct_maxsize()] __attribute__((aligned));
 	struct nf_conntrack *ct = (struct nf_conntrack *)(void*) __ct;
 
 	memcpy(ct, u->ct, nfct_maxsize());
diff --git a/src/conntrack.c b/src/conntrack.c
index 25a3a57..d2e1b47 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -747,7 +747,7 @@ static int update_cb(enum nf_conntrack_msg_type type,
 {
 	int res;
 	struct nf_conntrack *obj = data;
-	char __tmp[nfct_maxsize()];
+	char __tmp[nfct_maxsize()] __attribute__((aligned));
 	struct nf_conntrack *tmp = (struct nf_conntrack *) (void *)__tmp;
 
 	memcpy(tmp, obj, sizeof(__tmp));
@@ -873,14 +873,14 @@ int main(int argc, char *argv[])
 	unsigned int type = 0, event_mask = 0, l4flags = 0, status = 0;
 	int res = 0;
 	int family = AF_UNSPEC;
-	char __obj[nfct_maxsize()];
-	char __exptuple[nfct_maxsize()];
-	char __mask[nfct_maxsize()];
+	char __obj[nfct_maxsize()] __attribute__((aligned));
+	char __exptuple[nfct_maxsize()] __attribute__((aligned));
+	char __mask[nfct_maxsize()] __attribute__((aligned));
 	struct nf_conntrack *obj = (struct nf_conntrack *)(void*) __obj;
 	struct nf_conntrack *exptuple = 
 		(struct nf_conntrack *)(void*) __exptuple;
 	struct nf_conntrack *mask = (struct nf_conntrack *)(void*) __mask;
-	char __exp[nfexp_maxsize()];
+	char __exp[nfexp_maxsize()] __attribute__((aligned));
 	struct nf_expect *exp = (struct nf_expect *)(void*) __exp;
 	int l3protonum;
 	union ct_address ad;
diff --git a/src/sync-mode.c b/src/sync-mode.c
index 4b36935..1b6ec48 100644
--- a/src/sync-mode.c
+++ b/src/sync-mode.c
@@ -38,7 +38,7 @@
 static void do_mcast_handler_step(struct nethdr *net, size_t remain)
 {
 	int query;
-	char __ct[nfct_maxsize()];
+	char __ct[nfct_maxsize()] __attribute__((aligned));
 	struct nf_conntrack *ct = (struct nf_conntrack *)(void*) __ct;
 	struct us_conntrack *u;
 

--------------010609020005020805000305--
