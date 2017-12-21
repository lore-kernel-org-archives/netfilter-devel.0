From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH iptables] iptables: Remove const qualifier from struct option.
Date: Thu, 21 Dec 2017 09:05:44 +0530
Message-ID: <20171221033545.2676-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:43006 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756330AbdLUDgI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 22:36:08 -0500
Received: by mail-pg0-f67.google.com with SMTP id q67so3540587pga.9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2017 19:36:08 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As opts is reassigned multiple times, it cannot be made constant.
So remove const qualifier from structure option. This patch fixes the
following warning:

warning: initialization discards ‘const’ qualifier from pointer target
type [-Wdiscarded-qualifiers]
  .orig_opts = original_opts,

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 iptables/ip6tables.c | 2 +-
 iptables/iptables.c  | 2 +-
 iptables/xtables.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 0f6fa31a..49bd006f 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -78,7 +78,7 @@ static const char optflags[]
 
 static const char unsupported_rev[] = " [unsupported revision]";
 
-static const struct option original_opts[] = {
+static struct option original_opts[] = {
 	{.name = "append",        .has_arg = 1, .val = 'A'},
 	{.name = "delete",        .has_arg = 1, .val = 'D'},
 	{.name = "check" ,        .has_arg = 1, .val = 'C'},
diff --git a/iptables/iptables.c b/iptables/iptables.c
index e930fe26..69d19fec 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -75,7 +75,7 @@ static const char optflags[]
 
 static const char unsupported_rev[] = " [unsupported revision]";
 
-static const struct option original_opts[] = {
+static struct option original_opts[] = {
 	{.name = "append",        .has_arg = 1, .val = 'A'},
 	{.name = "delete",        .has_arg = 1, .val = 'D'},
 	{.name = "check",         .has_arg = 1, .val = 'C'},
diff --git a/iptables/xtables.c b/iptables/xtables.c
index aebe7d77..ac113254 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -59,7 +59,7 @@ static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 static const char optflags[]
 = { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c', 'f'};
 
-static const struct option original_opts[] = {
+static struct option original_opts[] = {
 	{.name = "append",	  .has_arg = 1, .val = 'A'},
 	{.name = "delete",	  .has_arg = 1, .val = 'D'},
 	{.name = "check",	  .has_arg = 1, .val = 'C'},
-- 
2.14.3

