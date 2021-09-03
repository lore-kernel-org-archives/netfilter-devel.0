Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D56C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 14:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A30C6610E5
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 14:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhICOp3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Sep 2021 10:45:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348537AbhICOp3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Sep 2021 10:45:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630680266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oYmoc8mYJdeN2fYDtRplwKx2cRrK4p5TMkse+Lo33Yw=;
        b=GSFUITAItI3bAZMo+oqCQeWGaFKnX3VSEL2y/+8CFxP5jtS1OP3/O4eaPz6LbsF/Jz0TWH
        6mlW/vUZ3Sip0BiCQDGZEL4TWy5NH5VonbEYRQ+oYka4WL9snm2462f6RQBq2dU2fPuUfn
        lAdT5a4EwrwIhNidpyjoWk+1J11Ej94=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-xbRVjhMfOHWAO7e4aRLDEw-1; Fri, 03 Sep 2021 10:44:25 -0400
X-MC-Unique: xbRVjhMfOHWAO7e4aRLDEw-1
Received: by mail-wm1-f72.google.com with SMTP id e33-20020a05600c4ba100b002f8993a54f8so1089861wmp.7
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Sep 2021 07:44:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:date:message-id:mime-version:content-transfer-encoding;
        bh=oYmoc8mYJdeN2fYDtRplwKx2cRrK4p5TMkse+Lo33Yw=;
        b=QmEliUPjeZd/Dvc2RkB4zT7pM39LsvxQMfnHBF6naN5pXJcOzpPJYHcqtnKnQiLC1y
         SkUM4y+mDJInqnRo3W3u5rhZ9ohIgm4JxHQuoCcUDRzbpAl3/xPo4dCjxHnRdNwiaKNs
         RHKUpCEpzytlHy/Ft3mIUDjItg6I1JW30OyIk4SbbYzjHjSXReW/HkACrI4byP06awSU
         SC2W4BE4h9vnd73J4b1lq3DwBbPrBktHzHoF4vxPVIFgxuByG4NL/CCKKkCzDez+PeA7
         4Isu/XARVSkzhauZj9c4cgtcwGsXCHhW07y+jm44EEfLhulZrw6+C2b/hB+R92nFmhcr
         OGoA==
X-Gm-Message-State: AOAM5327JsVsWPFXnwMkbcH/0FY6HGxyBjnxEbEelaB6zOyGjcUA1LQQ
        qDElC0dk7wnzUE+AogiCwn0RrPYh3wtQPoNAtOPuD7tovx5VoyxlqaejJhXFREtNsv78105Szhf
        1Ayb+xwU22qOSURYeyO7nf9XEhRh4
X-Received: by 2002:a05:600c:4f0b:: with SMTP id l11mr769864wmq.126.1630680264044;
        Fri, 03 Sep 2021 07:44:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIJY7DG9eSNEXlRJc6RaVFKdBh0tjN873j73ZA1dfObmixv94PKlVRDRTF5KUEx/4X1vID4w==
X-Received: by 2002:a05:600c:4f0b:: with SMTP id l11mr769850wmq.126.1630680263831;
        Fri, 03 Sep 2021 07:44:23 -0700 (PDT)
Received: from localhost ([185.112.167.33])
        by smtp.gmail.com with ESMTPSA id g138sm4576577wmg.34.2021.09.03.07.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 07:44:23 -0700 (PDT)
From:   =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] iptables-test.py: print with color escapes
 only when stdout isatty
In-Reply-To: <20210903125250.GK7616@orbyte.nwl.cc>
References: <20210902113307.2368834-1-snemec@redhat.com>
 <20210903125250.GK7616@orbyte.nwl.cc>
User-Agent: Notmuch/0.32.3 (https://notmuchmail.org) Emacs/28.0.50
 (x86_64-pc-linux-gnu)
Date:   Fri, 03 Sep 2021 16:44:41 +0200
Message-ID: <20210903164441+0200.281220-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 03 Sep 2021 14:52:50 +0200
Phil Sutter wrote:

> With one minor nit:
>
>> diff --git a/iptables-test.py b/iptables-test.py
>> index 90e07feed365..e8fc0c75a43e 100755
>> --- a/iptables-test.py
>> +++ b/iptables-test.py
>> @@ -32,22 +32,25 @@ EXTENSIONS_PATH =3D "extensions"
>>  LOGFILE=3D"/tmp/iptables-test.log"
>>  log_file =3D None
>>=20=20
>> +STDOUT_IS_TTY =3D sys.stdout.isatty()
>>=20=20
>> -class Colors:
>> -    HEADER =3D '\033[95m'
>> -    BLUE =3D '\033[94m'
>> -    GREEN =3D '\033[92m'
>> -    YELLOW =3D '\033[93m'
>> -    RED =3D '\033[91m'
>> -    ENDC =3D '\033[0m'
>> +def maybe_colored(color, text):
>> +    terminal_sequences =3D {
>> +        'green': '\033[92m',
>> +        'red': '\033[91m',
>> +    }
>> +
>> +    return (
>> +        terminal_sequences[color] + text + '\033[0m' if STDOUT_IS_TTY e=
lse text
>> +    )
>
> I would "simplify" this into:
>
> | if not sys.stdout.isatty():
> | 	return text
> | return terminal_sequences[color] + text + '\033[0m'

...which could be further simplified by dropping 'not' and swapping the
two branches.

So there seem to be two things here: double return instead of
conditional expression, and calling the isatty method for every relevant
log line instead of once at the beginning.

I deliberately avoided the latter and I think I still prefer the
conditional expression to multiple return statements, too, but either
way should keep the escape sequences out of the log files and I don't
feel strongly about it.

Thanks,

  =C5=A0t=C4=9Bp=C3=A1n

