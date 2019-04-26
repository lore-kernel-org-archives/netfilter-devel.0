Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8056C43218
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 18:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90108206A3
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 18:55:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="nqlmq2fn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfDZSzS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 14:55:18 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38846 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfDZSzS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 14:55:18 -0400
Received: by mail-qt1-f195.google.com with SMTP id d13so5280253qth.5
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 11:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/OEFYiq4OwxLPHInL4MTq6f/BywQtaQD6HGhh8lLTLI=;
        b=nqlmq2fnWkCnp3mwDuSaZqLpRKF9ZUGA1Z+fH/VHSKLxuRgtVSziTAk37rfMRuhJL2
         bz+5o+htVOiLIYig3rVB2zzP1HmkAfYm2lQWcpZ656qZ7rlpuKxUiMzqi1J/TaoDTiwS
         CoN/acs8FbqT8ZMYN36gNx8ySyYvV1QGjFbSIUzs8YB90kdUpt4HJXP5Z9yNsknSdzpV
         EApJ2dR3RMx9kQoSwFhJjhhEQGbyI8JzRJuxV7HLVbZFt2rW58Mx+ZZbIpGP2/ibqX+u
         5KzX73t0eGkRDSxh/on4oCqowTscTpVUiL2JOh+og9b6vOzc/vC9ruMqsKkYNGWar623
         cjkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/OEFYiq4OwxLPHInL4MTq6f/BywQtaQD6HGhh8lLTLI=;
        b=WUFNso32xJP7B08UtxmQ7GYFFzfsI/oUOyx2YWUIN854hbQwN4Ko2Si06+bkYYd7x6
         blxEziq8IFgHTZgl9kVlP9SLNhh9RwMoLVghMreHAwy/SzqOtmgNSlBNc2BfbhGPEvNu
         uFQLEkwCPT5BXY3MYzzhCsXUxoVCSTU05liYi8jCo3LGwT4nns0o/Z+G7FdxU5w5GGue
         iDfE0qaUdNaGwsuXaZkymdnUxWXSsNfZh2eXnmHO1E7kIfBbng59iHLzImwGhERJdSga
         5dXE495z3bmWRwq39r7PetxWSeX/3KOz2cit9gzeJGHS+/PpRhSjwuPOe/m8V9pS3ZJT
         6Zzg==
X-Gm-Message-State: APjAAAU60SY6CE7Vq8msytaXAK7KY1jJ9gPJzZCi8tb9d9fvPaqHnAQr
        pOxmaHSenpRMAfi2QLJag8Fliw==
X-Google-Smtp-Source: APXvYqz9ozBAwA1CdbFNVF1l2FHOs6ekWOiHDNVywf7eix4zsuylBrEYUToNzgTYKJ/7Ip/89bD2Lw==
X-Received: by 2002:a0c:92f9:: with SMTP id c54mr7252851qvc.194.1556304917395;
        Fri, 26 Apr 2019 11:55:17 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b24sm12223897qtr.51.2019.04.26.11.55.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Apr 2019 11:55:17 -0700 (PDT)
Date:   Fri, 26 Apr 2019 11:55:12 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, ogerlitz@mellanox.com
Subject: Re: [PATCH net-next,RFC 0/9] net: sched: prepare to reuse per-block
 callbacks from netfilter
Message-ID: <20190426115512.18263215@cakuba.netronome.com>
In-Reply-To: <20190426184145.oioesc7eqy5p7sps@salvia>
References: <20190426003348.30745-1-pablo@netfilter.org>
        <20190426143258.GC2249@nanopsycho.orion>
        <20190426162836.6hy7q42b6itckzff@salvia>
        <20190426112956.7bbd2b87@cakuba.netronome.com>
        <20190426184145.oioesc7eqy5p7sps@salvia>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 26 Apr 2019 20:41:45 +0200, Pablo Neira Ayuso wrote:
> > > > >Hence, this emulates the shared blocks available in TC that Jiri made.
> > > > >
> > > > >Note that the list of tcf_block_cb objects will be called to offload
> > > > >policies in this chain.    
> > > > 
> > > > So you are going to use chain_id (if there is anything like that) as
> > > > block_index during offload, right?    
> > > 
> > > Yes. But I don't need to expose this chain_index to userspace though,
> > > I can internally allocate it, I only need to make sure it does not
> > > overlap with any of the existing tc block_indexed. I can just use a
> > > different index space which does not overlap with the tc block index
> > > space.  
> > 
> > How will the association between a block and a device work for
> > netfilter?  
> 
> My proposal is that Netfilter doesn't need to expose anything similar
> to the TC block concept. I mean, not to the user, not through the
> command line and netlink itself.

Yes, yes.

> If netfilter supports for chain definitions like this:
> 
>         table x {
>                 chain y {
>                         type filter hook ingress devices = { eth0, eth1 } priority 0;
>                 }
>         }
> 
> Then the chain 'y' implicitly becomes the block for the 'eth0' and
> 'eth1' devices.

Can there be more chains for those devices?  Or those will only run y
from netfilter perspective?

> Note that the above is not yet supported, I need to extend the netlink
> API for this, but having chains that are attached to multiple devices
> is feasible and it makes sense for plain software configurations where
> no offload is involved (as useful as the TC block for pure software to
> avoid policy duplication).
