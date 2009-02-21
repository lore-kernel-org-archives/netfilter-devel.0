From: Stephen Hemminger <shemminger@vyatta.com>
Subject: kernel header divergence
Date: Fri, 20 Feb 2009 16:30:38 -0800
Message-ID: <20090220163038.5235871d@extreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:35057 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbZBUAak (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 19:30:40 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.vyatta.com (Postfix) with ESMTP id B21464F4047
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2009 16:30:42 -0800 (PST)
Received: from mail.vyatta.com ([127.0.0.1])
	by localhost (mail.vyatta.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F4QrWOYr+zmB for <netfilter-devel@vger.kernel.org>;
	Fri, 20 Feb 2009 16:30:42 -0800 (PST)
Received: from extreme (pool-71-245-98-145.ptldor.fios.verizon.net [71.245.98.145])
	by mail.vyatta.com (Postfix) with ESMTP id E155E4F403F
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2009 16:30:41 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The headers in iptables command source (include/linux) are different than
the headers produced by the kernel header sanitation process:
  make headers_install

Has someone looked into rectifying this? 
