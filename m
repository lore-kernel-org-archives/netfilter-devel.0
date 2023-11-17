Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F5DC072A2
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Nov 2023 16:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjKQQQM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Nov 2023 11:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjKQQQL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Nov 2023 11:16:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CA8A4
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 08:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700237767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=8+YFeJwmEDI85U85mwu2+wsw0U/PcyVAvmt2LBzT1kw=;
        b=Xg4Ub7quOtbVX76P+HMHyU0ext1DIXF0tE79P/zWtLOBhUUHn/6aWPRft3byD5w4kKHLlY
        bXZbhMn14+IQ1qxX0STIJ/3Fu/zgdcXjvStMt9g+lSFUhMQ4KWMhVxnYv31wDGrWMgVjU7
        8oiHwGyd84iHAPWSLA4pvJ3Fx1I8A5M=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-gmclGe3YOF6TJT1saPY5Kg-1; Fri, 17 Nov 2023 11:16:05 -0500
X-MC-Unique: gmclGe3YOF6TJT1saPY5Kg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9bfacbcabb1so28096366b.0
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 08:16:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700237764; x=1700842564;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8+YFeJwmEDI85U85mwu2+wsw0U/PcyVAvmt2LBzT1kw=;
        b=uYk2xpD9hhNIsRAtgwAq1+qwvMhTCgPZX8xJdcXqhKjvQEzQMXJVUD/yj3xxQA5rsQ
         m5EPHvPghC+sZaakh2jwFmQcpWW/3yCug8MmB8HLpWkLO2l4aGO8WwJxzyPWxc93r1W7
         484DksNnLWxvoecqECEhDmG9yDUo2lfB+1hrh0mz0lag2Ii1/mbbCYA2mZJB6iYHORAJ
         eXTIgsYnVu4VEJ59lSwamLrBka9u9Oi8ALWkN+zttWhP0dgty+Dx/Xcazh5jDmrrufpZ
         J4V9cN4TbfWuU8RkZR9dca0xCf/noswcGyPfAxVdx2Wj4aS0EXzoLPsOXqWzmeOdNcJv
         33Eg==
X-Gm-Message-State: AOJu0YyeF3OCojgmab3XluGynJM3UtRPSXOteL0qnCHR3RgfDtQZaEy9
        5H5AbrM+HKDZtBISgHKXvsE/oTzBiYj4CHIWyq2ElEDCZMJuD1YXwf/HcxSixl5AjZ1FneXCsWh
        CVA5VjTUTaTa/JI6FJoyZ+1IdXRsd
X-Received: by 2002:a17:906:25d:b0:9dd:5609:55b9 with SMTP id 29-20020a170906025d00b009dd560955b9mr9358592ejl.2.1700237764557;
        Fri, 17 Nov 2023 08:16:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6twA8d/XcMkX8abSm9FC0c6SD3faCGd2eFrNm0/dBOn9qCSWs9kn0vSFfA8QzTntFeWbVjg==
X-Received: by 2002:a17:906:25d:b0:9dd:5609:55b9 with SMTP id 29-20020a170906025d00b009dd560955b9mr9358574ejl.2.1700237764172;
        Fri, 17 Nov 2023 08:16:04 -0800 (PST)
Received: from [10.0.0.196] ([37.186.166.196])
        by smtp.gmail.com with ESMTPSA id y5-20020a170906558500b009e5d5f92912sm934445ejp.20.2023.11.17.08.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 08:16:03 -0800 (PST)
Message-ID: <797cf41472ad1481cb3cc6e4abdbd0853d4b253c.camel@redhat.com>
Subject: Re: [PATCH nft v3 2/6] tests/shell: check and generate JSON dump
 files
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 17 Nov 2023 17:16:02 +0100
In-Reply-To: <20231116230024.GA1206@breakpoint.cc>
References: <20231114153150.406334-1-thaller@redhat.com>
         <20231114160903.409552-1-thaller@redhat.com>
         <20231115082427.GC14621@breakpoint.cc> <ZVSVPgRFv9tTF4yQ@calendula>
         <20231115100101.GA23742@breakpoint.cc> <ZVSgywZtf8F7nFop@calendula>
         <20231115122105.GD23742@breakpoint.cc> <ZVS530oqzSu/cgQS@calendula>
         <7f0da90a92e339594c9a86a6eda6d0be2df6155b.camel@redhat.com>
         <ZVY++RiqayXOZSBQ@calendula> <20231116230024.GA1206@breakpoint.cc>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 (3.50.0-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2023-11-17 at 00:00 +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Thomas,
> >=20
> > On Wed, Nov 15, 2023 at 01:36:40PM +0100, Thomas Haller wrote:
> > > On Wed, 2023-11-15 at 13:30 +0100, Pablo Neira Ayuso wrote:
> > [...]
> > > > I see _lots_ of DUMP FAIL with kernel 5.4
> > >=20
> > > Hi,
> > >=20
> > > Could you provide more details?
> > >=20
> > > For example,
> > >=20
> > > =C2=A0=C2=A0=C2=A0 make -j && ./tests/shell/run-tests.sh
> > > tests/shell/testcases/include/0007glob_double_0 -x
> > > =C2=A0=C2=A0=C2=A0 grep ^ -a -R /tmp/nft-test.latest.*/
> >=20
> > # cat [...]/ruleset-diff.json
> > --- testcases/include/dumps/0007glob_double_0.json-nft=C2=A0 2023-11-15
> > 13:27:20.272084254 +0100
> > +++ /tmp/nft-test.20231116-170617.584.lrZzMy/test-testcases-
> > include-0007glob_double_0.1/ruleset-after.json=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 2023-11-16
> > 17:06:18.332535411 +0100
> > @@ -1 +1 @@
> > -{"nftables": [{"metainfo": {"version": "VERSION", "release_name":
> > "RELEASE_NAME", "json_schema_version": 1}}, {"table": {"family":
> > "ip", "name": "x", "handle": 1}}, {"table": {"family": "ip",
> > "name": "y", "handle": 2}}]}
> > +{"nftables": [{"metainfo": {"version": "VERSION", "release_name":
> > "RELEASE_NAME", "json_schema_version": 1}}, {"table": {"family":
> > "ip", "name": "x", "handle": 158}}, {"table": {"family": "ip",
> > "name": "y", "handle": 159}}]}
> >=20
> > It seems that handles are a problem in this diff.
>=20
> Are you running tests with -s option?
>=20
> In that case, modules are removed after each test.
>=20
> I suspect its because we can then hit -EAGAIN mid-transaction
> because module is missing (again), then replay logic does its
> thing.
>=20
> But the handle generator isn't transaction aware,
> so it has advanced vs. the aborted partial transaction.

> I'm not sure what to do here.

a combination of:

a) make an effort, that kernel behavior is consistent and reproducible.
Stable output seems important to me, and the automatic loading of a
kernel module should not make a difference. This is IMO a bug.

b) let `nft -j list ruleset` honor (the lack of) `--handle` option and
not print those handles. That bugfix would change behavior, so maybe
instead add a "--no-handle" option for `nft -j` dumps.=20

c) sanitize the output with the sed command (my other mail).



This also means, that the .json-nft dumps won't work, if you run
without `unshare`. IMO, the mode without unshare should not be
supported anymore. But if it's deemed important, then it requires b) or
c) or detect the case and skip the diffs with .json-nft.


Thomas

