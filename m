Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4687DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Jul 2022 17:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbiGTREI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Jul 2022 13:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbiGTREA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Jul 2022 13:04:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49C6B6BC1F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2022 10:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658336637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xuZtPMEGTJUPyCThBRbp89TRLDnOnODjmUD0CEahbP8=;
        b=Q6XktXoXa4nUgQUi4jupDYltJQ/YfWai51mn5joW/4d8iSHpBUHqs2p9w5JzaPC1VdUbH5
        On8OgO5y3rzR/eK23Vuav5sX58NtPY4ATRR7r8Uf3hag68aXm4Wx/BzuxgxUy6b/3ty9MP
        K9R/SCyW6BBOdm423xCeauHoHRk5ABE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-lJgzB9n4N3ayHQwmimjxzQ-1; Wed, 20 Jul 2022 13:03:55 -0400
X-MC-Unique: lJgzB9n4N3ayHQwmimjxzQ-1
Received: by mail-ed1-f70.google.com with SMTP id l16-20020a056402255000b0043bbb1e39c3so1022935edb.11
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2022 10:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xuZtPMEGTJUPyCThBRbp89TRLDnOnODjmUD0CEahbP8=;
        b=Jbuh5G0GL70x86savUT/78nZFuJi5n1IrQPdkkXH3rwYimSgaB0fQYoMfHB5/Q92fS
         zpmg+Kup+qMbYgHLcxnZeVzBOdVxyb8Pu/E04nrqtC4VECZ9WApKgAz6zsarbHlNyrnU
         WPW6o7N9tWEJsjntOYDCLw1E9LwVXbRMd2+BsbnZvBJNpeKvb4eA1Y7Ng3UcOcqTFxw2
         6vHzkmBDPfmkF15A49WgOcUwQuTVFKFb9Z+faZ++0K2n7k4xPh9qElw5EBjAiJOW2JPP
         M8MOV0fg1zczZBdANUAevKsV1bLEAirrjZH1aq0Tb7wdF0t+IFD6bPGxs0+/bHxbwI4j
         vFnA==
X-Gm-Message-State: AJIora/ykTjQ3nmFy6SUVkl65gJ+Ah8+uZFtCbLJik6+5FUXdyjWKjpu
        Bjvk1XmWc9JkbBUvQZNZ0HPPU4vOAp600EPbi6P4zHG/zJXMVjJgSlDDnDRyZ5vp4bEHU+ALQNo
        u+lzZH9CUtdLYcwFLvpDM3TAAUpt2
X-Received: by 2002:a17:907:7d8b:b0:72f:2306:329a with SMTP id oz11-20020a1709077d8b00b0072f2306329amr16924729ejc.369.1658336634576;
        Wed, 20 Jul 2022 10:03:54 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v8HK3Vlfjf43MlHI1Fad5ztpTBq9UeLWcrb3eFi6pmR6+PN79I0J3ji7iEf9BXw4FEHd/yNQ==
X-Received: by 2002:a17:907:7d8b:b0:72f:2306:329a with SMTP id oz11-20020a1709077d8b00b0072f2306329amr16924697ejc.369.1658336634208;
        Wed, 20 Jul 2022 10:03:54 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w6-20020a50fa86000000b0043ba0cf5dbasm2875285edr.2.2022.07.20.10.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 10:03:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 38BC34DA0BE; Wed, 20 Jul 2022 19:03:52 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org
Cc:     KP Singh <kpsingh@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH bpf-next v6 05/13] bpf: Add documentation for kfuncs
In-Reply-To: <20220719132430.19993-6-memxor@gmail.com>
References: <20220719132430.19993-1-memxor@gmail.com>
 <20220719132430.19993-6-memxor@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Jul 2022 19:03:52 +0200
Message-ID: <878ronu35z.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> As the usage of kfuncs grows, we are starting to form consensus on the
> kinds of attributes and annotations that kfuncs can have. To better help
> developers make sense of the various options available at their disposal
> to present an unstable API to the BPF users, document the various kfunc
> flags and annotations, their expected usage, and explain the process of
> defining and registering a kfunc set.

[...]

> +2.4.2 KF_RET_NULL flag
> +----------------------
> +
> +The KF_RET_NULL flag is used to indicate that the pointer returned by the kfunc
> +may be NULL. Hence, it forces the user to do a NULL check on the pointer
> +returned from the kfunc before making use of it (dereferencing or passing to
> +another helper). This flag is often used in pairing with KF_ACQUIRE flag, but
> +both are mutually exclusive.

That last sentence is contradicting itself. "Mutually exclusive" means
"can't be used together". I think you mean "orthogonal" or something to
that effect?

-Toke

