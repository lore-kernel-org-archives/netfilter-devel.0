From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 2/2] netfilter: nf_ct_expect: Change
 __nf_ct_expect_check() return value.
Date: Sat, 25 Feb 2017 13:35:14 +0100
Message-ID: <20170225123514.GB27078@salvia>
References: <1487898534-64560-1-git-send-email-jarno@ovn.org>
 <1487898534-64560-2-git-send-email-jarno@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fgao@ikuai8.com
To: Jarno Rajahalme <jarno@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53036 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751231AbdBYMpW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Feb 2017 07:45:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0500D96ED8
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 13:35:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EB539DA80B
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 13:35:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C958ADA7FA
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 13:35:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1487898534-64560-2-git-send-email-jarno@ovn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 23, 2017 at 05:08:54PM -0800, Jarno Rajahalme wrote:
> Commit 4dee62b1b9b4 ("netfilter: nf_ct_expect: nf_ct_expect_insert()
> returns void") inadvertently changed the successful return value of
> nf_ct_expect_related_report() from 0 to 1 due to
> __nf_ct_expect_check() returning 1 on success.  Prevent this
> regression in the future by changing the return value of
> __nf_ct_expect_check() to 0 on success.

We used to return 0 via __nf_ct_expect_check() in the past, not
anymore for a while. So even if this doesn't fix anything, I'm fine
with this change to prevent more sloppy updates on this code.

Applied, thanks.
