Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE123C072A2
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Nov 2023 17:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjKQRXq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Nov 2023 12:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbjKQRXp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Nov 2023 12:23:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804C8D72
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 09:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700241820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=vVpSoqfAf9j1HyRG/vB53nhsjeAUZ0yDqtohOj3Ou2Q=;
        b=U4XJcsh9Yr2XcKkFyJnd+hHu4WXwEohe23jAjK52MNkbyxhuPEzxm8X3lcnmV1XSF8wzOw
        b+XxLrDXUaFD7NIUDj1cDPgVa1QxfrLNsxvR4gBwQVQImwCq9B3tMghGk5FU5mHdpw1cXP
        9VDFiZYy6tMPWTjz82zf+i5S9NPppo4=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-p2wdKK3_Pk2nE1bszq9chw-1; Fri, 17 Nov 2023 12:23:38 -0500
X-MC-Unique: p2wdKK3_Pk2nE1bszq9chw-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-50798dd775dso377141e87.1
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 09:23:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700241816; x=1700846616;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vVpSoqfAf9j1HyRG/vB53nhsjeAUZ0yDqtohOj3Ou2Q=;
        b=SlAoB5XJ/XACX/FRB0B0S08IPk7Mk7dYtB3Vqj1J48R+g0t1jKX/NrdlcX6RmGR2oT
         LpQGP0rvAATec/zwSYaB48WS67Kwan8XOyLrUPnLcYqowRc7JRgF+A3wFhhc0xonqd6j
         Z4FeUMaDbDjFq8SknMu6rJ6megxaEOPCN4nVcHnSD1sLHUtC7hzejHE8fQ6GlOlFQvkT
         W//bRIvd/Coptc0JflI10U+/jbIqFaWZMSNF0no2rQYl8a0hxsmB+6waJD3O2pZWzGwH
         gIkb+GJ1rv0u/k3cx3nt5Dgm4j1WoQ7CE9HZ+1EJJBkxxxLjecyOikvTBuozjgviYPEj
         H/UQ==
X-Gm-Message-State: AOJu0Ywm3I/QF9tlp2fQyuYwqzNpYwpAMtPstbErQ1t8C9NBkBxrHc17
        t4JP7nYMv8Fzw2VHC8LqAp74gwiQWcuvrnXhwB3L31VvFnyzk4vLsVgUlVcvOsWtdI0Bof9mXmX
        ViSe3OX3yk0zL+O5aDsICgO/tpqQnjgC5b5Uo
X-Received: by 2002:a05:6512:1241:b0:509:8d70:49e8 with SMTP id fb1-20020a056512124100b005098d7049e8mr150618lfb.6.1700241816730;
        Fri, 17 Nov 2023 09:23:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmRSldlsNC5qDk65Xpgf1DTBO99mV2qp6ibXvrbRdn9Gq4R5h2ztNDF0Ng5rSKkBTRUibYqA==
X-Received: by 2002:a05:6512:1241:b0:509:8d70:49e8 with SMTP id fb1-20020a056512124100b005098d7049e8mr150597lfb.6.1700241816310;
        Fri, 17 Nov 2023 09:23:36 -0800 (PST)
Received: from [10.0.0.196] ([37.186.166.196])
        by smtp.gmail.com with ESMTPSA id w23-20020aa7da57000000b0053db0df6970sm910765eds.54.2023.11.17.09.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 09:23:35 -0800 (PST)
Message-ID: <859777cb74f7edb825c71dd1d01ae976c8416551.camel@redhat.com>
Subject: Re: [PATCH nft v3 2/6] tests/shell: check and generate JSON dump
 files
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 17 Nov 2023 18:23:35 +0100
In-Reply-To: <ZVeesPraB1QucCEG@orbyte.nwl.cc>
References: <ZVSgywZtf8F7nFop@calendula>
         <20231115122105.GD23742@breakpoint.cc> <ZVS530oqzSu/cgQS@calendula>
         <7f0da90a92e339594c9a86a6eda6d0be2df6155b.camel@redhat.com>
         <ZVY++RiqayXOZSBQ@calendula> <20231116230024.GA1206@breakpoint.cc>
         <797cf41472ad1481cb3cc6e4abdbd0853d4b253c.camel@redhat.com>
         <ZVeWh0xZA30H/tVM@calendula> <ZVebe9GK7VHbc4Rm@orbyte.nwl.cc>
         <8fb19cee0ad20e5cf13318b9449310ace75622ee.camel@redhat.com>
         <ZVeesPraB1QucCEG@orbyte.nwl.cc>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 (3.50.0-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2023-11-17 at 18:11 +0100, Phil Sutter wrote:
> On Fri, Nov 17, 2023 at 06:06:16PM +0100, Thomas Haller wrote:
> > On Fri, 2023-11-17 at 17:57 +0100, Phil Sutter wrote:
> > > On Fri, Nov 17, 2023 at 05:36:23PM +0100, Pablo Neira Ayuso
> > > wrote:
> > > > On Fri, Nov 17, 2023 at 05:16:02PM +0100, Thomas Haller wrote:
> > > > > On Fri, 2023-11-17 at 00:00 +0100, Florian Westphal wrote:
> > > > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > > > Hi Thomas,
> > > > > > >=20
> > > > > > > On Wed, Nov 15, 2023 at 01:36:40PM +0100, Thomas Haller
> > > > > > > wrote:
> > > > > > > > On Wed, 2023-11-15 at 13:30 +0100, Pablo Neira Ayuso
> > > > > > > > wrote:
> > > > > > > [...]
> > > > > > > > > I see _lots_ of DUMP FAIL with kernel 5.4
> > > > > > > >=20
> > > > > > > > Hi,
> > > > > > > >=20
> > > > > > > > Could you provide more details?
> > > > > > > >=20
> > > > > > > > For example,
> > > > > > > >=20
> > > > > > > > =C2=A0=C2=A0=C2=A0 make -j && ./tests/shell/run-tests.sh
> > > > > > > > tests/shell/testcases/include/0007glob_double_0 -x
> > > > > > > > =C2=A0=C2=A0=C2=A0 grep ^ -a -R /tmp/nft-test.latest.*/
> > > > > > >=20
> > > > > > > # cat [...]/ruleset-diff.json
> > > > > > > --- testcases/include/dumps/0007glob_double_0.json-nft=C2=A0
> > > > > > > 2023-
> > > > > > > 11-15
> > > > > > > 13:27:20.272084254 +0100
> > > > > > > +++ /tmp/nft-test.20231116-170617.584.lrZzMy/test-
> > > > > > > testcases-
> > > > > > > include-0007glob_double_0.1/ruleset-after.json=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 2023-
> > > > > > > 11-
> > > > > > > 16
> > > > > > > 17:06:18.332535411 +0100
> > > > > > > @@ -1 +1 @@
> > > > > > > -{"nftables": [{"metainfo": {"version": "VERSION",
> > > > > > > "release_name":
> > > > > > > "RELEASE_NAME", "json_schema_version": 1}}, {"table":
> > > > > > > {"family":
> > > > > > > "ip", "name": "x", "handle": 1}}, {"table": {"family":
> > > > > > > "ip",
> > > > > > > "name": "y", "handle": 2}}]}
> > > > > > > +{"nftables": [{"metainfo": {"version": "VERSION",
> > > > > > > "release_name":
> > > > > > > "RELEASE_NAME", "json_schema_version": 1}}, {"table":
> > > > > > > {"family":
> > > > > > > "ip", "name": "x", "handle": 158}}, {"table": {"family":
> > > > > > > "ip",
> > > > > > > "name": "y", "handle": 159}}]}
> > > > > > >=20
> > > > > > > It seems that handles are a problem in this diff.
> > > > > >=20
> > > > > > Are you running tests with -s option?
> > > > > >=20
> > > > > > In that case, modules are removed after each test.
> > > > > >=20
> > > > > > I suspect its because we can then hit -EAGAIN mid-
> > > > > > transaction
> > > > > > because module is missing (again), then replay logic does
> > > > > > its
> > > > > > thing.
> > > > > >=20
> > > > > > But the handle generator isn't transaction aware,
> > > > > > so it has advanced vs. the aborted partial transaction.
> > > > >=20
> > > > > > I'm not sure what to do here.
> > > > >=20
> > > > > a combination of:
> > > > >=20
> > > > > a) make an effort, that kernel behavior is consistent and
> > > > > reproducible.
> > > > > Stable output seems important to me, and the automatic
> > > > > loading of
> > > > > a
> > > > > kernel module should not make a difference. This is IMO a
> > > > > bug.
> > > >=20
> > > > This is not a bug in the kernel. The kernel guarantees that the
> > > > handle
> > > > is unique, but the handle allocation strategy is up to the
> > > > kernel.
> > > > Userspace cannot forecast what handle will get, such thing
> > > > might
> > > > lead
> > > > to easy to break assumptions from userspace.
> > > >=20
> > > > > b) let `nft -j list ruleset` honor (the lack of) `--handle`
> > > > > option and
> > > > > not print those handles. That bugfix would change behavior,
> > > > > so
> > > > > maybe
> > > > > instead add a "--no-handle" option for `nft -j` dumps.
> > >=20
> > >=20
> > > >=20
> > > > Will honoring -a/--handle break firewalld? I think it is the
> > > > main
> > > > user
> > > > of the JSON API. That might help disentangle if this makes
> > > > sense or
> > > > not and what the chances of breaking third party applications
> > > > are.
> > > >=20
> > > > I'd prefer not to see a --no-handle that will only work for
> > > > JSON
> > > > and
> > > > that is only useful for this test infrastructure (noone else
> > > > asked
> > > > for
> > > > this).
> > > >=20
> > > > > c) sanitize the output with the sed command (my other mail).
> > > > >=20
> > > > > This also means, that the .json-nft dumps won't work, if you
> > > > > run
> > > > > without `unshare`. IMO, the mode without unshare should not
> > > > > be
> > > > > supported anymore. But if it's deemed important, then it
> > > > > requires
> > > > > b) or
> > > > > c) or detect the case and skip the diffs with .json-nft.
> > >=20
> > > What is the problem without unshare? Looking at your patch, it
> > > seems
> > > possible to drop the handle attributes in json-sanitize-
> > > ruleset.sh.
> >=20
> > Yes, (b) would suffice. I said "or" :)
> >=20
> > No further problem, but without-unshare seems not a useful thing to
> > support. The test-run takes significantly longer, interferes with
> > the
> > caller's netns and requires CAP_NET_ADMIN.
>=20
> No, I was wondering why with option (c) "This also means, that the
> .json-nft dumps won't work, if you run without `unshare`."
>=20
> Because I vote for that option. ;)

Yes, sorry. I got confused with my own numbering :)

I meant also c)


> > >=20
> > > > a) is no-go (kernel update to make test infrastructure or to
> > > > allow
> > > > userspace application to make fragile assumptions on how
> > > > handles
> > > > are
> > > > allocated is not correct).
> > > >=20
> > > > b) needs to evaluated, you maintain firewalld, let us know.
> > >=20
> > > Given the inherent importance of the handle value for ruleset
> > > manipulations, I assume *any* application will need to be updated
> > > to
> > > pass --handle (or the libnftables-equivalent) to remain
> > > functional.
> >=20
> > Right. So a "--no-handle" / NFT_CTX_OUTPUT_NO_HANDLE flag for JSON
> > output?
>=20
> Should not be needed. IIUC, the test infrastructure you're about to
> introduce sanitizes the JSON output already anyway, right?

Right. c) alone may very well suffice.

I just sent a patch to that amount.


I still think that `nft -j` ignoring the lack of "--no-handle" /
NFT_CTX_OUTPUT_NO_HANDLE is a bug. At the very last a documentation
bug.


Thomas

