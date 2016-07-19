From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nft_log: fix possible memory leak
 if log expr init fail
Date: Tue, 19 Jul 2016 20:13:52 +0200
Message-ID: <20160719181352.GB6116@salvia>
References: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
 <1468845857-30291-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57275 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933AbcGSSOB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jul 2016 14:14:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A5AAC114819
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:13:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 96171DA8F3
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:13:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 63A099EBBA
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:13:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1468845857-30291-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 18, 2016 at 08:44:15PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Suppose that we specify the NFTA_LOG_PREFIX, then NFTA_LOG_LEVEL
> and NFTA_LOG_GROUP are specified together or nf_logger_find_get
> call returns fail, i.e. expr init fail, memory leak will happen.

Applied, thanks.
