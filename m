From: Paul Aitken <paitken@brocade.com>
Subject: Re: conntrack-tools bugs
Date: Thu, 28 May 2015 16:41:56 +0100
Message-ID: <55673744.4050904@brocade.com>
References: <5565DB12.6030808@brocade.com> <20150527180914.GA3685@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------020405060209060800000109"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:6053 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364AbbE1Po3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 11:44:29 -0400
In-Reply-To: <20150527180914.GA3685@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--------------020405060209060800000109
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit

Please see the attached patches.

Thanks,
P.


On 27/05/15 19:09, Pablo Neira Ayuso wrote:
> On Wed, May 27, 2015 at 03:56:18PM +0100, Paul Aitken wrote:
>> Pablo, I found a couple of bugs in conntrack-tools.
>>
>> I could clone the git repo and fix them or submit a patch. What's
>> the right process?
> Please, send patches to netfilter-devel@vger.kernel.org
>
> I need that they apply through git am, ie. you have to generate it
> with git format-patch.
>
> Include a title and a description. Thanks.


--------------020405060209060800000109
Content-Type: text/x-patch; name="0001-Fix-two-issues-with-memset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-Fix-two-issues-with-memset.patch"

>From af1d3f66cf4fac3d2d5454dd11263c6f89d655c5 Mon Sep 17 00:00:00 2001
From: Paul Aitken <paitken@brocade.com>
Date: Thu, 28 May 2015 16:25:20 +0100
Subject: [PATCH 1/3] Fix two issues with memset

[src/expect.c:57]: (warning) The 2nd memset() argument '4294967295'
doesn't fit into an 'unsigned char'.
[src/expect.c:132]: (warning) The 2nd memset() argument '4294967295'
doesn't fit into an 'unsigned char'.

memset fills bytes, not ulongs - so the second parameter
(the fill value) has to be a byte.

Additionally, the second memset wasn't using the loop value
as an array offset.
---
 src/expect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/expect.c b/src/expect.c
index bba0ed7..78c92b5 100644
--- a/src/expect.c
+++ b/src/expect.c
@@ -54,7 +54,7 @@ cthelper_expect_init(struct nf_expect *exp, struct nf_conntrack *master,
 			nfct_set_attr(expected, ATTR_IPV6_SRC, saddr->ip6);
 
 			for (i=0; i<4; i++)
-				memset(&addr[i], 0xffffffff, sizeof(uint32_t));
+				memset(&addr[i], 0xff, sizeof(uint32_t));
 
 			nfct_set_attr_u8(mask, ATTR_L3PROTO, AF_INET6);
 			nfct_set_attr(mask, ATTR_IPV6_SRC, addr);
@@ -129,7 +129,7 @@ cthelper_expect_init(struct nf_expect *exp, struct nf_conntrack *master,
 		nfct_set_attr(expected, ATTR_IPV6_DST, daddr->ip6);
 
 		for (i=0; i<4; i++)
-			memset(addr, 0xffffffff, sizeof(uint32_t));
+			memset(&addr[i], 0xff, sizeof(uint32_t));
 
 		nfct_set_attr(mask, ATTR_IPV6_DST, addr);
 		break;
-- 
1.9.1


--------------020405060209060800000109
Content-Type: text/x-patch; name="0002-Optimise-nfq_queue_cb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="0002-Optimise-nfq_queue_cb.patch"

>From 395c8b6ce66dfaca6d3d85611a174ad2b026a241 Mon Sep 17 00:00:00 2001
From: Paul Aitken <paitken@brocade.com>
Date: Thu, 28 May 2015 16:34:33 +0100
Subject: [PATCH 2/3] Optimise nfq_queue_cb

ct and myct have both already been checked for non-NULL,
so there's no need to check either of them again here.
---
 src/cthelper.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/src/cthelper.c b/src/cthelper.c
index 15d5126..6537515 100644
--- a/src/cthelper.c
+++ b/src/cthelper.c
@@ -325,14 +325,12 @@ static int nfq_queue_cb(const struct nlmsghdr *nlh, void *data)
 	if (pkt_verdict_issue(helper, myct, queue_num, id, verdict, pktb) < 0)
 		goto err_pktb;
 
-	if (ct != NULL)
-		nfct_destroy(ct);
+	nfct_destroy(ct);
 	if (myct->exp != NULL)
 		nfexp_destroy(myct->exp);
-	if (myct && myct->priv_data != NULL)
+	if (myct->priv_data != NULL)
 		free(myct->priv_data);
-	if (myct != NULL)
-		free(myct);
+	free(myct);
 
 	return MNL_CB_OK;
 err_pktb:
-- 
1.9.1


--------------020405060209060800000109
Content-Type: text/x-patch; name="0003-remove-unused-numbytes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0003-remove-unused-numbytes.patch"

>From d81010b4b9a7601b9503aee09bc5e2b280b8e097 Mon Sep 17 00:00:00 2001
From: Paul Aitken <paitken@brocade.com>
Date: Thu, 28 May 2015 16:35:19 +0100
Subject: [PATCH 3/3] remove unused 'numbytes'

'numbytes' isn't used and can be removed.
---
 src/local.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/local.c b/src/local.c
index feff608..453799a 100644
--- a/src/local.c
+++ b/src/local.c
@@ -117,11 +117,10 @@ void local_client_destroy(int fd)
 
 int do_local_client_step(int fd, void (*process)(char *buf))
 {
-	int numbytes;
 	char buf[1024];
 
 	memset(buf, 0, sizeof(buf));
-	while ((numbytes = recv(fd, buf, sizeof(buf)-1, 0)) > 0) {
+	while (recv(fd, buf, sizeof(buf)-1, 0) > 0) {
 		buf[sizeof(buf)-1] = '\0';
 		if (process)
 			process(buf);
-- 
1.9.1


--------------020405060209060800000109--
