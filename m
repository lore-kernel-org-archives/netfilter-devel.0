Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4D8C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 16:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbjKBQSy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 12:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbjKBQSx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 12:18:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00351F0
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 09:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698941881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=tCi7DxGXCIepaMXwyZcuV5fD5os6oJgHkgX3dNXKARo=;
        b=YTy+sicdMIkIG3FVVfEk7rp37tkapNftmunMaCYceyfH/+FaBxruvDHUhVFqbNU6HWHLPv
        7HPFXuVXcbsZjoxmdGf/8NDy1w9ADKKxHG56YB4t9B6LTQamhrvrUEGRTQJVUkDHXMUoOC
        YvP3u0Jn4zWqrJyMkd0iIj1rjCA0ZHA=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-kF4Bdj7vNhaMgOebtWZVCw-1; Thu, 02 Nov 2023 12:17:59 -0400
X-MC-Unique: kF4Bdj7vNhaMgOebtWZVCw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2b6fdb8d0acso1820151fa.0
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Nov 2023 09:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698941877; x=1699546677;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tCi7DxGXCIepaMXwyZcuV5fD5os6oJgHkgX3dNXKARo=;
        b=aHpSC4SOoB2NBYppHajOH9DPuShlNoLq5D5iabL52lfxBbA8kqOVbLn96T1HW9+uDM
         1Gc8OVTxm8Xhy+XndtFA9QcNSxNmjZZpM4eoSvCd52If2pIpOy/rXeoB68i6mnD0FBYD
         GYWtEOdzTRqgCr/4DF+hf9iwYo4ioIkg4nCwPJNC8GRNCn+MeF/HelPDAgcSTWhgFXg5
         pkk5iZs+MqZ3MEzEkZzH3FkVrzYKInksC+hVqU5dtPAZgREZc5e+TYHAEJoFsk8mzEO1
         EUM1mL9qF6GTzmZi0ESg8kDOjKMsYyytkIoFEuv+lj00poc27r5nuTqnoZyjUn6FJg7r
         dJrA==
X-Gm-Message-State: AOJu0Yxb2zaX1XtbLotNzjejk/rsDBWHHWRl7QS1DA47A5EjOyco1BxM
        MclsAq5hf+dVvUIZloWIladRZvvax2ahvGBCDaDwzWOm43aPGpFXnTaLJ3s39wTgs3q7xNipDjP
        dpqMq4EbEuIZxJ+8rMIQSfFE8K3xeMZ2+c6OE
X-Received: by 2002:a2e:86c9:0:b0:2c5:36e:31bf with SMTP id n9-20020a2e86c9000000b002c5036e31bfmr14047085ljj.5.1698941877511;
        Thu, 02 Nov 2023 09:17:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEnKZRtCyN+WXDdhI6JgeGJAVNpsRcRV9QXsPyi5Z+Qof1kOI3Zoe4zBc29vS/E0GZFFXqVA==
X-Received: by 2002:a2e:86c9:0:b0:2c5:36e:31bf with SMTP id n9-20020a2e86c9000000b002c5036e31bfmr14047075ljj.5.1698941877159;
        Thu, 02 Nov 2023 09:17:57 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id l14-20020a05600c1d0e00b00405959469afsm3481656wms.3.2023.11.02.09.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 09:17:56 -0700 (PDT)
Message-ID: <6856ecfb5630d546f0d99a8fcb6008a20aea1324.camel@redhat.com>
Subject: Re: [PATCH nft 2/2] json: drop handling missing json() hook for
 "struct expr_ops"
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Thu, 02 Nov 2023 17:17:56 +0100
In-Reply-To: <ZUPGRh7JZFGXfGgE@calendula>
References: <20231102112122.383527-1-thaller@redhat.com>
         <20231102112122.383527-2-thaller@redhat.com> <ZUOHkxVCA1FyJvNd@calendula>
         <1cef5666d280706a3ffa5c24b30962496ca8a833.camel@redhat.com>
         <ZUPGRh7JZFGXfGgE@calendula>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 (3.50.0-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-11-02 at 16:54 +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 02, 2023 at 03:09:42PM +0100, Thomas Haller wrote:
> >=20
> > I think BUG() would not work. This does happen, as the tests in
> > patches
> >=20
> > Subject:	[PATCH nft 0/7] add and check dump files for JSON
> > in tests/shell
> > Date:	Tue, 31 Oct 2023 19:53:26 +0100
> >=20
> > expose.
>=20
> No listing from the kernel would use the variable expression.
>=20
> What example would be triggering bug?


when you apply above patchset (and revert patch 2/7), and:


    $ make
    $ ./tests/shell/run-tests.sh
    ...
    $ grep '^[^ ]*W[^ ]*:' /tmp/nft-test.latest.*/test.log
    W: [CHK DUMP]     8/381 tests/shell/testcases/chains/0041chain_binding_=
0 =20
    W: [CHK DUMP]    66/381 tests/shell/testcases/cache/0010_implicit_chain=
_0
    W: [CHK DUMP]   226/381 tests/shell/testcases/nft-f/sample-ruleset
    $ grep -R 'Command `./tests/shell/../../src/nft -j list ruleset""` fail=
ed' /tmp/nft-test.latest.*/
    ...

Gives:

tests/shell/testcases/nft-f/sample-ruleset
tests/shell/testcases/cache/0010_implicit_chain_0
tests/shell/testcases/chains/0041chain_binding_0

For example:

/tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-0041chain_bindi=
ng_0.4/rc-failed-chkdump:Command `./tests/shell/../../src/nft -j list rules=
et""` failed
/tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-0041chain_bindi=
ng_0.4/rc-failed-chkdump:>>>>
/tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-0041chain_bindi=
ng_0.4/rc-failed-chkdump:warning: stmt ops chain have no json callback
/tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-0041chain_bindi=
ng_0.4/rc-failed-chkdump:warning: stmt ops chain have no json callback
/tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-0041chain_bindi=
ng_0.4/rc-failed-chkdump:<<<<




There are also other failures. e.g.
tests/shell/testcases/parsing/large_rule_pipe does not give stable
output. I need to drop that .json-nft file in v2.


Using Fedora kernel 6.5.6-300.fc39.x86_64.


Thomas

