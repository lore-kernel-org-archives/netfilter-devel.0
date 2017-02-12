From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] statement: Avoid rounding bytes in get_rate()
Date: Sun, 12 Feb 2017 14:56:17 +0100
Message-ID: <20170212135617.GC19847@salvia>
References: <20170212124534.GA2981@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47238 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751225AbdBLN4W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Feb 2017 08:56:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BD5033C33A
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 14:56:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF45DDA725
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 14:56:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96D20DA801
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 14:56:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170212124534.GA2981@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 12, 2017 at 10:45:34AM -0200, Elise Lennion wrote:
> get_rate() is used to print quotas and limits and currently rounds the
> number of bytes:
> 
> $ nft add quota filter https-quota 4000 kbytes
> $ nft list ruleset
> table ip filter {
> 	quota https-quota {
> 		3 mbytes
> 	}
> }
> 
> This may be a problem when loading your configuration after saving it
> with 'list ruleset'. With this patch the values are represented in a
> greater unit only when there is no rest in the conversion:
> 
> $ nft add quota filter https-quota2 2048 kbytes
> $ nft list ruleset
> table ip filter {
> 	quota https-quota {
> 		4000 kbytes
> 	}
> 
> 	quota https-quota2 {
> 		2 mbytes
> 	}
> }

also applied, thanks Elise.
