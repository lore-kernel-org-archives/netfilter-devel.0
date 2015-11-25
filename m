From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: Link libext_arpt to static build
Date: Wed, 25 Nov 2015 20:45:41 +0100
Message-ID: <20151125194541.GA12517@salvia>
References: <1448273927-24853-1-git-send-email-daniel.wagner@bmw-carit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Daniel Wagner <daniel.wagner@bmw-carit.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39840 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbbKYTpx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 14:45:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 060ED12925A
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 20:45:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EBE7CDA795
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 20:45:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A8514DA7FF
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 20:45:47 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1448273927-24853-1-git-send-email-daniel.wagner@bmw-carit.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 23, 2015 at 11:18:47AM +0100, Daniel Wagner wrote:
> The libext_arpt is not included when linking the static version of
> iptables.
> 
> Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
> ---
> Hi,
> 
> I had some troubles getting a static version of iptables. Not sure
> if I fixed it correctly. Anyway I am able to proceed with testing.

Could you tell me what options you're using to compile iptables so I
can try to reproduce it?

Thanks.
