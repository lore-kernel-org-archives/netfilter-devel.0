From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 20/21] tests: add negation tests for libxt_statistic
Date: Sun, 21 Aug 2011 13:09:35 +0200
Message-ID: <1313924977-8623-21-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38784 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab1HULKB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:10:01 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Note: it is valid to check cb->invert before calling
xtables_option_parse.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 tests/options-most.rules |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tests/options-most.rules b/tests/options-most.rules
index c243649..0e876e6 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -123,6 +123,10 @@
 -A matches
 -A matches -p tcp -m tcpmss --mss 5:65535
 -A matches
+-A matches -m statistic --mode random ! --probability 0.4
+-A matches
+-A matches -m statistic --mode nth ! --every 5 --packet 2
+-A matches
 -A matches -m time --timestart 01:02:03 --timestop 04:05:06 --monthdays 1,2,3,4,5 --weekdays Mon,Fri,Sun --datestart 2001-02-03T04:05:06 --datestop 2012-09-08T09:06:05 --localtz
 -A matches
 -A matches -m time --timestart 01:02:03 --timestop 04:05:06 --monthdays 1,2,3,4,5 --weekdays Mon,Fri,Sun --datestart 2001-02-03T04:05:06 --datestop 2012-09-08T09:06:05 --kerneltz
-- 
1.7.3.4

