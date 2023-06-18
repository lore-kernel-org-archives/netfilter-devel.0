Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46427EB64D7
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jun 2023 16:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjFRQFO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Jun 2023 12:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjFRQFN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Jun 2023 12:05:13 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFC81AB
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2023 09:05:11 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AC0465C00BE;
        Sun, 18 Jun 2023 12:05:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 18 Jun 2023 12:05:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plushkava.net;
         h=cc:cc:content-transfer-encoding:content-type:content-type
        :date:date:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1687104307; x=1687190707; bh=zPj3PwYkHRGAjY5BD0zBU9Z+r
        SWH2gJzES9TNEblf+o=; b=HS7R5kYJZgseq2efp4tNdHC4zPVKQEv2hlGThPnLb
        me6SzckKCZ+MYhYwJahcRolzYMunhj6R0jf5l6C2atD4wftCNfczHIYLIKeI6R+9
        u3PH5Gk8kYO++7nVcHglqBN0j3oHVfW3OJFGN5TvG1cY6eR44ze9trU0Hge7vph4
        13nrstO6keHSnTLShPOu6uJ5kSPUJBpW6N/7rIMvbt0PJij94Isr8RrJ64fCZP6e
        MskiT7l0Ww1dsR9+PfEvCughB4jVgq04qyLW0Yo3FYTygIcQcaAYuxb0Gtl/TF6u
        nkdNFZ0sasgy9fxZ6QPiDgdaAXPkD1tSC/gvCgJdHV34g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1687104307; x=1687190707; bh=zPj3PwYkHRGAjY5BD0zBU9Z+rSWH2gJzES9
        TNEblf+o=; b=WGPvHz6aTRtoygacD1KNx5rdPXQ5UyJVSljeiCgPnZux6pqQtZQ
        MFjmx/tC59Sb9c+fmkj8oU4HIoyczDAxpFhD0glN4Fg2jNnF4EyRBt9mx5tJyHJk
        jcYNKCtosgK3l6l8CUtexXYAmcTyKKRaKauyQyNB+0lajO3mtMCZrdosZLB9uRUO
        oKuhiAst2A6SmiL//6xXIO1OXY8Zs663JbRSwn1NRf6U5GF5mg7m2iTvqcyxu0tq
        S1Z5TOzDHH/pGDis7osvHBJirWsdgeODZ36//AnGqPRN+uDheapLObEqpmrHoBdP
        qFrluj0xRy/kt3gHbD8PMti9FvHDa7r9FgQ==
X-ME-Sender: <xms:MyuPZBMTcoz1QwPHkO06bGOCixKO9rJ_42DGtiqC7s4Xmhl_e7G6fg>
    <xme:MyuPZD9NL6HJ8KdG25TAuXEQdruTqXMT2kryGNWCCuw0qCJ0iGBLEG0t7Y-yp123P
    qf8lEatGZypf46D>
X-ME-Received: <xmr:MyuPZATW_u90CxIvCkalOG7hzmrK2OukZiC5F0uxD89QpP2Kj2rFrDQuWI271SP1R5pSUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeeftddgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkjghfofggtgfgsehtjeertdfjtddvnecuhfhrohhmpefmvghr
    ihhnucfoihhllhgrrhcuoehkfhhmsehplhhushhhkhgrvhgrrdhnvghtqeenucggtffrrg
    htthgvrhhnpeeihfettefhgeeftefgheeugeeffeehkedukeefffejgeeutdeggeejtdei
    hefhveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hkfhhmsehplhhushhhkhgrvhgrrdhnvght
X-ME-Proxy: <xmx:MyuPZNsjXCyEC9tRBv0pcuzBoDbFZLyrIAkiePBfZvLzSvuKdT6RHQ>
    <xmx:MyuPZJfKmd_4E63i8LXpxsuF_WeuFD1FVToQkFXkQ99somD8l9DOgw>
    <xmx:MyuPZJ2ImZYj4EuYhNWp48n-zd1GMpbWMD19LVajMr7VsDHS6geQWA>
    <xmx:MyuPZKrzRCWAZEAZomgd5Fvl7RNIqYDv8ZCnap-HaeLccpc3MgpD_Q>
Feedback-ID: i2431475f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 18 Jun 2023 12:05:06 -0400 (EDT)
Date:   Sun, 18 Jun 2023 17:05:04 +0100
From:   Kerin Millar <kfm@plushkava.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        nft.ogxzcrqhuhgchbvxcs4j7wws@qmail.sunbirdgrove.com,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nft list sets changed behavior
Message-Id: <20230618170504.182b9d8f448727491b97d92d@plushkava.net>
In-Reply-To: <ZI8hArHRm2ke+Awz@calendula>
References: <60e59333-3d37-5b66-e0ed-8e7d4c01d956@qmail.sunbirdgrove.com>
        <20230618122216.3bdd0e34776293adb0655516@plushkava.net>
        <962b1e4f-63e2-bc3b-bf27-5569c6402c0f@qmail.sunbirdgrove.com>
        <20230618133509.GA869@breakpoint.cc>
        <ZI8hArHRm2ke+Awz@calendula>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, 18 Jun 2023 17:21:38 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Sun, Jun 18, 2023 at 03:35:09PM +0200, Florian Westphal wrote:
> > moving to nf-devel
> > 
> > nft.ogxzcrqhuhgchbvxcs4j7wws@qmail.sunbirdgrove.com <nft.ogxzcrqhuhgchbvxcs4j7wws@qmail.sunbirdgrove.com> wrote:
> [...]
> > > > > After updating to Debian 12 my tools relying on 'nft -j list sets' fail.
> > > > > It now does not include the elements in those lists like it did on 11.
> > 
> > I see three possible solutions:
> > 1 - accept the breakage.
> > 2 - repair the inconsistency so we get 1.0.0 and
> >     earlier behaviour back.
> > 3 - make "list sets" *always* include set elements,
> >     unless --terse was given.
> > 
> > Thoughts? I'd go with 3, I dislike the
> > different behaviour that 2) implies and we already
> > have --terse, we just need to make use of it here.
> 
> I'd go with 3 too, so --terse is honored.

I think so too. While there is a theoretical risk of breaking someone's script in the case that they were relying upon the 'new' behaviour, the present behaviour makes very little sense.

-- 
Kerin Millar
