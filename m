From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: TCP proto info
Date: Fri, 03 Sep 2010 13:33:52 +0200
Message-ID: <4C80DD20.7010004@netfilter.org>
References: <OF4265BCAA.61F095B7-ONC1257792.0032E48D-C1257792.00337F58@mindspeed.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020409060502040200090904"
Cc: netfilter-devel@vger.kernel.org
To: rui.sousa@mindspeed.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38169 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522Ab0ICLeH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Sep 2010 07:34:07 -0400
In-Reply-To: <OF4265BCAA.61F095B7-ONC1257792.0032E48D-C1257792.00337F58@mindspeed.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020409060502040200090904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 02/09/10 11:21, rui.sousa@mindspeed.com wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote on 09/02/2010 10:57:39 AM:
> 
>> Hi Rui,
> 
> Hi Pablo,
> 
>> On 01/09/10 15:45, rui.sousa@mindspeed.com wrote:
>>> Hi,
>>>
>>> I have an application using libnetfilter_conntrack-0.100 that started 
>>> reporting errors after the commit: 
>>>
>>> 1c450e1595afdc8d1bfabb4f640c9251808426eb.
>>
>> Looking at the source code, this seems to be already fixed in
>> libnetfilter_conntrack 0.0.102, please upgrade to latest.
> 
> Hmm... looking at the git tree I see that the __build_conntrack() code is
> still calling __build_protoinfo() unconditionally and inside the function
> we always do:
> 
> nest = nfnl_nest(&req->nlh, size, CTA_PROTOINFO);
> nest_proto = nfnl_nest(&req->nlh, size, CTA_PROTOINFO_TCP);
> ...
> nfnl_nest_end(&req->nlh, nest_proto);
> nfnl_nest_end(&req->nlh, nest);
> 
> even if none of the ATTR_TCP_xxx bits are set. This is what causes the 
> kernel to return -EINVAL
> and ignore the conntrack update. Or am I missing something?

I see, I guess that you're using a Linux kernel <= 2.6.25 since I
couldn't reproduce it with recent kernels. Please, could you give a try
to the following patch?

--------------020409060502040200090904
Content-Type: text/x-patch;
 name="fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix.patch"

ct: fix EINVAL if not TCP attributes are set for Linux kernel <= 2.6.25

This patch fixes an EINVAL error that we hit in Linux kernel <= 2.6.25.
Basically, if we send an empty CTA_PROTOINFO_TCP attribute nest, the
kernel returns EINVAL. To fix this, we previously check if there is
any TCP attribute set.

Reported-by: Rui Sousa <rui.sousa@mindspeed.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack/build.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index b878ddd..ec7623d 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -106,6 +106,18 @@ static void __build_protoinfo(struct nfnlhdr *req, size_t size,
 
 	switch(ct->tuple[__DIR_ORIG].protonum) {
 	case IPPROTO_TCP:
+		/* Preliminary attribute check to avoid sending an empty
+		 * CTA_PROTOINFO_TCP nest, which results in EINVAL in
+		 * Linux kernel <= 2.6.25. */
+		if (!(test_bit(ATTR_TCP_STATE, ct->set) ||
+		      test_bit(ATTR_TCP_FLAGS_ORIG, ct->set) ||
+		      test_bit(ATTR_TCP_FLAGS_REPL, ct->set) ||
+		      test_bit(ATTR_TCP_MASK_ORIG, ct->set) ||
+		      test_bit(ATTR_TCP_MASK_REPL, ct->set) ||
+		      test_bit(ATTR_TCP_WSCALE_ORIG, ct->set) ||
+		      test_bit(ATTR_TCP_WSCALE_REPL, ct->set))) {
+			break;
+		}
 		nest = nfnl_nest(&req->nlh, size, CTA_PROTOINFO);
 		nest_proto = nfnl_nest(&req->nlh, size, CTA_PROTOINFO_TCP);
 		if (test_bit(ATTR_TCP_STATE, ct->set))
@@ -139,6 +151,12 @@ static void __build_protoinfo(struct nfnlhdr *req, size_t size,
 		nfnl_nest_end(&req->nlh, nest);
 		break;
 	case IPPROTO_SCTP:
+		/* See comment above on TCP. */
+		if (!(test_bit(ATTR_SCTP_STATE, ct->set) ||
+		      test_bit(ATTR_SCTP_VTAG_ORIG, ct->set) ||
+		      test_bit(ATTR_SCTP_VTAG_REPL, ct->set))) {
+			break;
+		}
 		nest = nfnl_nest(&req->nlh, size, CTA_PROTOINFO);
 		nest_proto = nfnl_nest(&req->nlh, size, CTA_PROTOINFO_SCTP);
 		if (test_bit(ATTR_SCTP_STATE, ct->set))
@@ -158,6 +176,12 @@ static void __build_protoinfo(struct nfnlhdr *req, size_t size,
 		nfnl_nest_end(&req->nlh, nest);
 		break;
 	case IPPROTO_DCCP:
+		/* See comment above on TCP. */
+		if (!(test_bit(ATTR_DCCP_STATE, ct->set) ||
+		      test_bit(ATTR_DCCP_ROLE, ct->set) ||
+		      test_bit(ATTR_DCCP_HANDSHAKE_SEQ, ct->set))) {
+			break;
+		}
 		nest = nfnl_nest(&req->nlh, size, CTA_PROTOINFO);
 		nest_proto = nfnl_nest(&req->nlh, size, CTA_PROTOINFO_DCCP);
 		if (test_bit(ATTR_DCCP_STATE, ct->set))

--------------020409060502040200090904--
