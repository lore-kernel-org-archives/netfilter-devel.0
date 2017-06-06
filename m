From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 3/3] xtables-translate: fix double space before
 comment
Date: Tue, 6 Jun 2017 17:43:35 +0200
Message-ID: <20170606154335.GC11008@salvia>
References: <20170605220828.4738-1-pablombg@gmail.com>
 <20170605220828.4738-3-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53134 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751281AbdFFPnj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 11:43:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4CCA61F4B71
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:43:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 38FFA100796
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:43:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3BF41021B7
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 17:43:27 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170605220828.4738-3-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 06, 2017 at 12:08:28AM +0200, Pablo M. Bermudo Garay wrote:
> When a comment translation immediately follows a counter statement, two
> spaces are printed between "counter" and "comment" keywords.
> 
> The counter statement is almost always followed by a target, so we need
> to move the space following "counter" to the beginning of the target
> translation.

Neat, applied, thanks.
