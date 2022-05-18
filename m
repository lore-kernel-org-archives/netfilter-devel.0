Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C66C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 20:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242748AbiERUmu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 16:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242736AbiERUmt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 16:42:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 825CF7378A
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 13:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652906567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eci3SfR9YUT02jjJEGOCrPhcn1ykfe0qhbLzqAWYbYc=;
        b=H8XTlsIQ68/CD4Ahe+jpAAz9el+0Nyx0w8q6E4W7ziwSnYGH4zLRzTAkAfaUxP7jbMrtGg
        sao3jHZM/mJ9wXQdl+tDKAmE+VFu6Vqrpp50u6cxsIPvYyymOyAIgx2N1C/g32N0toDY65
        8jI+gb5vKAh2ApYA9WiHpoabjEJjX9Y=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-ficUTl0IPFCCXYlhb-LPpQ-1; Wed, 18 May 2022 16:42:46 -0400
X-MC-Unique: ficUTl0IPFCCXYlhb-LPpQ-1
Received: by mail-ej1-f69.google.com with SMTP id gs6-20020a170906f18600b006fe7a9ffacbso1509363ejb.3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 13:42:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Eci3SfR9YUT02jjJEGOCrPhcn1ykfe0qhbLzqAWYbYc=;
        b=KQQqBaGW2XrF84ctjen8aFNnrF9eUNJUlCB+N1/5Tct2AikSdZjSQLdgKjmKjtlZ9u
         b1FP5U1xkZx+CEk7gJCfVho5elw6Q0cBpPxEfqwaaTpcXDsZIeqtrNM1XOMl8lcZrhfr
         ujFbTmWHwFooHJRsNTmgufaA+NudpYHOKQJ/uBONeGNLeZkRmeuRtZE+J0SPgib10q+Z
         uBJyqnvpOb1jRT36g9eHBY1FT/08RqBgSzz1tdOa6//uLnJTg+h6KQ4uas2qp3hJ3JHQ
         8K/BuNzjNK+ElTiX4YBOkcGVtihz7ad3skduJkYe4RNRaQJxUSgA9b68rD9OJeuXoZmX
         ON3g==
X-Gm-Message-State: AOAM532LSD1Osj2jEjzaOzPt46bP5wKHjY8I01pV+SF/oXJGvOvD9Aba
        80HPg0XBBXl959eA6mFJHxIpB7oAklQUmaKiAOc6e3r2rOqZLyFKYBuvYLxTeo2nyTbgm/TqI7E
        kG9RzzxzZKVqhiEb78vMklEATJMCd
X-Received: by 2002:aa7:d4c8:0:b0:42a:a406:a702 with SMTP id t8-20020aa7d4c8000000b0042aa406a702mr1680050edr.129.1652906564009;
        Wed, 18 May 2022 13:42:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaqWlxarRMeh6CgpYv/fRqcKPVWXuO9Nbg7+k5CvmvDj/SuWDwKuUZSM9e5xnDaJyqDSUDhQ==
X-Received: by 2002:aa7:d4c8:0:b0:42a:a406:a702 with SMTP id t8-20020aa7d4c8000000b0042aa406a702mr1680003edr.129.1652906563243;
        Wed, 18 May 2022 13:42:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a2-20020aa7d742000000b0042617ba638esm1840273eds.24.2022.05.18.13.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 13:42:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DA44A38ECC3; Wed, 18 May 2022 22:42:41 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, memxor@gmail.com
Subject: Re: [PATCH v3 bpf-next 3/5] net: netfilter: add kfunc helper to
 update ct timeout
In-Reply-To: <9651ce53e74ce0d0b200fe9d40875e5119ba6c94.1652870182.git.lorenzo@kernel.org>
References: <cover.1652870182.git.lorenzo@kernel.org>
 <9651ce53e74ce0d0b200fe9d40875e5119ba6c94.1652870182.git.lorenzo@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 May 2022 22:42:41 +0200
Message-ID: <871qwqa7y6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Introduce bpf_ct_refresh_timeout kfunc helper in order to update
> nf_conn lifetime. Move timeout update logic in nf_ct_refresh_timeout
> utility routine.
>
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

