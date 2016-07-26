From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables 1/2] include: xtables: fix struct definitions grepability
Date: Tue, 26 Jul 2016 18:45:23 +0200
Message-ID: <20160726164524.29906-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32869 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbcGZQqc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 12:46:32 -0400
Received: by mail-wm0-f66.google.com with SMTP id o80so2564902wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 09:46:31 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 include/xtables.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index 9701612..73ab825 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -220,8 +220,7 @@ struct xt_xlate_tg_params {
 };
 
 /* Include file for additions: new matches and targets. */
-struct xtables_match
-{
+struct xtables_match {
 	/*
 	 * ABI/API version this module requires. Must be first member,
 	 * as the rest of this struct may be subject to ABI changes.
@@ -298,8 +297,7 @@ struct xtables_match
 	unsigned int loaded; /* simulate loading so options are merged properly */
 };
 
-struct xtables_target
-{
+struct xtables_target {
 	/*
 	 * ABI/API version this module requires. Must be first member,
 	 * as the rest of this struct may be subject to ABI changes.
-- 
2.9.0

