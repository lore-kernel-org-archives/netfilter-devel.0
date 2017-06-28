From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 07/17] tests: ct: remove unsupported syntax
Date: Wed, 28 Jun 2017 12:06:49 +0200
Message-ID: <20170628100659.26976-8-fw@strlen.de>
References: <20170628100659.26976-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33366 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751536AbdF1KHG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:07:06 -0400
In-Reply-To: <20170628100659.26976-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/ct.t         | 3 +--
 tests/py/any/ct.t.payload | 5 -----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index f02bd0420e68..833ffcf8bf4d 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -105,8 +105,7 @@ ct original mark 42;fail
 ct mark original;fail
 
 ct event set new;ok
-ct event set new or related or destroy or foobar;fail
-ct event set 'new | related | destroy | label';ok;ct event set new,related,destroy,label
+ct event set new, related , foobar;fail
 ct event set new,destroy;ok
 ct event set 1;ok;ct event set new
 ct event set 0x0;ok
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 20acbb9b63d1..3679ce0e58d4 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -396,11 +396,6 @@ ip test-ip4 output
   [ immediate reg 1 0x00000001 ]
   [ ct set event with reg 1 ]
 
-# ct event set 'new | related | destroy | label'
-ip test-ip4 output
-  [ immediate reg 1 0x00000407 ]
-  [ ct set event with reg 1 ]
-
 # ct event set new,destroy
 ip test-ip4 output
   [ immediate reg 1 0x00000005 ]
-- 
2.13.0

