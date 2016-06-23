From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/4] netfilter: xt_TRACE: add explicitly
 nf_logger_find_get call
Date: Thu, 23 Jun 2016 19:26:50 +0200
Message-ID: <20160623172650.GA2175@salvia>
References: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
 <1465389800-27842-4-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54518 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbcFWR1A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 13:27:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6A4708D051B
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:26:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5A1139EBBA
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:26:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9E9B09EBBD
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:26:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465389800-27842-4-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 08, 2016 at 08:43:19PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Consider such situation, if nf_log_ipv4 kernel module is not installed,
> and the user add a following iptables rule:
>   # iptables -t raw -I PREROUTING -j TRACE
> 
> There will be no trace log generated until the user install nf_log_ipv4
> module manully. So we should add request related nf_log module
> appropriately here.

Applied, thanks.
