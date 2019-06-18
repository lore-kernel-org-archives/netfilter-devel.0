Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FA1C31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 11:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 851BD2070B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 11:51:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqrAijU/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbfFRLvC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 07:51:02 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:45387 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729662AbfFRLvB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 07:51:01 -0400
Received: by mail-io1-f52.google.com with SMTP id e3so28931975ioc.12;
        Tue, 18 Jun 2019 04:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BrGHWSLq11Sh1FZ/Sc2KBI5A9E+jcTCp7hB2YsOl0OY=;
        b=DqrAijU/5/i0KSTvuSdU9I6zxTnE4xvdgQiUXhd7X2LSgsAIbtPxg1M0ZeLPxeffd/
         FkQ09sRSqwIInpt5Cm6Lywajux0JzW+E0N668DtzfZx1UEbZDQt/KiYkDP2P1BUL4cgo
         ge2Isg5UZVp/mfnP7gmY8AbDKIkkJ3j01PcnKWIwyedQmVw13TWsQUPGcjLrMU3M9kR0
         sVQ260yjaR7wwbbjm9egFDBkyssuQGvVwm9xc1frLpRKBckaw+lW9YLRXEMn5nP/FG+8
         7Xd19tOIvXVi1voJZfcGd3qUrroxWLLVQ/SgYKCQrcAcH/TGRWZ/TThsCPMEBNe58f6B
         AaOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BrGHWSLq11Sh1FZ/Sc2KBI5A9E+jcTCp7hB2YsOl0OY=;
        b=KHkFi18SEX3lensHmzNpLFgbIRIk8zSl8d8SBxyFOy53genDDicFpd1FEixquavuq2
         UBDtXDxRhkeAw6KoJUi63HNCL67JBJtENej2J85pW9TEri+X27lLLu10EzDpsz+aEiPT
         pCqabG4zov8kUyg0fsvqj1/avMIDw9PLP12idaiRW93YvH7pZDlj2cLjyDiWLvl3Gdnr
         JxJ/mG0InNnXJGFnNthGI7NoyvEvNqUKm5ZPZ/9FsbOiRFo81+vP11dHkaib5QThDvwO
         rKWd2u/lBWaoMnZhwZHs+Egj3ODKq3zO8FsHlLqyfy6DqnSo9Y4xNgq1/A9xGJu7xq/g
         ULdw==
X-Gm-Message-State: APjAAAVsVB8Qack6ztpHJMedZH4wMHKDp/WTqC5TkWHpY+yuvvdEwqkv
        umfRbBrJ/3hlh/Hs0snbFxWVhQEAGZyC0TZbwbs=
X-Google-Smtp-Source: APXvYqwqM0FwA7xuhOJn/Ap8511N3Ryw2OPl6OCltl6zRiIngOahZ2oZsdpwFuBwXfz9L7EZvR0DH3phDhxw31ybj7I=
X-Received: by 2002:a5d:8508:: with SMTP id q8mr5830592ion.31.1560858660873;
 Tue, 18 Jun 2019 04:51:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAK6Qs9mam2U6JdeBnkzX9sfdeWWkLx_+ZgHOTmYjSC2wKfg0cQ@mail.gmail.com>
 <20190618104041.unuonhmuvgnlty3l@breakpoint.cc> <OFD1A8080A.6956CA33-ON0025841D.003AFD98-C125841D.003BC900@notes.na.collabserv.com>
In-Reply-To: <OFD1A8080A.6956CA33-ON0025841D.003AFD98-C125841D.003BC900@notes.na.collabserv.com>
From:   =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date:   Tue, 18 Jun 2019 14:50:49 +0300
Message-ID: <CAK6Qs9nUPeGqVG=2vZ-8r9mqUVmCSs3c6wpmTrEfvvX0CGj5Ww@mail.gmail.com>
Subject: Re: Is this possible SYN Proxy bug?
To:     Andre Paulsberg-Csibi <Andre.Paulsberg-Csibi@no.ibm.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 1:53 PM Andre Paulsberg-Csibi
<Andre.Paulsberg-Csibi@no.ibm.com> wrote:
>
> Maybe a suggestion would be to also have a setting/option where SYNPROXY uses the same MSS as the original packet ?
>
>
As I know, Syn proxy should imitates client and server. To do that, It
should send mss value to client that we set in iptables rule. Same way
it should send mss value to server that what client send already .
These should be default behavior, not an option.
