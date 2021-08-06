Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFEDC4338F
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 15:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5E6660EB2
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 15:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241898AbhHFPGW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Aug 2021 11:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241348AbhHFPGW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Aug 2021 11:06:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5128A60F38;
        Fri,  6 Aug 2021 15:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628262366;
        bh=sL9gRwBjC6cQZ5ASP54mYtVEvj2/vyDHmOrnz38a98Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nCoIXs7JxyXR1pl+Q+Smb+fX98eEvJCA3Jw7g3XfyKrVk7wOIpY9EpxhMA+HZGLXc
         3x9IVTfar58z7910QfPsth6YJ9cFoADhXwulLyGHFVF1vAviNd/uI4dfJMeTzGWywL
         dnUadOC7ujz278kkS2YL668Yi7GxMwhdkZVfejgoUQRLGB8eK5eQfZvUsyMUG/ZgCd
         utrNgAdx5xolSOMP7eNk4i21e59+I1otxPA0EY6AupKYeulakmAJdIAmbdoeauibEg
         EilUnnsX5wQf9o0oUgJxX7Elmvrm5oeKLlQBQrGwSPO15RX641JmJkKVb4fqp75/DK
         hrmsNZCjznaSA==
Date:   Fri, 6 Aug 2021 08:06:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH net 3/9] netfilter: conntrack: collect all entries in
 one cycle
Message-ID: <20210806080605.262d29ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210806145954.GA1405@salvia>
References: <20210806115207.2976-1-pablo@netfilter.org>
        <20210806115207.2976-4-pablo@netfilter.org>
        <20210806062759.2acb5a47@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210806145954.GA1405@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 6 Aug 2021 16:59:54 +0200 Pablo Neira Ayuso wrote:
> On Fri, Aug 06, 2021 at 06:27:59AM -0700, Jakub Kicinski wrote:
> > On Fri,  6 Aug 2021 13:52:01 +0200 Pablo Neira Ayuso wrote:  
> > >  		rcu_read_lock();
> > >  
> > >  		nf_conntrack_get_ht(&ct_hash, &hashsz);
> > >  		if (i >= hashsz)
> > > -			i = 0;
> > > +			break;  
> > 
> > Sparse says there is a missing rcu_read_unlock() here.
> > Please follow up on this one.  
> 
> Right.
> 
> I can squash this fix and send another PR or send a follow up patch.
> 
> Let me know your preference.

Squash is better if you don't mind overwriting history.
I'll toss this version from patchwork, then.
