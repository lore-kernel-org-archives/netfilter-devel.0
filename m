Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEDCC5479D
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Jan 2023 18:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbjAKSUj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Jan 2023 13:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235046AbjAKSUR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2023 13:20:17 -0500
Received: from galois.cryonox.net (galois.cryonox.net [173.255.233.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829681EEC2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 10:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cryonox.net
        ; s=x; h=Subject:In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Dw7bskEcj45hJ9WtJsOZM8jdWZUl5nz7wXtzwslnjxs=; b=fapZmNz7D/bngCKYZXpzFV2VCQ
        yJfeLsml5sy3cl9/fOT2NQCAKitfEG+EgGOhN+39bD+ZogFQ/CF3uxSi8ZIlvlm4bPwXgcUQydoot
        EPLtDwdu2nct50BrnWlKsqQr+5DGRQNKlz4CXp+LDuDz76a8FNcwiZn/17rgs7fE0q7T6qb1lbxGP
        9ci9TeJTfXBpVTkOcRF1q4sBm3GDpXcaPYDjHpYVs9cNBnxQdqJi3rcq6yeIzafP43q2K4DnZmyup
        TbHgxmIkMq9ANzEhdjLpdQjEiYwI8laH2kthwDSKx/LIZP1GNLGNJpbiF9xWSzNCngVldDINDtG/a
        39Ti+01A==;
Received: from authenticated_user by galois.cryonox.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        id 1pFfhs-006J7I-V8; Wed, 11 Jan 2023 13:20:15 -0500
Date:   Wed, 11 Jan 2023 13:20:12 -0500
From:   Bill Blough <devel@blough.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Message-ID: <Y7793EL+N+au0oZM@cndt942648>
References: <Y7h1o0H+dvAz1vtZ@prometheus>
 <Y77xebdD+v9ZjEyb@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y77xebdD+v9ZjEyb@salvia>
X-SA-Exim-Connect-IP: 209.170.225.186
X-SA-Exim-Mail-From: devel@blough.us
Subject: Re: [PATCH libnetfilter_conntrack 1/1] conntrack: Allow setting of
 netlink buffer size
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on galois.cryonox.net)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 11, 2023 at 06:27:21PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Jan 06, 2023 at 02:25:23PM -0500, William Blough wrote:
> > Add nfct_rcvbufsiz function to allow setting of buffer size for netlink
> > socket.
> 
> Thanks for your patch.
> 
> There is already nfct_fd() and you can use setsockopt() on it.

Ah, apparently I overlooked that.  Thanks.

Best regards,
Bill

