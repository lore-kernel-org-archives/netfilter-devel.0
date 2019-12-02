Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC2BC432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 16:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 153BB2053B
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 16:20:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e1vc6tXF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfLBQUQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 11:20:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25892 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727484AbfLBQUQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 11:20:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575303615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qeiez02V3+O53H0ooe1Pv3mLL+OcOSpq68v2i6a/knI=;
        b=e1vc6tXFW1tDsSIvjJ3OGEanC7/RMh1A6pv8ccJPg+lZkp+Z1YycZwBeYWSNQqm/wueLiQ
        cGglB2QkdtykaPxx/cfBx4iYv4SI2QeFFBQoH/nFgl/FadE4jfCG3Z1RdRGiRFsm8LC5aX
        GwoRwwLl6IzxDKbMQpNW5Fz8TExO/J0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-k1Xd5rM8MH2A_ismO7q1Fw-1; Mon, 02 Dec 2019 11:20:12 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 879A9107ACE5;
        Mon,  2 Dec 2019 16:20:11 +0000 (UTC)
Received: from elisabeth (ovpn-200-27.brq.redhat.com [10.40.200.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D30EB19C68;
        Mon,  2 Dec 2019 16:20:09 +0000 (UTC)
Date:   Mon, 2 Dec 2019 17:19:52 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH,nf-next RFC 0/2] add NFTA_SET_ELEM_KEY_END
Message-ID: <20191202171952.2e577345@elisabeth>
In-Reply-To: <20191202131407.500999-1-pablo@netfilter.org>
References: <20191202131407.500999-1-pablo@netfilter.org>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: k1Xd5rM8MH2A_ismO7q1Fw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon,  2 Dec 2019 14:14:05 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi Stefano,
> 
> This patchset extends the netlink API to allow to express an interval
> with one single element.
> 
> This simplifies this interface since userspace does not need to send two
> independent elements anymore, one of the including the
> NFT_SET_ELEM_INTERVAL_END flag.
> 
> The idea is to use the _DESC to specify that userspace speaks the kernel
> that new API representation. In your case, the new description attribute
> that tells that this set contains interval + concatenation implicitly
> tells the kernel that userspace supports for this new API.

Thanks! I just had a quick look, I think the new set implementation
would indeed look more elegant this way. As to design choices, I'm
afraid I'm not familiar enough with the big picture to comment on the
general idea, but my uninformed opinion agrees with this approach. :)

For what it's worth, I'd review this in deeper detail next.

> If you're fine with this, I can scratch a bit of time to finish the
> libnftnl part. The nft code will need a small update too. You will not
> need to use the nft_set_pipapo object as scratchpad area anymore.

On my side, I'm almost done with nft/libnftnl/kernel changes for the
NFT_SET_DESC_CONCAT thing. How should we proceed? Do you want me to
share those patches so that you can add this bit on top, or should this
come first, or in a separate series?

I could also just share the new nft/libnftnl patches (I should have them
ready between today and tomorrow), and proceed adapting the kernel part
according to your changes.

Related question: to avoid copying data around, I'm now dynamically
allocating a struct nft_data_desc in nf_tables_newset() with a
reference from struct nft_set: desc->dlen, desc->klen, desc->size would
all live there, together with the "subkey" stuff.

Is it a bad idea? I can undo it easily, I just don't know if there's a
specific reason why those fields are repeated in struct nft_set.

-- 
Stefano

