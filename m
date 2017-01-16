From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2] src: Allow to list ruleset without stateful
 information
Date: Mon, 16 Jan 2017 22:05:33 +0100
Message-ID: <20170116210533.GA20792@salvia>
References: <20170116204040.GA21753@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58786 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751128AbdAPVFk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 16:05:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 29CDDE5A4D
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 22:05:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A539FF121
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 22:05:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA017A7DB0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 22:05:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170116204040.GA21753@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 16, 2017 at 06:40:40PM -0200, Elise Lennion wrote:
> Currently only counter and quota have stateful information.
> 
> For named counters, packets and bytes are displayed as 0.
> 
> Standard list ruleset:
> 
> table ip filter {
> 	counter https {
> 		packets 161942 bytes 10253353
> 	}
> 
> 	chain output {
> 		type filter hook output priority 0; policy accept;
> 		counter name tcp dport map { https : "https"}
> 		tcp dport https counter packets 171211 bytes 10869045
> 		tcp dport https quota 25 mbytes used 10 mbytes
> 	}
> }
> 
> With stateless option, -s:
> 
> table ip filter {
> 	counter https {
> 		packets 0 bytes 0
> 	}
> 
> 	chain output {
> 		type filter hook output priority 0; policy accept;
> 		counter name tcp dport map { https : "https"}
> 		tcp dport https counter
> 		tcp dport https quota 25 mbytes
> 	}
> }

Applied, thanks Elise.
