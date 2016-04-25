From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/4] nf_tables: basic dynamic support for set intervals
Date: Mon, 25 Apr 2016 14:28:56 +0200
Message-ID: <20160425122856.GA3600@salvia>
References: <1460497837-20693-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33304 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147AbcDYMbc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 08:31:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C681F83D23
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 14:31:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B0070FAB5B
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 14:31:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6B2B4FAB5E
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 14:31:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1460497837-20693-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 12, 2016 at 11:50:33PM +0200, Pablo Neira Ayuso wrote:
> This patchset resolves the main issues with the dynamic support for
> range and its existing rb-tree implementation.

I'm applying this series now.
