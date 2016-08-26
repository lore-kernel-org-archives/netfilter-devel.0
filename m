From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v3 1/2] xtables-compat: check if nft ruleset is
 compatible
Date: Fri, 26 Aug 2016 19:36:36 +0200
Message-ID: <20160826173636.GA31435@salvia>
References: <20160826165844.6849-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58686 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751223AbcHZRgk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Aug 2016 13:36:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2FDA11022B8
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2016 19:36:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20854DA3B0
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2016 19:36:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 201A0FF2FC
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2016 19:36:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160826165844.6849-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 26, 2016 at 06:58:43PM +0200, Pablo M. Bermudo Garay wrote:
> This patch adds a verification of the compatibility between the nft
> ruleset and iptables. Nft tables, chains and rules are checked to be
> compatible with iptables. If something is not compatible, the execution
> stops and an error message is displayed to the user.
> 
> This checking is triggered by xtables-compat -L and xtables-compat-save
> commands.

Applied, thanks.
