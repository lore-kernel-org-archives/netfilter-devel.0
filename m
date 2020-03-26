Return-Path: <SRS0=p5Wx=5L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D136C2D0E8
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 14:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CB1A206F8
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 14:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aorns7ih"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgCZOT7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Mar 2020 10:19:59 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44802 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727652AbgCZOT6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 10:19:58 -0400
Received: by mail-lj1-f193.google.com with SMTP id p14so6543309lji.11;
        Thu, 26 Mar 2020 07:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vi/3G4BkWmGkT3E57WouG+T2Aoil12b1B1ROkEwvQD4=;
        b=aorns7ihJyGghdGNSWaw9hOtwf0GQT6viuhAiOE768Y1A4Q8lCm+oa/IkJDFxiN9Ld
         VlEAl3P+rHxmNlRIOjImtkis8npHCFPIVTJLOAUD+4bmZig1fLnawyK4rQuUmNnYD4O4
         BK+me/G62erO1gQalxB5cvfiR7exqqPIzh5P2edhMXaZ6OKN1pQamtRE6LlI4Oy1BzpB
         gEIVuj4McbDmHA7cICzPOqII2hTOIOfiaLGi2HNCAjYLbc6eg84YGg6Qoj54FvrmS0zX
         WioyKpo1A0a5qrdZj5HVP6qe2J4uufGUBYAM2INi0qITFPFVa8XdR9xEQ9VQJmLMEI89
         ZMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vi/3G4BkWmGkT3E57WouG+T2Aoil12b1B1ROkEwvQD4=;
        b=KX/ojd1RBARlpD7wf2mObfoFNPrTZmbxMmDOxeGkp3Fld8wL7/eB2jt9tbSqPiQ49N
         Al/nHvFxum+X2f5xBtJTQde8jhJOed4FgzUKb55NtQOulLzDUUyd9B2s35SufJ8qj9Mk
         HNuuYthPKqmnGQiqWhgKbKmm8vkaYXjo5+oy6WG/b8CXN90r+rrSXicVl7ucOit4QlRK
         LlIIG15ehGCFovyVQ9lEoz/NS+PqpZ3Pxt2ygajCHtWYM6pRpCNkPmJkM03Si4UchLmp
         jqz/049+G+jzotBiamGeX6737vyvoiGOEkQ1fEXPMPCLmss2wj707HY7xDYgdsKdEucc
         Eqmg==
X-Gm-Message-State: ANhLgQ1AedNwt2+RCj4mD9KCiugruiCI1qsJhHhqI62PSluRP4oSsRvT
        1fMZjUDuEG9G4xda8bAXTBdgYEbAjULeRmPPVJw=
X-Google-Smtp-Source: ADFU+vsOY7wOtrWIwXZIC+ONOCDnjwwejmKylIX70OR0oCJim7hZQvEkhCwEnBwEfgRr9YOZBoi0q5E2pj/ynD7Sov8=
X-Received: by 2002:a2e:9ad2:: with SMTP id p18mr5273631ljj.15.1585232394383;
 Thu, 26 Mar 2020 07:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200320030015.195806-1-zenczykowski@gmail.com>
 <20200326135959.tqy5i4qkxwcqgp5y@salvia> <CAHo-OoyGEPKdU5ZEuY29Zzi4NGzD-QMw7Pb-MTXjdKTj-Kj-Pw@mail.gmail.com>
 <CAHo-OozGK7ANfFDBnLv2tZVuhXUw1sCCRVTBc0YT7LvYVXH_ZQ@mail.gmail.com> <CAHo-Oow8otp4ruAUpvGYjXN_f3dsbprg_DKOGG6HNhe_Z8X8Vg@mail.gmail.com>
In-Reply-To: <CAHo-Oow8otp4ruAUpvGYjXN_f3dsbprg_DKOGG6HNhe_Z8X8Vg@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Thu, 26 Mar 2020 07:19:44 -0700
Message-ID: <CAHo-OoxMNBTDZW_xqp1X3SGncM-twAySrdnc=ntS7_e2j0YEaA@mail.gmail.com>
Subject: Re: [PATCH] iptables: open eBPF programs in read only mode
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailinglist 
        <netfilter-devel@vger.kernel.org>, Chenbo Feng <fengc@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ugh, and I guess that on a pre-4.15 kernel it would cause failures due
to unknown flag...

Maybe we need to try with flag and fallback to without...
