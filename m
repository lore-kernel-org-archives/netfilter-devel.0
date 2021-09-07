Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013D3C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Sep 2021 07:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC63460C3E
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Sep 2021 07:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbhIGHHv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Sep 2021 03:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbhIGHHv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Sep 2021 03:07:51 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C57C061575
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Sep 2021 00:06:45 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e7so8982889pgk.2
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Sep 2021 00:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=kvUXQbi78FQ9gPnznujNqclnPvPk0qPKV8scX7BImAI=;
        b=JLDP5pXEt/s3UvbXiVgvrl+ZvszLhzVRURUdyQEmqjUeii+4oP2PlnjOTPLrMFN0r6
         Msg6Nxrx8DK0gQLwAOxp4Akp96q1sOzLPG07017gNtL8AdPLboP6Va+mzeAIpHkkawX0
         7uEhstIUBKDUmio4Hif0r0tNB6lQhkHWBQwfzCilrd5oPiu9sTFKH2j9Bs+V6YwezrkJ
         9tLo4Do0KdOPgD5vlfx6o89g2bXI+3iAkhvubAClLPOe0gs/HKNH0xi7FXSq5bxIJ+hV
         z+4uRQtiqdC8I3J/6YWsdr3BjRpnksjlWg63DZya6vJAOPdwNQW51eIBMWefgMIcgYjp
         0+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=kvUXQbi78FQ9gPnznujNqclnPvPk0qPKV8scX7BImAI=;
        b=gtEO31jV4xg0IehXlVNZSSCw6QqQ2wrc7+gKQrjQkrI82VjA5TltFD9pZ3NFyX+R8o
         6KYX6g/QqBcl0qZNgYcpnCVxHEJpwerj9FwU0Q8YJVJ/L15DBZplp5fNgE23e2rJwXfG
         VVxolbny3zp47d3beSMIZcy7VqrOEe8qKYiJnKY4Buh36RFTiAROJQPHWw9Ym5cojpQg
         DYCTjZJKmed1wlOh9Os6uvQ7LrA84U0NAUM/gVD8eatzAflG5N4a8pcIw2fO9z3fSOau
         XduNERT6zQa++mb4UHJD5gLFQBso5yMi8lgYWmGaXAyWK3xa/cNhH5eYG+uaRehZ2Qqw
         A2Uw==
X-Gm-Message-State: AOAM531zXAfIFOYqw4DL76n/4WU6SoAoz4yGrq+V3bumw/Cnb7qYVIIZ
        j+Kkydh58KNtVgq3WiyNMMGE2zRsbto=
X-Google-Smtp-Source: ABdhPJxEkhvfgCv1nFBrpKPDRES82XCeEPycZ2/kVxWs0T4gh7zxLDWd20p7F8fRizAMFc+TTH9kSQ==
X-Received: by 2002:a63:f817:: with SMTP id n23mr15341710pgh.250.1630998404761;
        Tue, 07 Sep 2021 00:06:44 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id x4sm1444029pjq.20.2021.09.07.00.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 00:06:43 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Tue, 7 Sep 2021 17:06:39 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log] src: doc: revise doxygen for module
 "Netlink message helper functions"
Message-ID: <YTcPf/hXWGpHY5Z/@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210905023320.29740-1-duncan_roe@optusnet.com.au>
 <20210906230424.GA356@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906230424.GA356@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 07, 2021 at 01:04:24AM +0200, Pablo Neira Ayuso wrote:
> On Sun, Sep 05, 2021 at 12:33:20PM +1000, Duncan Roe wrote:
> > Adjust style to work better in a man page.
> > Document actual return values.
>
> All good, except one chunk I'm ambivalent.
>
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> >  src/nlmsg.c | 53 +++++++++++++++++++++++++----------------------------
> >  1 file changed, 25 insertions(+), 28 deletions(-)
> >
> > diff --git a/src/nlmsg.c b/src/nlmsg.c
> > index 3ebb364..399b19a 100644
> > --- a/src/nlmsg.c
> > +++ b/src/nlmsg.c
> > @@ -18,15 +18,15 @@
> >   */
> >
> >  /**
> > - * nflog_nlmsg_put_header - reserve and prepare room for nflog Netlink header
> > - * \param buf memory already allocated to store the Netlink header
> > - * \param type message type one of the enum nfulnl_msg_types
> > - * \param family protocol family to be an object of
> > - * \param qnum queue number to be an object of
> > + * nflog_nlmsg_put_header - convert memory buffer into an nflog Netlink header
>
> this is not just converting as in a cast, I understand "reserve and
> prepare room" might not be so clear to understand.

v2 substitutes populate ... with for convert ... into.
>
> > + * \param buf pointer to memory buffer
> > + * \param type either NFULNL_MSG_PACKET or NFULNL_MSG_CONFIG
>
> I'd keep above a reference to 'enum nfulnl_msg_types'.

v2 appends enum to line. I thought with only 2 enum members one might as well
say what they are so man page user can highlight and paste into code. enum
definition has comments in case member names are not self-explanatory, but man
page user would likely only ever go there once.
>
> > + * \param family protocol family
> > + * \param qnum queue number
>
> I remember you posted a patch to rename qh to gh, from queue handler
> to group handler. You could rename this to 'group number'.

Done in v2. (2 other files involved - hope that's OK with you).
>
> >   *
> > - * This function creates Netlink header in the memory buffer passed
> > - * as parameter that will send to nfnetlink log. This function
> > - * returns a pointer to the Netlink header structure.
> > + * Creates a Netlink header in _buf_ followed by
> > + * a log\-subsystem\-specific extra header.
>
> This function is adding the netlink + nfnetlink headers to the buffer
> as well as setting up the header fields accordingly.

v2 re-words
>
> > + * \return pointer to created Netlink header structure
> >   */
> >  struct nlmsghdr *
> >  nflog_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t qnum)

Cheers ... Duncan.
