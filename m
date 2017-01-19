From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: report error if stateful obj's
 name is truncated
Date: Thu, 19 Jan 2017 15:09:14 +0100
Message-ID: <20170119140914.GA11241@salvia>
References: <1484834420-55121-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60636 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752822AbdASOR2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Jan 2017 09:17:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DD0771878A7
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 15:09:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD0199620C
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 15:09:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F845961E2
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 15:09:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1484834420-55121-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 19, 2017 at 10:00:20PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Currently, if the user add a stateful object with the name size exceed
> NFT_OBJ_MAXNAMELEN - 1 (i.e. 31), we truncate it down to 31 silently.
> This is not friendly, furthermore, this will cause duplicated stateful
> objects when the first 31 characters of the name is same. So limit the
> stateful object's name size to NFT_OBJ_MAXNAMELEN - 1.
> 
> After apply this patch, error message will be printed out like this:
>   # name_32=$(printf "%0.sQ" {1..32})
>   # nft add counter filter $name_32
>   <cmdline>:1:1-52: Error: Could not process rule: Numerical result out
>   of range
>   add counter filter QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Good catch.

At quick glance, I can see other spots lacking this validation:

static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] =
{
        [NFTA_CHAIN_TABLE]      = { .type = NLA_STRING },

Probably review and fix them in one go?
