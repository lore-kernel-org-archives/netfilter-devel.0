From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next] netfilter: ebt: Use new helper
 ebt_invalid_target to check target
Date: Mon, 19 Jun 2017 19:11:53 +0200
Message-ID: <20170619171152.GA5024@salvia>
References: <1496220943-98621-1-git-send-email-gfree.wind@vip.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: gfree.wind@vip.163.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56582 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751129AbdFSRL5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2017 13:11:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 64FC12E7848
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:11:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58BF61021A0
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:11:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56D80100791
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:11:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1496220943-98621-1-git-send-email-gfree.wind@vip.163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 31, 2017 at 04:55:43PM +0800, gfree.wind@vip.163.com wrote:
> From: Gao Feng <gfree.wind@vip.163.com>
> 
> Use the new helper function ebt_invalid_target instead of the old
> macro INVALID_TARGET and other duplicated codes to enhance the readability.

Applied, thanks.
