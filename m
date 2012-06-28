From: Josh Hunt <johunt@akamai.com>
Subject: ipv6 tarpitting
Date: Thu, 28 Jun 2012 10:16:32 -0500
Message-ID: <4FEC7550.5020206@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:40156 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755284Ab2F1PZC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jun 2012 11:25:02 -0400
Received: from prod-mail-xrelay05.akamai.com (localhost.localdomain [127.0.0.1])
	by postfix.imss70 (Postfix) with ESMTP id 92A5F1C48CD
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jun 2012 15:16:33 +0000 (GMT)
Received: from prod-mail-relay03.akamai.com (prod-mail-relay03.akamai.com [172.27.8.26])
	by prod-mail-xrelay05.akamai.com (Postfix) with ESMTP id 87A331C48CB
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jun 2012 15:16:33 +0000 (GMT)
Received: from [172.19.64.220] (johunt-desktop.sanmateo.corp.akamai.com [172.19.64.220])
	by prod-mail-relay03.akamai.com (Postfix) with ESMTP id 42B782FD62
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jun 2012 15:16:33 +0000 (GMT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I was looking to extend the xt_TARPIT module to support IPv6, but wanted
to see if any work had already been done in this area before I spend
some time on it. I did not see support for it in the latest git or on
the module list link on xtables-addons.sourceforge.net. Is anyone aware
if this work has already been done?

Thanks
Josh
