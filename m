Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8619DC47071
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Nov 2023 04:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjKREMG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Nov 2023 23:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjKREMF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Nov 2023 23:12:05 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE3AD7E
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 20:12:00 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id 006d021491bc7-5842ea6f4d5so1547704eaf.2
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 20:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700280720; x=1700885520; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=inaERidEz7oV8pGDwmqIhajLVxcELiJ34CvxX2f/XWM=;
        b=iYlPK27KXj5M9U91vkWdSqyRxO/+ga+x4YMesoV8LYjBaeXR3CXjqljkL/MEdGpoDY
         tHLXmNV/u14KofMGfM1duQRd8Ziv4dQVhS0W9kT1w0fEAfeIF2Ujj0j85Apabk5GiUJp
         2JwzS6IGgEKTgr2Vi14x+nJRqIowrradkR1iOJ1vak64Qr77Fdi1v9qEuz8PCgfd+VbJ
         3Sv9+d5Vhh4dGpKVssDQMxQ83bj6CocASeNxcpIe2MzDqlhdzgRQOzESaV/UEHJTunH9
         mbB55uHi8Lv0HjtH9QFhN+3IjfdTtn2b08VfsoMkapI5t/0hFOnDmx9LEdiNXWJgXWkH
         Y8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700280720; x=1700885520;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=inaERidEz7oV8pGDwmqIhajLVxcELiJ34CvxX2f/XWM=;
        b=jR5/ggfYpd0BcSYARDtxscIj9bX2hEHL0oN5zOyt/9RPLa8Fs4WerwmycEChFg/aT8
         yiLWSxLreUe7oadoe5omVdBmNl0n8iSG4AFizjLRyA8ukP7qLRFy75Ur3ZrTWcuXbVsM
         wohxnzZR0DbQjelyYRDs8UYBRAZGRIFr0c0rcBjTc0zqJrFbWjNrNRk+10mCKeirCL9a
         PNDASLvh9dBnDkx4Df+vKP4RsQGBxhyttLeE4+Re2VRHSDKSQkvCmwuo+0e5j2psprNG
         dxW0gEZIQppbgx8/KCEYrBR+NdCrXjcxjbfBnOZMfC0F+VxHiCzV1F+6UQwAQAI+xwO1
         pxmw==
X-Gm-Message-State: AOJu0YzmJ4rjNt89p5OsLgPE3+ECVjf2W6J1/Dx1nR6PxBbZWzjC0GVp
        /FQhyr8EmvUZ2FgqIDaHJnyagpS2ED8=
X-Google-Smtp-Source: AGHT+IEeamOrTe+KdeRmxRAF4Bagfw7v61HRj4WFyHQgKAmzNzNGS9Zw/vnk337Pb/CYZpAFvaHTuQ==
X-Received: by 2002:a05:6358:7f0d:b0:16b:c64b:5dad with SMTP id p13-20020a0563587f0d00b0016bc64b5dadmr2008440rwn.10.1700280719918;
        Fri, 17 Nov 2023 20:11:59 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id z10-20020a630a4a000000b005bdbe9a597fsm2184976pgk.57.2023.11.17.20.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 20:11:59 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Sat, 18 Nov 2023 15:11:56 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1/1] src: Add nfq_nlmsg_put2() -
 user specifies header flags
Message-ID: <ZVg5jArFjdXUuzPN@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <ZVSkE1fzi68CN+uo@calendula>
 <20231115113011.6620-1-duncan_roe@optusnet.com.au>
 <ZVSuTwfVBEsCcthA@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVSuTwfVBEsCcthA@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Can we please sort out just what you want before I send nfq_nlmsg_put2 v4?

And, where applicable, would you like the same changes made to nfq_nlmsg_put?

On Wed, Nov 15, 2023 at 12:41:03PM +0100, Pablo Neira Ayuso wrote:
> [...]
> > + * nfq_nlmsg_put2 - Convert memory buffer into a Netlink buffer with
> > + * user-specified flags
>
> This is setting up a netlink header in the memory buffer.
propose
> > + * nfq_nlmsg_put2 - Set up a netlink header with user-specified flags
> > + *                  in a memory buffer
> [...]
> > + * \param flags additional (to NLM_F_REQUEST) flags to put in message header,
> > + *              commonly NLM_F_ACK
>
> remove NLM_F_REQUEST here.
propose
> > + * \param flags flags to put in message header, commonly NLM_F_ACK
> [...]
> > + * \returns Pointer to netlink message
>
>                Pointer to netlink header
propose
> > + * \returns Pointer to netlink header
> [...]
> > + * Use NLM_F_ACK before performing an action that might fail, e.g.
>
> Failures are always reported.
>
> if you set NLM_F_ACK, then you always get an acknowledgment from the
> kernel, either 0 to report success or negative to report failure.
>
> if you do not set NLM_F_ACK, then only failures are reported by the
> kernel.
>
> > + * attempt to configure NFQA_CFG_F_SECCTX on a system not runnine SELinux.
> > + * \n
> > + * NLM_F_ACK instructs the kernel to send a message in response
> > + * to a successful command.
>
> As I said above, this is not accurate.
> > + * The kernel always sends a message in response to a failed command.
I dispute that my description was inaccurate, but admit it could be clearer,
maybe if I change the order and elaborate a bit.
propose
> > + * The kernel always sends a message in response to a failed command.
> > + * NLM_F_ACK instructs the kernel to also send a message in response
> > + * to a successful command. This ensures a following read() will not block.
> [...]

Cheers ... Duncan.
