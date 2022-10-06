Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CFFC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 09:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiJFJEz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 05:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiJFJEv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 05:04:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC2C1A04E
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Oct 2022 02:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665047087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5Gx1Q0h8P5Bsn+a58m/eMlUAUw9CkDNBQ7hqnzDwSJo=;
        b=IC6W9+rBOeXfMk8aqLnbBU4FlkohOZzd4qvgw0BGULlDdVS2psCY4WpcyI2H0qJcWZu1Wy
        FkbO4B7HR+QJlrC03kbjhPlASOciUUvBGq9fhmu7qSQfcq6ct2k2i9mIkTm5kbcMbZFvPH
        n60+WDA5Ll3ZdYTBit15e2ca3mI/Ehc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-374-VOC5Jr0aMLG9YzcXLl7ptQ-1; Thu, 06 Oct 2022 05:04:46 -0400
X-MC-Unique: VOC5Jr0aMLG9YzcXLl7ptQ-1
Received: by mail-wm1-f71.google.com with SMTP id i82-20020a1c3b55000000b003bf635eac31so724340wma.4
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Oct 2022 02:04:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=5Gx1Q0h8P5Bsn+a58m/eMlUAUw9CkDNBQ7hqnzDwSJo=;
        b=R+8qVqqKgibCUmHQMilvRBSKf3sYBj5kkueNCDRXIziVELzCnwioRnb92uMrda1hRb
         TZdCq0P9J9M9n25K0OVGh9g/8uuoWaL4KiCM2vYH4A4Wau0RXCiQS9cQV7a2Ff/XttdU
         FFn8m2q/mjflIPqKsehycM/e3b4DjyaDBIqT51+KQZTLlPmP7Gqp7CGqO2pfDm6bHVMk
         BbT9n/rKwc7vnjPvZfCUDUdcg6FG11GgO7BE6t0O9ftJB0MKEs+iAE67ni/Xp2HnEo/z
         vq9Qeo6mKsAq4Kgou698iH4h15dNFzz2ho9TrACLu9utU+rvyc0Xd0KwLrIfI2vZzNZ2
         lUgw==
X-Gm-Message-State: ACrzQf0rUiHChy9n6/BmYGafREtlEftL4QAYmA8iDqdshu2WVvFs0SIq
        fPNDLi+M9tyxhdjhRlGqi9asWJOk8CrYx0nWaeNY19B8t7GmTk4Z5v4yJxGivifz/Tlz47mb1l4
        J2WXvB8rUiVoXAGBnE5SLVVh7DUQN
X-Received: by 2002:adf:f804:0:b0:22e:5a9a:15d9 with SMTP id s4-20020adff804000000b0022e5a9a15d9mr2395659wrp.390.1665047084856;
        Thu, 06 Oct 2022 02:04:44 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6xAunzYC+VnMCb9I4tNT9EQFleutYisnI+agn8b1dCINLSFMVaBSDFFPAOUDL7QpzPz13Y8w==
X-Received: by 2002:adf:f804:0:b0:22e:5a9a:15d9 with SMTP id s4-20020adff804000000b0022e5a9a15d9mr2395652wrp.390.1665047084659;
        Thu, 06 Oct 2022 02:04:44 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id l20-20020a1c7914000000b003b47ff307e1sm867544wme.31.2022.10.06.02.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 02:04:44 -0700 (PDT)
Date:   Thu, 6 Oct 2022 11:04:41 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [nf-next PATCH 2/2] netfilter: rpfilter/fib: Populate
 flowic_l3mdev field
Message-ID: <20221006090441.GA3328@localhost.localdomain>
References: <20221005160705.8725-1-phil@nwl.cc>
 <20221005160705.8725-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005160705.8725-2-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 05, 2022 at 06:07:05PM +0200, Phil Sutter wrote:
> Use the introduced field for correct operation with VRF devices instead
> of conditionally overwriting flowic_oif. This is a partial revert of
> commit b575b24b8eee3 ("netfilter: Fix rpfilter dropping vrf packets by
> mistake"), implementing a simpler solution.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

