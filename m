Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA85C197A0
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Nov 2023 16:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345282AbjKPQt2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Nov 2023 11:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345189AbjKPQt0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2023 11:49:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B935DB7
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2023 08:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700153362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=+hCQT9QwjlLr1phBfpRQD3Yrliraea0dwwTmAsCXSAE=;
        b=XeyTAV2mI2bqUMWL6QfRneA8GHSAyY1Wzl7tMZnuF3wfT28W+sBZuS3P8MHCPjrXFRnPy7
        8Bz6qb74IY/HFL08Qq5E3j1nXkP3NLFomDvKokupDLzHyC2IrN8n1PHjyzZdLyZKQm2nwm
        KS42J+wbwYHUXWriFeaEn7HY4XVAwaM=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-EuxbunQ1Oja4o5Bao-f0Kg-1; Thu, 16 Nov 2023 11:49:21 -0500
X-MC-Unique: EuxbunQ1Oja4o5Bao-f0Kg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2c852ade108so1615431fa.1
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2023 08:49:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700153359; x=1700758159;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+hCQT9QwjlLr1phBfpRQD3Yrliraea0dwwTmAsCXSAE=;
        b=Dg0PCNJWZcKI8p0Us3EBDHyBfqbrUPJbxEbZkxAktmbqn0MQAhfXV/blD65xpnpa72
         pdQ+5FzmUOQWFG8RZEsdG0B2ia9CUBsCtNzpWhKMnKIDigQc0Rk0YzZlQGdmBOsedkVw
         hLlItISJmqfqRxrzYob9pCalmn4HhCH2lq372JqTVNoDZxazNXQqOIKP89wzLnT25P9j
         UqTVL2xNGUrhYOjD7O1k74uDhuAvWsu+iyLFGcxxvQSwVzHRTCeLOtyEs3cR4v+Ezcbq
         +STR/ZIiD/Pp5l3TbA7lvTH4Q/WAF06pHCQoWzGt3RC7gmV8a5jfVoTnwgH2WBwg+xjL
         YssQ==
X-Gm-Message-State: AOJu0YyPk6Pb24p+DdPSTyRyHJBLLzAridP9eQbJwI9dTtHro+TDHky1
        I7tsHG0YSzUq0iuH+Mpqexc01SiKRypuyoks2u8DGY3Zj10vK5eRqrWrCRe2JwOYmkZAgUUkOa7
        Fgf5lDM0183Wfw12Rds2mGnd0PgbVwb0QXjHb
X-Received: by 2002:a2e:9e18:0:b0:2c5:36e:31bf with SMTP id e24-20020a2e9e18000000b002c5036e31bfmr5417396ljk.5.1700153359759;
        Thu, 16 Nov 2023 08:49:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGA/tDAADox1frshQ/+qqO8vTCHHucdeg79BdG0n8bUfuU3Ct7EfMCLar5p4S4UpSXDdkt/Sg==
X-Received: by 2002:a2e:9e18:0:b0:2c5:36e:31bf with SMTP id e24-20020a2e9e18000000b002c5036e31bfmr5417389ljk.5.1700153359334;
        Thu, 16 Nov 2023 08:49:19 -0800 (PST)
Received: from [10.0.0.196] ([37.186.166.196])
        by smtp.gmail.com with ESMTPSA id p22-20020a17090635d600b009ad829ed144sm8603996ejb.130.2023.11.16.08.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Nov 2023 08:49:18 -0800 (PST)
Message-ID: <984b4a455041f991f50957dbdacff434df5e8f4c.camel@redhat.com>
Subject: Re: [PATCH nft v3 2/6] tests/shell: check and generate JSON dump
 files
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
Date:   Thu, 16 Nov 2023 17:49:18 +0100
In-Reply-To: <ZVY++RiqayXOZSBQ@calendula>
References: <20231114153150.406334-1-thaller@redhat.com>
         <20231114160903.409552-1-thaller@redhat.com>
         <20231115082427.GC14621@breakpoint.cc> <ZVSVPgRFv9tTF4yQ@calendula>
         <20231115100101.GA23742@breakpoint.cc> <ZVSgywZtf8F7nFop@calendula>
         <20231115122105.GD23742@breakpoint.cc> <ZVS530oqzSu/cgQS@calendula>
         <7f0da90a92e339594c9a86a6eda6d0be2df6155b.camel@redhat.com>
         <ZVY++RiqayXOZSBQ@calendula>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 (3.50.0-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-11-16 at 17:10 +0100, Pablo Neira Ayuso wrote:
> It seems that handles are a problem in this diff.


Hi,


It's a bit surprising that this happens. Do you use unshare (the
default), to create a separate netns for each test? For me, those
handles then grow incrementally from 1.=20


A possible workaround would be the following (and a `DUMPGEN=3Dy` run)



diff --git c/tests/shell/helpers/json-sanitize-ruleset.sh w/tests/shell/hel=
pers/json-sanitize-ruleset.sh
index 270a6107e0aa..22a57d72110e 100755
--- c/tests/shell/helpers/json-sanitize-ruleset.sh
+++ w/tests/shell/helpers/json-sanitize-ruleset.sh
@@ -6,7 +6,12 @@ die() {
 }
=20
 do_sed() {
-	sed '1s/\({"nftables": \[{"metainfo": {"version": "\)[0-9.]\+\(", "releas=
e_name": "\)[^"]\+\(", "\)/\1VERSION\2RELEASE_NAME\3/' "$@"
+	# Also normalize all "handle". Optimally, those handles would be stable
+	# and reproducible. However, they are not.
+	sed \
+		-e '1s/\({"nftables": \[{"metainfo": {"version": "\)[0-9.]\+\(", "releas=
e_name": "\)[^"]\+\(", "\)/\1VERSION\2RELEASE_NAME\3/' \
+		-e '1s/"handle": [0-9]\+\>/"handle": 1/g' \
+		"$@"
 }
=20
 if [ "$#" =3D 0 ] ; then




