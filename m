Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B8BC4708D
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 20:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiLGUHC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 15:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLGUHB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 15:07:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9320F6E540
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 12:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670443563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kRxOq5rMzHgau0UX4AWMzxQIpBJ6mdiuqwtaJBEk8tk=;
        b=A6/nMZtqKuMznssf50gRhnui1ncha27W9+f6DZ/gknBbu4l1ULb7Q2zFhEfh/n011Sj3F6
        wdAvUX7TUx7uBEVRcX5jxKrsPwBbkzll/OQ4CcmkPE5WmTIOMyNv69rZSHBPH9mULPfM/K
        FzJcbkbWZ+KJTgShwAkFqCJUdniqh1A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-MJUjHyPOP1i7-ncau8PsMQ-1; Wed, 07 Dec 2022 15:06:02 -0500
X-MC-Unique: MJUjHyPOP1i7-ncau8PsMQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2791858F13;
        Wed,  7 Dec 2022 20:06:01 +0000 (UTC)
Received: from localhost (wsfd-netdev-vmhost.ntdv.lab.eng.bos.redhat.com [10.19.188.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B426C40C2064;
        Wed,  7 Dec 2022 20:06:01 +0000 (UTC)
Date:   Wed, 7 Dec 2022 15:06:01 -0500
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, sbrivio@redhat.com
Subject: Re: [PATCH nft] src: support for selectors with different byteorder
 with interval concatenations
Message-ID: <Y5DyKcPZ+vzphv11@wsfd-netdev-vmhost.ntdv.lab.eng.bos.redhat.com>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, sbrivio@redhat.com
References: <20221124114602.277741-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124114602.277741-1-pablo@netfilter.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 24, 2022 at 12:46:02PM +0100, Pablo Neira Ayuso wrote:
> Assuming the following interval set with concatenations:
> 
>  set test {
> 	typeof ip saddr . meta mark
> 	flags interval
>  }
> 
> then, the following rule:
> 
>  ip saddr . meta mark @test
> 
> requires bytecode that swaps the byteorder for the meta mark selector in
> case the set contains intervals and concatenations.
> 
>  inet x y
>    [ meta load nfproto => reg 1 ]
>    [ cmp eq reg 1 0x00000002 ]
>    [ payload load 4b @ network header + 12 => reg 1 ]
>    [ meta load mark => reg 9 ]
>    [ byteorder reg 9 = hton(reg 9, 4, 4) ] 	<----- this is required !
>    [ lookup reg 1 set test dreg 0 ]
> 
> This patch updates byteorder_conversion() to add the unary expression
> that introduces the byteorder expression.
> 
> Moreover, store the meta mark range component of the element tuple in
> the set in big endian as it is required for the range comparisons. Undo
> the byteorder swap in the netlink delinearize path to listing the meta
> mark values accordingly.
> 
> Update tests/py to validate that byteorder expression is emitted in the
> bytecode. Update tests/shell to validate insertion and listing of a
> named map declaration.
> 
> A similar commit 806ab081dc9a ("netlink: swap byteorder for
> host-endian concat data") already exists in the tree to handle this for
> strings with prefix (e.g. eth*).
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---

Hi Pablo,

This patch reversed the byte order on output.

Thanks.
Eric.


--->8---


# cat /tmp/foo
table inet foobar {
        set foobar {
                type ipv4_addr . mark
                flags interval
                elements = { 10.10.10.10 . 0x00000100,
                             20.20.20.20 . 0x00000200 }
        }
}

# ./src/nft -f /tmp/foo

# ./src/nft list table inet foobar
table inet foobar {
        set foobar {
                type ipv4_addr . mark
                flags interval
                elements = { 10.10.10.10 . 0x00010000,
                             20.20.20.20 . 0x00020000 }
        }
}

# nft list table inet foobar
table inet foobar {
        set foobar {
                type ipv4_addr . mark
                flags interval
                elements = { 10.10.10.10 . 0x00000100,
                             20.20.20.20 . 0x00000200 }
        }
}

