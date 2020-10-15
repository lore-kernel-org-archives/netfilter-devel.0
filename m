Return-Path: <SRS0=46WK=DW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5666FC433E7
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 18:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0326F22203
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602788084;
	bh=UIkTh2LW6GxJ01HN/FOH/tzqZspvRrpV9rvLtD7I3Xs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=txbRDQS8UQ1fIYzHWxec7I8eg6l1zwff71qtkMOy2FAgXhqL6V6rC4U8Kqo0M6MHF
	 PRl0AREN/WjJExzFgzl4soPdN20YD+9ladTOrEBBnFMolleFET3tH0DLaYdu/FLTX2
	 Rb+4t9oH1lG8t7HeJQ0jTimtYsdMQTX8YIMdwdbg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgJOSym (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Oct 2020 14:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgJOSym (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Oct 2020 14:54:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DDD521527;
        Thu, 15 Oct 2020 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602788081;
        bh=UIkTh2LW6GxJ01HN/FOH/tzqZspvRrpV9rvLtD7I3Xs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y8y2nsKTLb0TxsBSKYjAEtQNxFaok9hIyRyO49xkB/M9Bol9SHfbW5f8DGMpquLMY
         kZhq8Qjxbj6CwdWJBpUbZUtv+wN3j8BFTIN4VFdSOjN2BtjIo+oZM4bJhSQAFaPC8g
         o/hqq85JdJmyF/RRlqxt3QvBdjI34HTwQCSVcWRU=
Date:   Thu, 15 Oct 2020 11:54:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nftables: allow re-computing sctp
 CRC-32C in 'payload' statements
Message-ID: <20201015115439.7791c3f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015163927.28730-1-pablo@netfilter.org>
References: <20201015163927.28730-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 15 Oct 2020 18:39:27 +0200 Pablo Neira Ayuso wrote:
> From: Davide Caratti <dcaratti@redhat.com>
> 
> nftables payload statements are used to mangle SCTP headers, but they can
> only replace the Internet Checksum. As a consequence, nftables rules that
> mangle sport/dport/vtag in SCTP headers potentially generate packets that
> are discarded by the receiver, unless the CRC-32C is "offloaded" (e.g the
> rule mangles a skb having 'ip_summed' equal to 'CHECKSUM_PARTIAL'.
> 
> Fix this extending uAPI definitions and L4 checksum update function, in a
> way that userspace programs (e.g. nft) can instruct the kernel to compute
> CRC-32C in SCTP headers. Also ensure that LIBCRC32C is built if NF_TABLES
> is 'y' or 'm' in the kernel build configuration.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Jakub: This is my last pending item in nf-next I think, I'm not planning to
> 	send a pull request for a single patch, so please directly apply this
> 	one to net-next. Thank you.

Applied, thanks!
