From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 1/3] tests: xlate: generalize owner
Date: Tue, 6 Jun 2017 17:43:12 +0200
Message-ID: <20170606154312.GA11008@salvia>
References: <20170605220828.4738-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52914 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751281AbdFFPnR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 11:43:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E22251F4B6C
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:43:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7254FF2D7
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:43:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7856102190
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:43:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170605220828.4738-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 06, 2017 at 12:08:26AM +0200, Pablo M. Bermudo Garay wrote:
> The owner name was hard-coded in the owner extension translation test.
> The translation process requires the user to exist in the system, so
> this commit replaces it with the usual UID_MIN value (1000).

Applied, thanks.
