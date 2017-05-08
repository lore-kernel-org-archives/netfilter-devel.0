From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] libxtables: Display weird character warning for
 wildcards
Date: Mon, 8 May 2017 20:02:25 +0200
Message-ID: <20170508180225.GA8008@salvia>
References: <1493982710-10847-1-git-send-email-ojford@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oliver Ford <ojford@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59862 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbdEHSCe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 14:02:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 835702519B3
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 20:02:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74B941B909E
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 20:02:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71F341B9094
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 20:02:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1493982710-10847-1-git-send-email-ojford@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 05, 2017 at 11:11:50AM +0000, Oliver Ford wrote:
> Change the scope of the weird character check loop so that
> it checks for invalid characters when the interface name
> contains a wildcard.
> 
> Fixes Bugzilla #1085.

Applied, thanks.
