From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd segfault on EPSV IPv6 ftp command when using ftp
 ExpectationSync
Date: Tue, 16 Jul 2013 23:37:22 +0200
Message-ID: <20130716213722.GA17919@localhost>
References: <20130707030458.fbf22472.billfink@mindspring.com>
 <20130709013023.2fb1fef1.billfink@mindspring.com>
 <20130709182223.GA6266@localhost>
 <20130710055815.a1bd2c1d.billfink@mindspring.com>
 <20130710220820.GA20666@localhost>
 <20130711004827.GA5500@localhost>
 <20130712030114.0362fb5a.billfink@mindspring.com>
 <20130715124905.GA21260@localhost>
 <20130716015503.735ca678.billfink@mindspring.com>
 <20130716213354.GA17466@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bill Fink <billfink@mindspring.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33192 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933374Ab3GPVh1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:37:27 -0400
Content-Disposition: inline
In-Reply-To: <20130716213354.GA17466@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 16, 2013 at 11:33:54PM +0200, Pablo Neira Ayuso wrote:
[...]
> Interesting. Can you apply the following patch? It should help to
> debug the issue. Basically, it displays the conntrack unique ID. They
> should have different IDs.

Forgot attachment, here it comes.

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x

diff --git a/src/cache-ct.c b/src/cache-ct.c
index f86d143..11b0543 100644
--- a/src/cache-ct.c
+++ b/src/cache-ct.c
@@ -152,7 +152,7 @@ static int cache_ct_dump_step(void *data1, void *n)
 			     obj->ptr,
 			     NFCT_T_UNKNOWN, 
 			     container->type,
-			     0);
+			     NFCT_OF_ID);
 
 	for (i = 0; i < obj->cache->num_features; i++) {
 		if (obj->cache->features[i]->dump) {

--HlL+5n6rz5pIUxbD--
