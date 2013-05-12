From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] ipset: Fix syntax error of bash completion in Debian
 environment
Date: Sun, 12 May 2013 16:28:29 +0700
Message-ID: <20130512092829.GA9286@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, neo.neutron@gmail.com
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:50490 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3ELJ2g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 May 2013 05:28:36 -0400
Received: by mail-pa0-f53.google.com with SMTP id kq12so3900553pab.12
        for <netfilter-devel@vger.kernel.org>; Sun, 12 May 2013 02:28:36 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Debian packaging tool (lintian) warns the syntax error of bash completion
as it uses the extglob shell option that should be run in
the ** #!/usr/bin/env bash ** and the shell option set should be moved to
global scope.

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 utils/ipset_bash_completion/ipset_bash_completion |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/utils/ipset_bash_completion/ipset_bash_completion b/utils/ipset_bash_completion/ipset_bash_completion
index cc7ea7b..8a0b91d 100644
--- a/utils/ipset_bash_completion/ipset_bash_completion
+++ b/utils/ipset_bash_completion/ipset_bash_completion
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 
 # -----------------------------------------------------------------
 # Programmable completion code for ipset (netfilter.org)
@@ -47,6 +47,8 @@
 #
 # -----------------------------------------------------------------
 
+shopt -s extglob
+
 # -----------------------------------------------------------------
 # Functions
 # -----------------------------------------------------------------
@@ -537,7 +539,6 @@ done < "${_IPSET_IPLIST_FILE}"
 # -----------------------------------------------------------------
 
 _ipset_complete() {
-shopt -s extglob
 local cur prev cword words ips_version
 local str_action str_setname str_type str_filename
 local str_glob str_regex str_prefix str_suffix
-- 
1.7.10.4

