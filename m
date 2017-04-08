From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ctnetlink: make it safer when checking the
 ct helper name
Date: Sat, 8 Apr 2017 23:10:30 +0200
Message-ID: <20170408211030.GA5301@salvia>
References: <1491051344-29766-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, cernekee@chromium.org,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60382 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750982AbdDHVKh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2017 17:10:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6B67F24935
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:10:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E944DA7E9
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:10:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 540A1DA7F7
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:10:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491051344-29766-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 01, 2017 at 08:55:44PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> One CPU is doing ctnetlink_change_helper(), while another CPU is doing
> unhelp() at the same time. So even if help->helper is not NULL at first,
> the later statement strcmp(help->helper->name, ...) may still access
> the NULL pointer.
> 
> So we must use rcu_read_lock and rcu_dereference to avoid such _bad_
> thing happen.

Applied, thanks.
