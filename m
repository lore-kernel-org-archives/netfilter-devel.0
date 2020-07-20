Return-Path: <SRS0=qgEK=A7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E05C433F7
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jul 2020 16:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF8EE2176B
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jul 2020 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595263131;
	bh=wlqo7kAx+og7PtKyjy/9X5uYlujAIR96QYTi8/c6yXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IbW7ktsXnqzZO6NUNwxMvOdX2SyQqjl1LrB7k3tRfszSERXDUCdTpH0FysG+XCV7z
	 Gem99uenQD5LOiBLq49hJ19RRjOA1zpgEV97oZEknK3xHWxTXr0roHuISQiJzD2StU
	 GH+mnU0HalBa0BivJ8UD8ckcT2sC1A9nK98pjqaA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389055AbgGTQim (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jul 2020 12:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732718AbgGTQik (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jul 2020 12:38:40 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2634122CBB;
        Mon, 20 Jul 2020 16:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595263119;
        bh=wlqo7kAx+og7PtKyjy/9X5uYlujAIR96QYTi8/c6yXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KedFP10soudJd9FGCXk2UQ6mwGYV9FfLgr9Jehpfqo3DeBMYh9Cg2T64ka4vLb/9E
         yZE0kTEtUh1mwFGolpaTN3qJTAigCNeN60HjhesQSQimi39aadhKkQmY9ZpzWdIGAc
         DM8CICk2pF95QKtAIcFlAv4SRPp0hIAXO+8S+9xE=
Date:   Mon, 20 Jul 2020 09:38:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: get rid of the address_space override in setsockopt
Message-ID: <20200720163836.GB1292162@gmail.com>
References: <20200720124737.118617-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720124737.118617-1-hch@lst.de>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 20, 2020 at 02:47:13PM +0200, Christoph Hellwig wrote:
> Hi Dave,
> 
> setsockopt is the last place in architecture-independ code that still
> uses set_fs to force the uaccess routines to operate on kernel pointers.
> 
> This series adds a new sockptr_t type that can contained either a kernel
> or user pointer, and which has accessors that do the right thing, and
> then uses it for setsockopt, starting by refactoring some low-level
> helpers and moving them over to it before finally doing the main
> setsockopt method.
> 
> Note that I could not get the eBPF selftests to work, so this has been
> tested with a testing patch that always copies the data first and passes
> a kernel pointer.  This is something that works for most common sockopts
> (and is something that the ePBF support relies on), but unfortunately
> in various corner cases we either don't use the passed in length, or in
> one case actually copy data back from setsockopt, so we unfortunately
> can't just always do the copy in the highlevel code, which would have
> been much nicer.
> 

Please mention what git tree your patchset applies to.

- Eric
