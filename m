From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 3/5] netfilter: drop const qualifier from struct
 nf_conntrack_expect_policy
Date: Tue, 21 Mar 2017 11:34:04 +0100
Message-ID: <20170321103404.GE1940@salvia>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
 <1489934162-7415-4-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36186 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751176AbdCUKeN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 06:34:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1410AEBAC4
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:34:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07DAADA873
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:34:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B34A7DA874
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:34:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489934162-7415-4-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 19, 2017 at 10:36:00PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> So we can modify the nf_conntrack_expect_policy directly, the next patch
> will need this.

I'm missing why you need this.
