From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Interrest in a ASA-like packet tracer?
Date: Tue, 21 Mar 2017 15:35:45 +0100
Message-ID: <20170321143545.GA17321@salvia>
References: <0fa8faae-5c9e-61b9-ad3f-1ea386555fef@postrobot.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Oliver =?iso-8859-1?Q?Schr=F6der?= <netfilter@postrobot.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33834 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932499AbdCUOfz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 10:35:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 10E21170D4B
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 15:35:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EB2B9FB44E
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 15:35:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96800FB464
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 15:35:48 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <0fa8faae-5c9e-61b9-ad3f-1ea386555fef@postrobot.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 20, 2017 at 01:33:33PM +0100, Oliver Schröder wrote:
> Hi list,
> 
> inspired by the 'packet-tracer' cli-command of cisco ASAs I have
> implemented a linux application with the same functionality. For those
> of you who are not familiar with the command, please read up at lpt's
> homepage: http://www.o-schroeder.de/projects/lpt/
> 
> My question is if this might be of interrest to you? I believe it is a
> very useful command and possibly should be integrated in iptables?
> 
> What do you think?

Did you have a look at 'nft monitor'?

I'm very much interested in getting feedback on if there is anything
missing there compared to your tracer.

Thanks.
