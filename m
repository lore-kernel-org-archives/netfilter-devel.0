Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D266C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 09:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B0A61050
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 09:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240365AbhIFJF2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 05:05:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229499AbhIFJF0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 05:05:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630919062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mAiExVbJPYX6GiXXopJYwntYcwd/qilx77PkEtv2b78=;
        b=TJS6XLCrQtp3zTlMtHaCEGoVdAmQipMTL4aePA0oa/DxA045j2YNPl1dVlanPNvuJgkC69
        DZmRBBgAQbajvMPDHdHuhB4IVd9JTf0oxYxY2iA9AoQk2M4kBNImH1GoIcaxMUNDEkkRbZ
        kjrig52d7zKS/CdTbREfMmDEHT/OMAw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-eyyufj1uO-iqB5irzSE3bQ-1; Mon, 06 Sep 2021 05:04:21 -0400
X-MC-Unique: eyyufj1uO-iqB5irzSE3bQ-1
Received: by mail-ed1-f72.google.com with SMTP id d25-20020a056402517900b003c7225c36c2so3407734ede.3
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Sep 2021 02:04:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:date:message-id:mime-version:content-transfer-encoding;
        bh=mAiExVbJPYX6GiXXopJYwntYcwd/qilx77PkEtv2b78=;
        b=MRdmbUVqnj4gJaYh5JCvga8IB8v8bVPxAl/Dd6ewSpXGlDcE/3jcbLVSLvpdxmUpgi
         urAs0cUAIR2D9HJNiv8N1VbQfdmeOavH3v+/LOxpqPwb9m29vgxw6X0NKBsrwQOkVEFq
         EUuAn2bPYfNrfeq7gE3vNvUBE38CX8vLxWV3s5Z80ghIqSX2MXreVPTr0oxPkDQ38M40
         og9pF1r6TuM/4kC9FX9/ge2KnqMNZRpYBCL3xCspsjKcJqheYDgp6jRkZ6IWqttE7sci
         6sJcmxTidWGw1mETFw0lmrtS2i0wBbupm5OB9vFYHcpGNxdYRfmiHB2PwrkstB0sw0Lj
         ZxrQ==
X-Gm-Message-State: AOAM531rPAfsND4Hfz3V35j9LYVXCVb1rm0JoRQyNMsZ9+LEdzwh4FyU
        vodRxeSstuG/edIy41Z8o+I2q6eftrIuImqZwPtgGtrt0V4CLGQ1+moAyuEkzkapZPztGBGG50q
        KUBsDTs4DTndalQjsk3exxCyywntk
X-Received: by 2002:aa7:dc56:: with SMTP id g22mr12161160edu.187.1630919059624;
        Mon, 06 Sep 2021 02:04:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxPPLKj0j9VKaFbltqx4KyPzQNujDXN26HTIiVBrvM5DjyX+eh9DqC9MxL7MHeAWq4HxlMRg==
X-Received: by 2002:aa7:dc56:: with SMTP id g22mr12161140edu.187.1630919059410;
        Mon, 06 Sep 2021 02:04:19 -0700 (PDT)
Received: from localhost ([185.112.167.33])
        by smtp.gmail.com with ESMTPSA id cn16sm4242605edb.87.2021.09.06.02.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 02:04:18 -0700 (PDT)
From:   =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] iptables-test.py: print with color escapes
 only when stdout isatty
In-Reply-To: <20210903153420.GM7616@orbyte.nwl.cc>
References: <20210902113307.2368834-1-snemec@redhat.com>
 <20210903125250.GK7616@orbyte.nwl.cc>
 <20210903164441+0200.281220-snemec@redhat.com>
 <20210903153420.GM7616@orbyte.nwl.cc>
User-Agent: Notmuch/0.32.3 (https://notmuchmail.org) Emacs/28.0.50
 (x86_64-pc-linux-gnu)
Date:   Mon, 06 Sep 2021 11:04:38 +0200
Message-ID: <20210906110438+0200.839986-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 03 Sep 2021 17:34:20 +0200
Phil Sutter wrote:

> On Fri, Sep 03, 2021 at 04:44:41PM +0200, =C5=A0t=C4=9Bp=C3=A1n N=C4=9Bme=
c wrote:
>> On Fri, 03 Sep 2021 14:52:50 +0200
>> Phil Sutter wrote:
>>=20
>> > With one minor nit:
>> >
>> >> diff --git a/iptables-test.py b/iptables-test.py
>> >> index 90e07feed365..e8fc0c75a43e 100755
>> >> --- a/iptables-test.py
>> >> +++ b/iptables-test.py
>> >> @@ -32,22 +32,25 @@ EXTENSIONS_PATH =3D "extensions"
>> >>  LOGFILE=3D"/tmp/iptables-test.log"
>> >>  log_file =3D None
>> >>=20=20
>> >> +STDOUT_IS_TTY =3D sys.stdout.isatty()
>> >>=20=20
>> >> -class Colors:
>> >> -    HEADER =3D '\033[95m'
>> >> -    BLUE =3D '\033[94m'
>> >> -    GREEN =3D '\033[92m'
>> >> -    YELLOW =3D '\033[93m'
>> >> -    RED =3D '\033[91m'
>> >> -    ENDC =3D '\033[0m'
>> >> +def maybe_colored(color, text):
>> >> +    terminal_sequences =3D {
>> >> +        'green': '\033[92m',
>> >> +        'red': '\033[91m',
>> >> +    }
>> >> +
>> >> +    return (
>> >> +        terminal_sequences[color] + text + '\033[0m' if STDOUT_IS_TT=
Y else text
>> >> +    )
>> >
>> > I would "simplify" this into:
>> >
>> > | if not sys.stdout.isatty():
>> > | 	return text
>> > | return terminal_sequences[color] + text + '\033[0m'
>>=20
>> ...which could be further simplified by dropping 'not' and swapping the
>> two branches.
>
> My change was mostly about reducing the long line, i.e. cosmetics. ;)

Ah, I see. I agree it's not the prettiest thing, but it's still in 80
columns (something that can't be said about a few other lines in the
script).

> One other thing I just noticed, you're dropping the other colors'
> definitions. Maybe worth keeping them?

Is it? I couldn't find anything but red and green ever being used since
2012 when the file was added.

> Also I'm not too happy about the Python exception if an unknown color
> name is passed to maybe_colored(). OTOH though it's just a test script
> and such bug is easily identified.

Yes, it's a helper function in a test script, not some kind of public
API. I don't see how maybe_colored('magenta', ...) is different in that
respect or more likely than print(Colors.MAGENTA + ...) previously.

--=20
=C5=A0t=C4=9Bp=C3=A1n

