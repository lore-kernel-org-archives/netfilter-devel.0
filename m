Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6F2C43334
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jun 2022 10:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiFIKnF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jun 2022 06:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbiFIKnF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jun 2022 06:43:05 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F3B1AA177
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jun 2022 03:43:03 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id u23so37355461lfc.1
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2022 03:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=koGb0MBlbBVE37T844y20HE32Byp30OQI/NXD9+cy0A=;
        b=X3imRqWhjcRnVumZpsjb1iiy7Aei1k+pqyoziATQrq6115MLrUVmneEkEWrv49fJ4e
         6QzvHL6+GFOyD0rtl47D7RpKYpAgpzTYGbR9+wC1opyer2rcBhvl7ov7hJpUJq8SXyRH
         lAjdTxyrn+rmVM6LgJUPzeI5gNwGGPfr9CEAqrjlpUqYLoFLN1NEJ+ucWAty93ZEW9Je
         V8YphCxdVOxI1fcUuedlb567mE0E+Dy7WA5ZruvJ24h9E4nw0rEr/dhKwF5cSjafcJ/6
         Pgtn3hdvhusDkSvlWolPzYgUmx0DwNZ67+wB/oXbcoMS8QM2oZEc15+J8g5vym7ADizL
         wVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=koGb0MBlbBVE37T844y20HE32Byp30OQI/NXD9+cy0A=;
        b=BMmKk4iYqR3u3UBz6CsmsCVHmPE+1E6ownGeuQrk0/agegLsY7IqKPtNCioR9FOj5Q
         XlQYxdRnkRwjVEi4RmmAiaYrFQY1pAH2euquf/s0wvVZzbXvdK9NhXnRBD53vp3HENkb
         bjLh0lMZWmmJtr//x9O04eHEltsUhmP5eW1zqaHxQ7SKhNOwxepMry5/mt9eD7bXTg36
         0bHuBujMZuuLi6K/Gq/O6Odi5974w08QaHFOWYu8nPluWU1BPF3+vFApThamIWAMOMuW
         yP+H6wAgLpfWqiVxeHXesHJsTB825qe6yNpoVjdL4NFwoYaSkpurDBXFUJw3PL/f+kWH
         wmsw==
X-Gm-Message-State: AOAM531uHoVGoANM8WtfhtMUWBIX7UeBAgP5ZGUQ7w5cl7ZXytiX8cZu
        EPLoWjMrtG34WUfvcZhDPCzB23Mm9L5Nr5BhHzRISA==
X-Google-Smtp-Source: ABdhPJyRqlWcmqZocQFbTqEUiBtvmgYj0yHEwbHXYxkElAjfzsibvTguRhaC62pYBT+5RoppidyEhkqJIfypwVOWpg8=
X-Received: by 2002:a05:6512:c23:b0:479:3233:e377 with SMTP id
 z35-20020a0565120c2300b004793233e377mr14749474lfu.684.1654771381729; Thu, 09
 Jun 2022 03:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220602163429.52490-1-mikhail.sennikovskii@ionos.com>
 <20220602163429.52490-2-mikhail.sennikovskii@ionos.com> <YqA/RNP5jQzIRpon@salvia>
 <CALHVEJZbcASEfTn4Qc0uAf6PpHLZZb_wHgfmMsjdEkaLSRHyQA@mail.gmail.com>
 <YqCDSFZkF9v+Ki8j@salvia> <YqCFrd8SDwnHr+rE@salvia> <CALHVEJZ1X+yige_5=daMGfjPcFjQeFmeb2RCDW1=_hSk7eR+wA@mail.gmail.com>
 <YqHJhO6K15gzqLnV@salvia>
In-Reply-To: <YqHJhO6K15gzqLnV@salvia>
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Date:   Thu, 9 Jun 2022 12:42:50 +0200
Message-ID: <CALHVEJbUpxPJ0fSfcyynEkfiTrnvSR_zfrkLPm_0iiOBMr+Tog@mail.gmail.com>
Subject: Re: [PATCH 1/1] conntrack: use same modifier socket for bulk ops
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sure, let me remove it then and submit an updated patch here.

Thanks,
Mikhail

On Thu, 9 Jun 2022 at 12:20, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi,
>
> On Wed, Jun 08, 2022 at 04:16:34PM +0200, Mikhail Sennikovsky wrote:
> > Hi Pablo,
> >
> > Then I misunderstood you, my bad.
> > Yes, _check is never used for events, and the socket->events is not
> > used anywhere except the assert(events == socket->events); assertion
> > check which I found useful as a sanity check for potential future uses
> > of the nfct_mnl_socket_check_open.
> > If you find it unneeded however, I'm fine with removing it.
>
> If not used now for this usecase, I'd prefer if you remove it.
