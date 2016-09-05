From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v3] xtables-translate-restore: do not escape
 quotes
Date: Mon, 5 Sep 2016 19:11:35 +0200
Message-ID: <20160905171135.GA21759@salvia>
References: <20160831075916.4432-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56236 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933302AbcIERLv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 13:11:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 31580231666
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:11:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22A611150C6
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:11:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FABAA827A
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:11:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160831075916.4432-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 31, 2016 at 09:59:16AM +0200, Pablo M. Bermudo Garay wrote:
> If quotes are escaped, nft -f is unable to parse and load the translated
> ruleset.

Applied, thanks.

It would be good to set 'cs->restore' in iptables and ip6tables.

Currently this is left unset and not used, which leaves things in
inconsistent state. Please follow up on this.
