From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] src: add --check option flag
Date: Mon, 26 Jun 2017 19:00:26 +0200
Message-ID: <20170626170026.GB9650@salvia>
References: <20170623163825.2066-1-pablombg@gmail.com>
 <20170623163825.2066-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34358 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751101AbdFZRAj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 13:00:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 20FB2E0421
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:00:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11F041B4044
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:00:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EBE901B4046
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:00:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170623163825.2066-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 23, 2017 at 06:38:25PM +0200, Pablo M. Bermudo Garay wrote:
> Sometimes it can be useful to test if a command is valid without
> applying any change to the rule-set. This commit adds a new option
> flag (-c | --check) that performs a dry run execution of the commands.

Also applied, thanks!
