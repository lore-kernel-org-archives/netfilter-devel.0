From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: add test file for TCPMSS extension
Date: Tue, 17 Oct 2017 13:56:28 +0200
Message-ID: <20171017115628.GA11588@salvia>
References: <1508187729-3926-1-git-send-email-aastha.gupta4104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel@googlegroups.com, netfilter-devel@vger.kernel.org
To: Aastha Gupta <aastha.gupta4104@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55032 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933071AbdJQL4c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 07:56:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 170704B0F8
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 13:56:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08E9FDA86E
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 13:56:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1508187729-3926-1-git-send-email-aastha.gupta4104@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 17, 2017 at 02:32:09AM +0530, Aastha Gupta wrote:
> This adds test file for the recently added TCPMSS extension.

I'm taking this last version, it doesn't say v4 but looking at timing,
it is the last one you have submitted.

Applied, thanks. If there is anything you need to fix, send me a
follow up patch.
