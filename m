From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: add test file for TCPMSS extension
Date: Tue, 17 Oct 2017 14:00:13 +0200
Message-ID: <20171017120013.GB11588@salvia>
References: <1508187729-3926-1-git-send-email-aastha.gupta4104@gmail.com>
 <20171017115628.GA11588@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel@googlegroups.com, netfilter-devel@vger.kernel.org
To: Aastha Gupta <aastha.gupta4104@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57278 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934018AbdJQMAT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 08:00:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E88544D656
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 14:00:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9AB5DA38B
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 14:00:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171017115628.GA11588@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 17, 2017 at 01:56:28PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 17, 2017 at 02:32:09AM +0530, Aastha Gupta wrote:
> > This adds test file for the recently added TCPMSS extension.
> 
> I'm taking this last version, it doesn't say v4 but looking at timing,
> it is the last one you have submitted.
> 
> Applied, thanks. If there is anything you need to fix, send me a
> follow up patch.

Oh, I understand, this is the test file. Other patches add the
translation.
