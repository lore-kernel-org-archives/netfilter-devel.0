From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v4 1/1] netfilter: nf_tables: Eliminate
 duplicated codes in nf_tables_table_enable
Date: Thu, 2 Feb 2017 14:29:50 +0100
Message-ID: <20170202132950.GA11239@salvia>
References: <1484919643-106032-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36960 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750876AbdBBNaB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Feb 2017 08:30:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 70675131CB4
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Feb 2017 14:29:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55EF3DA807
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Feb 2017 14:29:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61D5BDA807
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Feb 2017 14:29:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1484919643-106032-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 20, 2017 at 09:40:43PM +0800, fgao@ikuai8.com wrote:
> From: Feng <fgao@ikuai8.com>
> 
> When something failed in nf_tables_table_enable, it would unregister
> the chains. But the rollback codes are same as nf_tables_table_disable
> almostly, except there is one counter check.
> Now create one wrapper function to eliminate the duplicated codes.

Applied, thanks feng.
