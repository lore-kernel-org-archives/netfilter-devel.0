Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE2CC46467
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Jan 2023 20:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbjAPUfQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbjAPUfO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2023 15:35:14 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5C42A172
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2023 12:35:08 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id vm8so70647386ejc.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2023 12:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=epust-dk.20210112.gappssmtp.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oEGJVy0Je0A9eP7lU3VskoJb5rxwqgbpHQLeMeqhiSs=;
        b=JiM3oUK/lkhKpwCxY4xNwwe5byBGZTy8SLIFsksYm/zvyiVBXg8itT/FV44hxRxUtp
         kOEFCZvhHALGSadHOT+NsNzgBy2+QC9xPhsYuLyELRmnCVySCn90vHNw0GMaSDDtlURV
         mvZHt/8TkFwLgLcoMaYl5UkJV1J1Q2q1REr0igkU0SYn7G2UZedf8Gg+IrJK0WYDEYIg
         PpM8W3z/3u/AWiYZDKq1ChaDLWp56im4gPk9mp9lbgORAKBx5A12TzznV55PWcLqtkmD
         wT5sLhEk8mEWx7g/S1N1FR198wxB1TFb5lVYyaNvu4eHw+U+lcwkbcssYWn3YzRKpGdT
         qZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oEGJVy0Je0A9eP7lU3VskoJb5rxwqgbpHQLeMeqhiSs=;
        b=fV8KpsOr/X4c7DL9+OY9bpz8Lka3KAxNUGjkzbIjgj4kUABTe/o9PAPcCQFOdqxaF5
         jk/nhmLLCyprA2XFT11XpQhk3aNE8avECaiSvvqijYz1SgEOAbmim5JckqI0xNoSKxjI
         eiHXMFS41BBRKPkbMnoFarI8Gx9KzMemSF8rijIlOsM3kJw+CUmkrc4z+1+GoWz93/eA
         DeID3AtWsPAOekyZQ8V+k/US67p5MHDLecWtWeWEgwFvdqvxKXfTLrYpK33b9ec8PH/u
         PZbCsshHNcRK+3xhPJVRRKcJyl7aV3mKhNCm5ZsIXgqG9idzW/mRG86B+kkcw7NaBcm+
         ODzA==
X-Gm-Message-State: AFqh2krXGvVWEt251vAtCvKfwcFX5RydwTBKfh/jAP7IlRhpqisYRZXG
        b1Y2NypNSzsHeuKylAxGwqH2yp7ollsk6XmP9rYpdXGX9VCXsChe
X-Google-Smtp-Source: AMrXdXuO4pC1bykXBADMFzfu3lOdEv2ojleI5eX9RWkbeoUrFGyX1h5NnofWQSQ4hfkfySbu2s5yp3KSXtc/gNEZBqo=
X-Received: by 2002:a17:906:2288:b0:84d:404f:6143 with SMTP id
 p8-20020a170906228800b0084d404f6143mr18248eja.223.1673901306122; Mon, 16 Jan
 2023 12:35:06 -0800 (PST)
MIME-Version: 1.0
From:   Christian Worm Mortensen <opensource@epust.dk>
Date:   Mon, 16 Jan 2023 21:34:55 +0100
Message-ID: <CAFu8dVqpfuSxxwNnd3zLanoEfPY35aJ1YwoR4dDaqeLqHSC=Cw@mail.gmail.com>
Subject: Proposal: Set nf_conn->tuplehash[IP_CT_DIR_REPLY] to the inverted
 address of packet when it is confirmed
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Currently, when a conntrack entry is initialized, the tuple for the
reply direction (nf_conn->tuplehash[IP_CT_DIR_REPLY]) is set to the
tuple in the original direction inverted (see
https://elixir.bootlin.com/linux/v6.1.6/source/net/netfilter/nf_conntrack_core.c#L1728).

Further, if stateful NAT is subsequently done for the connection, the
tuple is updated accordingly
(https://elixir.bootlin.com/linux/v6.1.6/source/net/netfilter/nf_nat_core.c#L611).

I propose to instead set the tuple when the connection is confirmed.
And at that point, set it to the current address of the packet
inverted. This address seems to be the most likely address that reply
packets will have.

How can the result be different from what we get with the current
method? The packet may have been modified between when the conntrack
entry was initialized and when it was confirmed. For example:

* By using netfilter mangling features, for example as in
https://wiki.nftables.org/wiki-nftables/index.php/Performing_Network_Address_Translation_(NAT)
under stateless NAT.
* By changing the address of the packet as part of routing, see
http://linux-ip.net/html/nat-stateless.html (feature may not be
available anymore).

In my concrete case, I want to make a stateless 1:1 NAT using one of
those features. And I need to do the NAT *after* the packet has been
routed. And I want to use conntrack for stateless firewall and
fastpath with flow tables.

Would such a behavior be an improvement?

Best

Christian
