From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/1] netfilter: sip: Use mod_timer_pending
 instead of current multiple statements
Date: Sun, 12 Feb 2017 14:36:52 +0100
Message-ID: <20170212133652.GA2451@salvia>
References: <1486630005-58605-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43796 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751206AbdBLNhB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Feb 2017 08:37:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B558F96EC7
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 14:36:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7AB5DA801
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 14:36:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1331DA7E0
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 14:36:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1486630005-58605-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 09, 2017 at 04:46:45PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> Current statements is del and add, it could be replaced by
> mod_timer_pending.

Applied.
