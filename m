From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: shell: Add test for flush bug on sets with
 size
Date: Tue, 24 Jan 2017 19:34:43 +0100
Message-ID: <20170124183443.GA7829@salvia>
References: <20170123224159.GA19546@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46028 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdAXSfA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2017 13:35:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1BF031D94A8
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:34:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B73BA7E7D
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:34:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA6B2DA8F5
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:34:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170123224159.GA19546@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 23, 2017 at 08:42:00PM -0200, Elise Lennion wrote:
> This tests for a bug where elements can't be added after flushing a
> full set with the flag NFTNL_SET_DESC_SIZE set.

Applied, thanks Elise.
