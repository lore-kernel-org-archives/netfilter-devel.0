Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45832C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 12:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbiDHM26 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 08:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbiDHM2z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 08:28:55 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F1A33DC9B
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 05:26:51 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a30so11187204ljq.13
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Apr 2022 05:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=6rroY8hPZE4p2zmZA2L94iWoJjc7j8KWP3Zc5N+r+Fg=;
        b=o6fGyMzYHs5sUk8Um3pVqKekdItBRghu351xxUuA5OaY1HYRRN/YILD2W/T1CkFuSc
         dsun5fzzsIVViV+vSvUCIX77Se8noORn8dNSMBXWoMvnhLwEuqPZPY5cdx08NDC3XJ6q
         iGhgqjzR3fk0ljwjuP2oTV5RLHA3UHuYktFHufpl3QJmMePfvc505RR864xoXHmziXlW
         0D7jdU78hcWoPiMMVSjzOV7CZfdY9xzZaGWURAk0jVqY9RALZpy7fhG5alCZlXjXoTRf
         0AoZ2hm3gn9SNRAeX2gJ9X9/66rMVfUUaXENM0pgXJhUaHrMijFntHRfyALFDFsHCUj2
         SvgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=6rroY8hPZE4p2zmZA2L94iWoJjc7j8KWP3Zc5N+r+Fg=;
        b=qbLaua6Ca5mxGTwiOl7Tnhi039UUQmzAKcg4v1JF46GAA0UpS5kcoSTXnhcn6cFROk
         bul8OhKMLRniSz79cDwa/ccveGXIt4CJgyHxZhBkegwEllV6QAjQPU7qoSuthDRlKiIr
         pp9pgjPttwuQGwlWKMYe4KlVPfF9yuodmhU9Op+zRTj61YJEmsreQLxKW80hBLYloM1f
         4YIgUN6+Pc7TR7Jo/aje9a6omDujZqFkoMeCqZ4jcZEXNUw5sTKF/FOCrcx+WiXe/G3V
         +Lkk+XRZPeXnsxT7UzFTNm+bkUc7Arl236kCdn6NLczipm8coGkAHyqQ7KB9y/MjRlFS
         +qAw==
X-Gm-Message-State: AOAM530bi2CKFSavhqxPF5bQbXBXe2MXHuRoPN0hYuJNKN4Z8ycLqXLb
        UU6JALbWvx22vt4LYAKQyHcqHg4W2giTxFVi6Ot7qdL69rI=
X-Google-Smtp-Source: ABdhPJwo1x6xXfiy5NXuBEXIFruS+NP38c0GLbIz/F71vq/IU4iiImmjsEo4/dYsgr/h6M+Pq0FhXyQn5ZVW1bFA76c=
X-Received: by 2002:a2e:8951:0:b0:24b:1960:c6e8 with SMTP id
 b17-20020a2e8951000000b0024b1960c6e8mr11529268ljk.14.1649420809869; Fri, 08
 Apr 2022 05:26:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220408083332.19976-1-pablo@netfilter.org>
In-Reply-To: <20220408083332.19976-1-pablo@netfilter.org>
From:   Martin Gignac <martin.gignac@gmail.com>
Date:   Fri, 8 Apr 2022 08:26:14 -0400
Message-ID: <CANf9dFOApCzgHjHdfdByykzV38Q+gJ7wVJznWRQ+-5keqqvQ1g@mail.gmail.com>
Subject: Re: [PATCH nft] tests: py: extend meta time coverage
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By the way, I have just noticed that while this gives an error on 1.0.2:

    add rule inet filter input iif lo time < "2022-07-01 11:00" accept

This does not:

    add rule inet filter input iif lo meta time < "2022-07-01 11:00" accept

The use of 'meta' in front of 'time' works around the bug.

Should the tests include a few statements *without* 'meta'?

-Martin

On Fri, Apr 8, 2022 at 4:33 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Add meta time tests using < and > operands.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  tests/py/any/meta.t         |  2 ++
>  tests/py/any/meta.t.json    | 36 ++++++++++++++++++++++++++++++++++++
>  tests/py/any/meta.t.payload | 14 ++++++++++++++
>  3 files changed, 52 insertions(+)
>
> diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
> index fcf4292d63c0..e3beea2eed6c 100644
> --- a/tests/py/any/meta.t
> +++ b/tests/py/any/meta.t
> @@ -208,6 +208,8 @@ meta time "2019-06-21 17:00:00" drop;ok
>  meta time "2019-07-01 00:00:00" drop;ok
>  meta time "2019-07-01 00:01:00" drop;ok
>  meta time "2019-07-01 00:00:01" drop;ok
> +meta time < "2022-07-01 11:00:00" accept;ok
> +meta time > "2022-07-01 11:00:00" accept;ok
>  meta day "Saturday" drop;ok
>  meta day 6 drop;ok;meta day "Saturday" drop
>  meta day "Satturday" drop;fail
> diff --git a/tests/py/any/meta.t.json b/tests/py/any/meta.t.json
> index b140aaaa0e1c..5472dc85cfb5 100644
> --- a/tests/py/any/meta.t.json
> +++ b/tests/py/any/meta.t.json
> @@ -2561,6 +2561,42 @@
>      }
>  ]
>
> +# meta time < "2022-07-01 11:00:00" accept
> +[
> +    {
> +        "match": {
> +            "left": {
> +                "meta": {
> +                    "key": "time"
> +                }
> +            },
> +            "op": "<",
> +            "right": "2022-07-01 11:00:00"
> +        }
> +    },
> +    {
> +        "accept": null
> +    }
> +]
> +
> +# meta time > "2022-07-01 11:00:00" accept
> +[
> +    {
> +        "match": {
> +            "left": {
> +                "meta": {
> +                    "key": "time"
> +                }
> +            },
> +            "op": ">",
> +            "right": "2022-07-01 11:00:00"
> +        }
> +    },
> +    {
> +        "accept": null
> +    }
> +]
> +
>  # meta day "Saturday" drop
>  [
>      {
> diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
> index d8351c275e64..1543906273c0 100644
> --- a/tests/py/any/meta.t.payload
> +++ b/tests/py/any/meta.t.payload
> @@ -1003,6 +1003,20 @@ ip meta-test input
>    [ cmp eq reg 1 0x22eb8a00 0x15ad18e1 ]
>    [ immediate reg 0 drop ]
>
> +# meta time < "2022-07-01 11:00:00" accept
> +ip test-ip4 input
> +  [ meta load time => reg 1 ]
> +  [ byteorder reg 1 = hton(reg 1, 8, 8) ]
> +  [ cmp lt reg 1 0xf3a8fd16 0x00a07719 ]
> +  [ immediate reg 0 accept ]
> +
> +# meta time > "2022-07-01 11:00:00" accept
> +ip test-ip4 input
> +  [ meta load time => reg 1 ]
> +  [ byteorder reg 1 = hton(reg 1, 8, 8) ]
> +  [ cmp gt reg 1 0xf3a8fd16 0x00a07719 ]
> +  [ immediate reg 0 accept ]
> +
>  # meta day "Saturday" drop
>  ip test-ip4 input
>    [ meta load day => reg 1 ]
> --
> 2.30.2
>
