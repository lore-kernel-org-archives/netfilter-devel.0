Return-Path: <SRS0=ah1+=RK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FROM_BLANK_NAME,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B9BC43381
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Mar 2019 22:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8800320840
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Mar 2019 22:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=plushkava.net header.i=@plushkava.net header.b="n0exR6ot";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KRRaBc1j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfCGWNy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 17:13:54 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:47741 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726166AbfCGWNx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 17:13:53 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 9DBA4379A;
        Thu,  7 Mar 2019 17:13:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Thu, 07 Mar 2019 17:13:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plushkava.net;
         h=date:from:to:cc:subject:message-id:in-reply-to:references
        :mime-version:content-type:content-transfer-encoding; s=fm2; bh=
        QlCqMr1lkr9yi4BMTUoZu3vBnBWWx3Ct9L2fhRr5QrI=; b=n0exR6otYbMyG4nH
        r9sUnd1CYhHwm6iQf3F3mAnqPSR13ufWSyTu1efdMkk5K6qt9dMybbq4zKNG3Mno
        sKaxUMRO7Bj8DLIojqc0piDF1YU7stMjzSKu/bhvKsiHyjkKZ+wlDlOCTW6fR1Tp
        VpsGYiP+L0rq33jVvgf85BtMpKdd4yAta1dJ3c4emPic/3EbKRHvt2uvqm36HB5L
        IvnWb3K4i+px0l1MXoYfIw9ZU9wVB7m5ZjU9NzDNccRqlCWTKmLIl34sI/pjqAn6
        AnAq9BxtK/FJSvFiFYQ7szo6CfIAufySCEcwqCNDxF3atDyuRzm64RZzKdKJpfTt
        lLBP9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=QlCqMr1lkr9yi4BMTUoZu3vBnBWWx3Ct9L2fhRr5Q
        rI=; b=KRRaBc1jZuUUykmE6XGDgLBrrRbOOPcIP/iHB8AeVhVEfYWHyuZVE3DF9
        BkiGX5nXCBAKPXgs+3uG08pOKmi4vHmIqh9yVpvahp0LDLZAl8JYmN941AvcbsML
        2mDPUocYofPH/Tj1JsmEt5Yw4XzXBuk9HUpMftN68/PKSjdjAft2CoHAWagOzjcz
        dmlwHmW8E6nljvntqPmQ9Gs7UacxRgws2VKK9ndhFo4f3qTdyv+25NsZxryF5VtJ
        S84DoP6JivQdyTKn2ngw1c+EO7ZCwhgde6gYTujzKWHbMdsIxEvQUdXeB1bZZgnL
        Ai8zULdDTuMfNpaSa1xUFGuX/IzGA==
X-ME-Sender: <xms:n5eBXDwAYVW1lDfsQJAf5FJTLeSdF1_cFhqkoAogy6xr31YwGOCXsg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedutddrfeekgdduieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gogfhmphhthietlhhirghsucdlfeelmdenucfjughrpeffhffvuffkjghfofggtgfgseht
    jeertdfjtddvnecuhfhrohhmpedffdcuoehkfhhmsehplhhushhhkhgrvhgrrdhnvghtqe
    enucffohhmrghinhepnhgvthhfihhlthgvrhdrohhrghenucfkphepudelfedrudefkedr
    vddukedrudeltdenucfrrghrrghmpehmrghilhhfrhhomhepkhhfmhesphhluhhshhhkrg
    hvrgdrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:n5eBXDCFnagxDleVtMLiClrthsjP2SzyKXY3Wgei_At9ZEB9KvX2CQ>
    <xmx:n5eBXAZRXCOEWMKECIn2PXiPl2undfaEGeIVovbD6LNAQBXAOaIlrQ>
    <xmx:n5eBXLhkM-9DMbr9BkLsRMPca0xMgFZfyqMYAr4800KAcPUyPt7FMw>
    <xmx:oJeBXB8dq5zKvvyZnVGcXhxLgX3Qm_dkjm7BHvTSE-jgcldIcmVvDg>
Received: from DESKTOP-PNG603L (unknown [193.138.218.190])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0071910310;
        Thu,  7 Mar 2019 17:13:50 -0500 (EST)
Date:   Thu, 7 Mar 2019 22:13:49 +0000
From:   "" <kfm@plushkava.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix set double-free in abort
 path
Message-Id: <20190307221349.a397e632caa06362305621df@plushkava.net>
In-Reply-To: <20190307193041.28798-1-fw@strlen.de>
References: <20190307193041.28798-1-fw@strlen.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Thu,  7 Mar 2019 20:30:41 +0100
Florian Westphal <fw@strlen.de> wrote:

> The abort path can cause a double-free of an (anon) set.
> 
> Added-and-to-be-aborted rule looks like this:
> 
> udp dport { 137, 138 } drop
> 
> The to-be-aborted transaction list looks like this:
> newset
> newsetelem
> newsetelem
> rule
> 
> This gets walked in reverse order, so first pass disables
> the rule, the set elements, then the set.
> 
> After synchronize_rcu(), we then destroy those in same order:
> rule, set element, set element, newset.
> 
> Problem is that the (anon) set has already been bound to the rule,
> so the rule (lookup expression destructor) already frees the set,
> when then cause use-after-free when trying to delete the elements
> from this set, then try to free the set again when handling the
> newset expression.
> 
> To resolve this, check in first phase if the newset is bound already.
> If so, remove the newset transaction from the list, rule destructor
> will handle cleanup.
> 
> This is still causes the use-after-free on set element removal.
> To handle this, move all affected set elements to a extra list
> and process it first.
> 
> This forces strict 'destroy elements, then set' ordering.
> 
> Fixes: f6ac8585897684 ("netfilter: nf_tables: unbind set in rule from commit path")
> Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1325
> Signed-off-by: Florian Westphal <fw@strlen.de>

<snip>

Thank you. I can confirm that, after applying this patch, I am able to check - and load - my entire ruleset without incident.

-- 
Kerin Millar <kfm@plushkava.net>
