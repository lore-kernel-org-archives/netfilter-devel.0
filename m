From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: nft_payload: add packet mangling support
Date: Wed, 25 Nov 2015 13:53:03 +0100
Message-ID: <20151125125303.GA21830@salvia>
References: <1448359222-5509-1-git-send-email-kaber@trash.net>
 <1448359222-5509-2-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37134 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbbKYMxH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 07:53:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B3B6E1324CF
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:53:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A4DB4DA804
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:53:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A8E5BDA804
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:53:04 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1448359222-5509-2-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 24, 2015 at 10:00:22AM +0000, Patrick McHardy wrote:
> Add support for mangling packet payload. Checksum for the specified base
> header is updated automatically if requested, however no updates for any
> kind of pseudo headers are supported, meaning no stateless NAT is supported.
> 
> For checksum updates different checksumming methods can be specified. The
> currently supported methods are NONE for no checksum updates, and INET for
> internet type checksums.

Applied, thanks Patrick!
