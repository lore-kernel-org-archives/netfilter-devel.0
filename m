From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] configure: make libmnl and libnftnl hard
 requirements
Date: Wed, 27 Apr 2016 19:09:40 +0200
Message-ID: <20160427170940.GA7335@salvia>
References: <1461698878-4459-1-git-send-email-giuseppe@glongo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40175 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbcD0RJ4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 13:09:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 05DEE1522C3
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:09:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E2273FAB44
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:09:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1C967D1D85
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 19:09:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1461698878-4459-1-git-send-email-giuseppe@glongo.it>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 26, 2016 at 09:27:58PM +0200, Giuseppe Longo wrote:
> From: Giuseppe Longo <giuseppelng@gmail.com>
> 
> Iptables building is broken if either libmnl orlibnftnl
> is not installed on the system.
> 
> Configure script actually checks if libmnl and libnftnl are installed,
> but doesn't exit if they are not.

Applied, thanks Giuseppe.
