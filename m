From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 1/2] extensions: libxt_NFLOG: display nflog-size
 even if it is zero
Date: Tue, 19 Jul 2016 20:17:15 +0200
Message-ID: <20160719181715.GE6116@salvia>
References: <1468851268-35370-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57576 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbcGSSRU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jul 2016 14:17:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 90E06114804
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:17:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 81577DA8ED
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:17:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6B31ADA8ED
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:17:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1468851268-35370-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 18, 2016 at 10:14:27PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> The following iptables rules have the different semantics:
>   # iptables -A INPUT -j NFLOG
>   # iptables -A INPUT -j NFLOG --nflog-size 0
> 
> But they are all displayed as "-A INPUT -j NFLOG", so if
> the user input the following commands, the original semantics
> will be broken.
>   # iptables-save | iptables-restore

Applied, thanks.

Would you also send me a patch to add a test to libxt_NFLOG.t so we
make sure this problem never comes back again?
