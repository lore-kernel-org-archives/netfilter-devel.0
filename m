From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 6/9] tests: py: add ct helper tests
Date: Wed, 15 Mar 2017 11:39:33 +0100
Message-ID: <20170315103933.GA11143@salvia>
References: <20170314195816.1721-1-fw@strlen.de>
 <20170314195816.1721-7-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41568 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbdCOKju (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 06:39:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0163A24624
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 11:39:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C211BAC2B
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 11:39:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 566B7DA874
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 11:39:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170314195816.1721-7-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 14, 2017 at 08:58:13PM +0100, Florian Westphal wrote:
> +%cthelp1 type ct helper { type \"ftp\"\; protocol tcp\; };ok

Just a minor syntax nitpick here.

Protocol should be part of the same statement, right? ie.

{ type "ftp" protocol tcp ; }

It fundamental to achieve a working configuration. You can send a
follow up patch to amend this, no problem.
