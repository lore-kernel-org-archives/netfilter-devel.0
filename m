From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/2] netfilter: nf_ct_expect:
 nf_ct_expect_related_report(): Return zero on success.
Date: Sat, 25 Feb 2017 13:34:19 +0100
Message-ID: <20170225123419.GA27078@salvia>
References: <1487898534-64560-1-git-send-email-jarno@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fgao@ikuai8.com
To: Jarno Rajahalme <jarno@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53038 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751214AbdBYMpW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Feb 2017 07:45:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E325A96ECB
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 13:34:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5522DA795
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 13:34:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B61D8DA801
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 13:34:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1487898534-64560-1-git-send-email-jarno@ovn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 23, 2017 at 05:08:53PM -0800, Jarno Rajahalme wrote:
> Commit 4dee62b1b9b4 ("netfilter: nf_ct_expect: nf_ct_expect_insert()
> returns void") inadvertently changed the successful return value of
> nf_ct_expect_related_report() from 0 to 1, which caused openvswitch
> conntrack integration fail in FTP test cases.
> 
> Fix this by always returning zero on the success code path.

Applied, thanks Jarno.
