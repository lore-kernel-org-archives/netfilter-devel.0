From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] iptables-xml: Fix segfault on jump without a target
Date: Mon, 19 Jun 2017 19:30:41 +0200
Message-ID: <20170619173041.GA29767@salvia>
References: <1496417677-8228-1-git-send-email-ojford@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oliver Ford <ojford@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36328 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750905AbdFSRap (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2017 13:30:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 832C22E7848
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:30:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 768921850F
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:30:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86EF9D191C
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:30:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1496417677-8228-1-git-send-email-ojford@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 02, 2017 at 03:34:37PM +0000, Oliver Ford wrote:
> As reported in Bugzilla #1152, a segfault occurs in iptables-xml if a
> jump or goto argument lacks a target argument. The following input will
> segfault:
> *filter
> :INPUT ACCEPT [0:0]
> -A INPUT -p tcp --dport 2200 -j
> 
> Problem occurs in do_rule_part, where the existsChain() function is called
> with argv[arg + 1]. If the jump/goto argument is the last argument, then
> arg + 1 is out of the array bounds. The fix ensures that arg + 1 is within
> the array bounds before the call to existsChain() is made.

Applied, thanks.
