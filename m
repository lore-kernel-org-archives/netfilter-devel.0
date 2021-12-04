Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAA8C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Dec 2021 07:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354846AbhLDHtO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Dec 2021 02:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243286AbhLDHtO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Dec 2021 02:49:14 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2014EC061751;
        Fri,  3 Dec 2021 23:45:49 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id u17so3640749plg.9;
        Fri, 03 Dec 2021 23:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=WzYbQixtEx0KS/ZlBu83PT1ZVIAaCCusOpVsAtnAPp4=;
        b=XODDrs75y6Mt1shO8VbPrsuiMWdQfGi58SsoDAoSoKh1v61969XcmnTCzIXl7Li8wy
         k09QRbzqqyBy7joRE/+ngQ7Mfj3TKCBjHSythyTeimVbF/j1/nosPQbAAmRfIF078Yy8
         4jwu2iG08+EQRFIgOcunEFLXGZWDzQi+Fi2BkFF0097OKcG0dGRBzSt6Y9ZtIkLZP6IW
         gQRYdrnYthF0tPyTU1+QXViC8Pq0JRDUoyqJkxBKUpYZIMrqxbZn51PYm0904CyJtnvs
         w+6vU1zgQ2zqppvliRWbV0ScAUjvtlzjeuVKX/DXQExE4CUsYSEv58Ieu+SFeR9I+txF
         diFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=WzYbQixtEx0KS/ZlBu83PT1ZVIAaCCusOpVsAtnAPp4=;
        b=jqb9DuaH5KMw0vyLGDmvSt0/VQYcBzfLFuA3lU8Ph+tLUSE6zLJNEg2BpSQQBsRH4T
         bB3FIBZxC4nzXj86CJs6nunZDwXetbvIsT8ftRCQujAXGBRWki0fn6HIL94clieCDjjO
         1kFaEhDYAKIb9T+WyIkM/nfqAjy+rj0965DnhYQ+ir2xVj4l4e4aWOZXmRNL/Cezzr2w
         KEuiXAYDeiFPqvayc555th9CXMv1xyGAwjfhAujSOiu4aNelKLxKOFJtr5zL5T79aDzA
         LSC1PuKmVNgRoiCS1pq/Ti3XI/42Wd8urkXf/qF8D9t3c2WMhLu816Qmpncryby0hd/z
         XM+w==
X-Gm-Message-State: AOAM5326fyl7JoEybuBMH3p1Mqx3xtdgKsnxh3n9BqDbL+n3Y3Omz2Gt
        Qxll/Bh1JXWsY4CEia6Ed9GLyO7Ok1k=
X-Google-Smtp-Source: ABdhPJxSJ8qOlX37SarlC2oo19qho3uetLjPGfSJHqdZhONOhufcRYjBhl4wtOSu9N/PDjHvcQCcuw==
X-Received: by 2002:a17:90a:e40f:: with SMTP id hv15mr19990557pjb.5.1638603948348;
        Fri, 03 Dec 2021 23:45:48 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id l1sm7051466pjh.28.2021.12.03.23.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 23:45:47 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sat, 4 Dec 2021 18:45:43 +1100
To:     netfilter@vger.kernel.org
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Meaning of "." (dot) in netfilter
Message-ID: <YascpztWuzJgKRgq@slk1.local.net>
Mail-Followup-To: netfilter@vger.kernel.org,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <CAK3NTRAQE7UD9_0EuzyS0UGQ_s++Dg_hbZPXscHBrStnGJHGjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK3NTRAQE7UD9_0EuzyS0UGQ_s++Dg_hbZPXscHBrStnGJHGjw@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Ross,

On Fri, Dec 03, 2021 at 10:33:55PM -0800, Ross Boylan wrote:
> https://wiki.nftables.org/wiki-nftables/index.php/Simple_ruleset_for_a_home_router
> include a number of rules like
>
>         ip protocol . th dport vmap { tcp . 22 : accept, udp . 53 :
> accept, tcp . 53 : accept, udp . 67 : accept}
> with possibly 2 different uses of ".", namely 'ip protocol .'  and 'udp . 67'.
> What do those "."'s mean?
>
> I've looked in available documentation, but can't tell.
>
> Thanks.
> Ross Boylan

"." is the symbol for concatenation. It's been missing from the man page
forever.

I was going to submit a patch to add "." but wasn't really sure when you could
use it so I never did.

The rule defines a Verdict Map (vmap) whose elements are a concatenation of ip
protocol and Transport Header (th) Destination Port (dport). Accept tcp.ssh,
udp.domain, tcp.domain and udp.bootps (udp & tcp are IP protocols).

Post back if I didn't explain well enough.

cc: netfilter-devel in the hope someone could update the man page.

Cheers ... Duncan.
