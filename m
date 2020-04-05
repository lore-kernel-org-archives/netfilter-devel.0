Return-Path: <SRS0=tJPO=5V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FF3C2BA1B
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Apr 2020 20:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0D4B20753
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Apr 2020 20:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GGhHZrDP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgDEUOv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Apr 2020 16:14:51 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:46808 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbgDEUOv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Apr 2020 16:14:51 -0400
Received: by mail-ua1-f65.google.com with SMTP id y17so4713590uap.13
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Apr 2020 13:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5RZZPCFdrZOQUY0NpVhCKIfJRTC5bG/d80lCyOIHMvI=;
        b=GGhHZrDPPbkuzuguWgms3SM2M2r0UKmzXGPaAggqc+tXUrrldJO9EKkeDqA8Xq4f4M
         n6SE42S3xLoU8IYHjcxnJtJcsXwJqwpf4FnHHnJA/3G79TzB+hKrLF8lGCWgNKfmK/6N
         vhyhilkBjED6nXY3rv8nCdf+t8Q4Mtk49+hKNmdfXoRTbLcnzpfXqLsrlKHI2ZGUQr0u
         Mwirm4hw3GYZLAmtCJSijBMF5SHXE20JO7gBJOKiVHx/Sr4WC+QxTNifGHPrxfRyOJlM
         OuKbZiiLA+LY/YyfGaJ+raq8FpX55yIvJriPPGMyfrMd6Ry+LufuOqNzNaVcLvQZrx9w
         92MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5RZZPCFdrZOQUY0NpVhCKIfJRTC5bG/d80lCyOIHMvI=;
        b=V28VZThkWb9bTbHlf+r7wfe5PEQXkC26OM/kzfdGyXuDbXILo7eQB8GhojsEn5eOr+
         BnLKmYKcffh0YBoimHlwdf1WU6RyhZ5PUKrMbBfpktMox25GeubJpQPee4g1LVNHps2f
         pP4ccqY5FRRHuXFgForedg2a50VmrOgwkoGmhnKKeXtKAPfsZA0FKyr8cjUluqMZprhx
         h5xDA9PamYFEmfRiAsYE+NcwM6M5doiKqWZTi8rcnXHeQYIET4sE+v0pqRw+Qlg1PWDk
         3Dsh6nwFXsNuzqeZqI+0LtEwgGTuV1t0cPiHg+/n56T8vrhiSj8+3sEZbT6cLqkNYuBW
         i+fw==
X-Gm-Message-State: AGi0Pua9u7DChFZ07jJWF4VRb7R3ylQQMLZiRlgvzVLKahGasPuMB1g2
        981wNnpsZrSI0k49CqKgzeOp2ZYE2VXDrYdNDeYOCw==
X-Google-Smtp-Source: APiQypK5FH36bz+ECXHur6NM82rZjixh9mlkCGmXkvklZL2waKqFuFQoW77uZcqw/ZVBnmI0yqkHaVY/mKm0ENokkPE=
X-Received: by 2002:ab0:6185:: with SMTP id h5mr13446724uan.23.1586117689615;
 Sun, 05 Apr 2020 13:14:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200331163559.132240-1-zenczykowski@gmail.com> <20200405200522.5pcxitjcnxss4e7r@salvia>
In-Reply-To: <20200405200522.5pcxitjcnxss4e7r@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sun, 5 Apr 2020 13:14:39 -0700
Message-ID: <CANP3RGczLdp831hQvxAPp_RPdf=A75zKoEEkFE+QGcw0sPy62w@mail.gmail.com>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Jan Engelhardt <jengelh@inai.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> Hi Maciej,
>
> I'm attaching a new version, including EOPNOTSUPP if the send_nl_msg
> field is set, it's the most basic handling I can think of until this
> option becomes useful.
>
> Would you commit to send a patch for this new merge window to make it
> useful?

Yes, I can do that.

Thank you.

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>
