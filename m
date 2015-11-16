From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] rule: move comment out of handle
Date: Mon, 16 Nov 2015 14:01:15 +0100
Message-ID: <20151116130115.GA1066@salvia>
References: <1447603985-25854-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41624 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbbKPNBX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Nov 2015 08:01:23 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1DB0011D8E5
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 14:01:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0CBF94C8FA
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 14:01:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B19B71788E6
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 14:01:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1447603985-25854-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 15, 2015 at 04:13:05PM +0000, Patrick McHardy wrote:
> The comment does not belong to the handle, it belongs to the rule.

Thanks Patrick.
