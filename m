From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 3/3] Revert "evaluate: check for NULL datatype in rhs
 in lookup expr"
Date: Tue, 29 Nov 2016 22:02:32 +0100
Message-ID: <20161129210232.GC19613@salvia>
References: <b02aab6dfd61eff6e5fd9b2e517fd13f493e4887.1480350941.git.anatole@rezel.net>
 <939f5cc247927ef24c567d7ebba3112d37faae4c.1480350941.git.anatole@rezel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anatole Denis <anatole@rezel.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36302 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932508AbcK2VCh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 16:02:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0A7F8174D1C
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:02:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF1D1DA848
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:02:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02319DA85D
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:02:34 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <939f5cc247927ef24c567d7ebba3112d37faae4c.1480350941.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 05:43:10PM +0100, Anatole Denis wrote:
> This reverts commit 5afa5a164ff1c066af1ec56d875b91562882bd50.
> This commit is obsoleted by removing the possibility for a NULL right->dtype in
> the first place, at set declaration.

Also applied, thanks.
