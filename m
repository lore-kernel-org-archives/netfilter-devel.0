From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] src: Use nftnl_buf to export XML/JSON rules
Date: Fri, 3 Mar 2017 10:55:59 +0100
Message-ID: <20170303095559.GA12506@salvia>
References: <20170302183413.GA28448@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51512 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751641AbdCCPTx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 10:19:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C85C9170D34
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 10:56:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9BFBDA81B
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 10:56:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B0CEDA801
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 10:56:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170302183413.GA28448@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 02, 2017 at 03:34:13PM -0300, Elise Lennion wrote:
> This completes the use of nftnl_buf and its auxiliary functions to
> export XML/JSON rules.
> 
> Highly based on work from Shivani Bhardwaj <shivanib134@gmail.com>.

Applied, thanks Elise.
