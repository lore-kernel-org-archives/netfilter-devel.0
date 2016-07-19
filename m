From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/3] netfilter: nft_log: check the validity of
 log level
Date: Tue, 19 Jul 2016 20:14:11 +0200
Message-ID: <20160719181411.GC6116@salvia>
References: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
 <1468845857-30291-3-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57327 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbcGSSOc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jul 2016 14:14:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BDC5F114801
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:14:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ADD029EBC4
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:14:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D35149EBBA
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:14:27 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1468845857-30291-3-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 18, 2016 at 08:44:16PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> User can specify the log level larger than 7(debug level) via
> nfnetlink, this is invalid. So in this case, we should report
> EINVAL to the userspace.

Also applied, thanks.
