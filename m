From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_cthelper] src: fix incorrect building and
 parsing of the NFCTH_POLICY_SETX attribute
Date: Fri, 24 Mar 2017 13:25:30 +0100
Message-ID: <20170324122530.GA3315@salvia>
References: <1490020522-26359-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51532 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751562AbdCXMZg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 08:25:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93FA611E586
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 13:25:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83EA9DA7E9
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 13:25:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 555D8DA873
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 13:25:30 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1490020522-26359-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 20, 2017 at 10:35:22PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> In nfct_helper_nlmsg_build_policy(), we always set the attribute type to
> NFCTH_POLICY_SET, so we cannot add more than one nfct_helper_policy to
> the kernel.
> 
> Also: in nfct_helper_nlmsg_parse_policy(), we will increase the
> helper->policy_num for each nfct_helper_policy, but we mistakenly set it
> to the total number of nfct_helper_policy. So when the total number is
> more than 3, later out of bound access will happen.

Applied, thanks Liping.
