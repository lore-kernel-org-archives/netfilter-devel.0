From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: man page nft.8 add chain synopsis
Date: Fri, 6 Oct 2017 16:08:38 +1100
Message-ID: <20171006050838.GA9956@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33375 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750732AbdJFFhd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2017 01:37:33 -0400
Received: from dimstar.local.net (c220-239-36-238.eburwd6.vic.optusnet.com.au [220.239.36.238])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id E1768104837F
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Oct 2017 16:08:39 +1100 (AEDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The man page says this:

> {add | create} chain [family] table chain [ { {type} {hook} [device] {priority} } [policy] ]

But I suggest it should say this:

> {add | create} chain [family] table chain [ { {type} {hook} [device] {priority ;} [policy ;] } ]

i.e. the policy tuple should be inside the braces along with type, hook, device
& priority. Also the device & priority tuples each need to be followed by a
semicolon.

** Is the above change correct?

* Assuming it is correct, the patch below makes the change. Can someone pick it
  up from here or should I submit a bug report?

Cheers ... Duncan.

---

diff --git a/doc/nft.xml b/doc/nft.xml
index c0f42dd..80ffcd7 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -664,9 +664,9 @@ filter input iif $int_ifs accept
						<arg choice="req"><replaceable>type</replaceable></arg>
						<arg choice="req"><replaceable>hook</replaceable></arg>
						<arg choice="opt"><replaceable>device</replaceable></arg>
-						<arg choice="req"><replaceable>priority</replaceable></arg>
+						<arg choice="req"><replaceable>priority</replaceable> ;</arg>
+						<arg choice="opt"><replaceable>policy</replaceable> ;</arg>
					</arg>
-					<arg choice="opt"><replaceable>policy</replaceable></arg>
				</arg>
			</cmdsynopsis>
			<cmdsynopsis>
