From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 0/3] IPv6 tarpit support
Date: Sat,  7 Jul 2012 14:20:58 -0700
Message-ID: <1341696061-21863-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:56571 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646Ab2GGVVD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jul 2012 17:21:03 -0400
Received: from prod-mail-xrelay05.akamai.com (localhost.localdomain [127.0.0.1])
	by postfix.imss70 (Postfix) with ESMTP id 9C0341C4906
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Jul 2012 21:21:01 +0000 (GMT)
Received: from prod-mail-relay04.akamai.com (prod-mail-relay04.akamai.com [172.27.8.27])
	by prod-mail-xrelay05.akamai.com (Postfix) with ESMTP id 9095B1C4880
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Jul 2012 21:21:01 +0000 (GMT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

First attempt at adding IPv6 support for TARPIT target. Tried to follow the v4
implementation where applicable. Also borrowed some code from ip6t_REJECT.c.

Basic functionality has been tested for v4 and v6 in all 3 modes. Everything
appears to be working correctly.

Josh
