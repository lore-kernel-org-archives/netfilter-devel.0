From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V3] netfilter: Remove duplicated rcu_read_lock.
Date: Mon, 24 Jul 2017 13:08:18 +0200
Message-ID: <20170724110818.GA6340@salvia>
References: <20170719052733.32310-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ja@ssi.bg, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39992 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751539AbdGXLIe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 07:08:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 271D7CA4AA
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 13:08:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1467BD1CA3
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 13:08:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17C3CDA57E
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 13:08:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170719052733.32310-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 19, 2017 at 02:27:33PM +0900, Taehee Yoo wrote:
> This patch removes duplicate rcu_read_lock().

Applied, thanks.
