From: Tejun Heo <tj@kernel.org>
Subject: [PATCH iptables] extensions: libxt_cgroup: add unit test
Date: Mon, 28 Dec 2015 16:41:20 -0500
Message-ID: <20151228214120.GC30165@mtj.duckdns.org>
References: <20151222185626.GC5003@mtj.duckdns.org>
 <20151222185707.GD5003@mtj.duckdns.org>
 <20151225121822.GB7273@salvia>
 <20151225121914.GA7306@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:35221 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbbL1VlW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2015 16:41:22 -0500
Received: by mail-yk0-f177.google.com with SMTP id x67so112992558ykd.2
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 13:41:21 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151225121914.GA7306@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add basic tests which depend only on the root cgroup.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 extensions/libxt_cgroup.t |    8 ++++++++
 1 file changed, 8 insertions(+)

--- /dev/null
+++ b/extensions/libxt_cgroup.t
@@ -0,0 +1,8 @@
+:INPUT,OUTPUT,POSTROUTING
+*mangle
+-m cgroup --cgroup 1;=;OK
+-m cgroup ! --cgroup 1;=;OK
+-m cgroup --path "/";=;OK
+-m cgroup ! --path "/";=;OK
+-m cgroup --cgroup 1 --path "/";;FAIL
+-m cgroup ;;FAIL
