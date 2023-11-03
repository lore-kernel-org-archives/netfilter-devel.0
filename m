Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F590C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 08:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbjKCIqf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 04:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjKCIqd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 04:46:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112CD1BC
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 01:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699001144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=voZHQXQ4KZLi6sn1ZNrcZFnvGGp8JIICDWfQ1VvSpLA=;
        b=CadHPklya+q0+x2PqSknQC2fcQgnw4Ep4y1lS6qTkzAtjV3OzyqkeIu2cyTQsOaG46X5J8
        MZ8GOeTvCUyuPF2NMwwLKGErsJf2e4JGVgDlqYL/43hgf2kRYs2ps010d44JiQVq4K85CT
        cC/JOUEav5zhiT5eXJlf0FXAiire0dI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-9TpQm_rPPFWK-86U04XUIw-1; Fri, 03 Nov 2023 04:45:42 -0400
X-MC-Unique: 9TpQm_rPPFWK-86U04XUIw-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-50798dd775dso394409e87.1
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Nov 2023 01:45:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699001141; x=1699605941;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=voZHQXQ4KZLi6sn1ZNrcZFnvGGp8JIICDWfQ1VvSpLA=;
        b=a5CHEtg/voFFB3QqyTOXQzR2ySlvNtY79JqMvZ+sF2S7TUDzNmI+cPiVoqz+5ieN2g
         fJZ6xEJXOZGpnsjFwXqUBrALUXgqWWmlmQ9oHD/fTnejHEez/AmJyeRv79xDNdqi6NFc
         5DDr0IW53eVEH+GzYaZ4aYuJ2/7CIhDgeCjITNZnWe9qK2BS9mgil4h5nXyVu9n3vMA0
         1R9XFlN2T5iVLu3j/3dGZtzCS779Lv/7oISBUiBhw4zxEnFJl3huTSihSthmBrd9SYZP
         qkItsoFMjqKk+aHbQLfI+w0OiHcDUfeFwStPAJMlgWzXA29mjda8jNe8/UVFmTLH71RB
         YYvw==
X-Gm-Message-State: AOJu0YyW92Lbp5G9kiMOa9RLTaCTWGoDM24yYM9/Q/b9NHkjas1nfmkp
        +UxLZiioDjT8dIytfIIU0M6MOm++jNXdnqtFcQgYBg5Cm2husfQP05WPpz/4bnuKmnCYxU3WfyE
        6koiQQeQ8XKykOVroyBE2mnMxcYdZsL2Y2SHt
X-Received: by 2002:a05:6512:2826:b0:507:96e4:457c with SMTP id cf38-20020a056512282600b0050796e4457cmr17273509lfb.6.1699001140214;
        Fri, 03 Nov 2023 01:45:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnTmbCSOT2IqMIsB9bdfkYv1vUevW9vDMbnzHt1LGzkOhNzJlaNXY6sUmWPJ4CH9Stx4mxKQ==
X-Received: by 2002:a05:6512:2826:b0:507:96e4:457c with SMTP id cf38-20020a056512282600b0050796e4457cmr17273497lfb.6.1699001139735;
        Fri, 03 Nov 2023 01:45:39 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id d13-20020a1709067f0d00b009932337747esm643972ejr.86.2023.11.03.01.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Nov 2023 01:45:39 -0700 (PDT)
Message-ID: <b0a495847e1c88b9cca27f3fc80f68b46c8391d5.camel@redhat.com>
Subject: Re: [PATCH nft 2/2] json: drop handling missing json() hook for
 "struct expr_ops"
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 03 Nov 2023 09:45:38 +0100
In-Reply-To: <ZUQL1690tW+XAnS4@calendula>
References: <20231102112122.383527-1-thaller@redhat.com>
         <20231102112122.383527-2-thaller@redhat.com> <ZUOHkxVCA1FyJvNd@calendula>
         <1cef5666d280706a3ffa5c24b30962496ca8a833.camel@redhat.com>
         <ZUPGRh7JZFGXfGgE@calendula>
         <6856ecfb5630d546f0d99a8fcb6008a20aea1324.camel@redhat.com>
         <ZUQL1690tW+XAnS4@calendula>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 (3.50.0-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-11-02 at 21:51 +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 02, 2023 at 05:17:56PM +0100, Thomas Haller wrote:
>=20
>=20
> Yes, chain statement is lacking a json output, that is correct, that
> needs to be done.


What is the correct JSON syntax for printing a chain?

For example, for test "tests/shell/testcases/nft-f/sample-ruleset" I
get the following from `nft -j list ruleset`:

    [...]
    {
      "rule": {
        "family": "inet",
        "table": "filter",
        "chain": "home_input",
        "handle": 91,
        "expr": [
          {
            "match": {
              "op": "=3D=3D",
              "left": {
                "meta": {
                  "key": "l4proto"
                }
              },
              "right": {
                "set": [
                  "tcp",
                  "udp"
                ]
              }
            }
          },
          {
            "match": {
              "op": "=3D=3D",
              "left": {
                "payload": {
                  "protocol": "th",
                  "field": "dport"
                }
              },
              "right": 53
            }
          },
          "jump {\n\t\t\tip6 saddr !=3D { fd00::/8, fe80::/64 } counter pac=
kets 0 bytes 0 reject with icmpv6 port-unreachable\n\t\t\taccept\n\t\t}"
        ]
      }
    },
    [...]


In `man libnftables-json`, searching for "jump" only gives:

    { "jump": { "target": * STRING *}}


Is there an example how this JSON output should look like?

(or a test, after all, I want to feed this output back into `nft -j --check=
 -f -`).



> But, as for variable and symbol expressions, I do not see how those
> can be found in the 'list ruleset' path. Note that symbol expressions
> represent a preliminary state of the expression, these type of
> expressions go away after evaluation. Same thing applies to variable
> expression. They have no use for listing path.

ACK about symbol_expr_ops + variable_expr_ops. I will send a minor
patch about that (essentially with code comments and remove the
elaborate fallback code).


>=20
> Do you have tests that explicitly refer to the lack of json callback
> for variable and symbol expressions just like in the warning above?
>=20
> > /tmp/nft-test.latest.thom/test-tests-shell-testcases-chains-
> > 0041chain_binding_0.4/rc-failed-chkdump:<<<<
> >=20
> > There are also other failures. e.g.
> > tests/shell/testcases/parsing/large_rule_pipe does not give stable
> > output. I need to drop that .json-nft file in v2.
>=20
> What does 'unstable' mean in this case?
>=20

It seems, that the order of the elements of the list is unstable. I
didn't investigate. At this point, I only want to add the .json-nft
files for tests that pass, and worry about the remaining issues after
the basic test infrastructure about .json-nft tests is up.



Thomas

