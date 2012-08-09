From: pablo@netfilter.org
Subject: [PATCH 0/2] fixes for conntrack expectation
Date: Fri, 10 Aug 2012 01:02:10 +0200
Message-ID: <1344553332-8536-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56215 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab2HIXDV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 19:03:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi,

These two patches aim to resolve oops that were reported while
using the SIP helper. They are directly related with the SIP
helper itself, but the expectation infrastructure. But they
can be easily triggered by the SIP helper.

Still waiting for confirmation from the user to confirm that
these fixes his problems.

Pablo Neira Ayuso (2):
  netfilter: nf_ct_expect: fix re-insertion in expect list if timer refresh fails
  netfilter: nf_ct_expect: fix possible invalid dereference while event reporting

 net/netfilter/nf_conntrack_expect.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
1.7.10.4

