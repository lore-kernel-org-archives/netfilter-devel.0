Return-Path: <SRS0=nkBT=2X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F8BC2D0DD
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jan 2020 07:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3402120866
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jan 2020 07:59:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sU6J0iuL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgABH7U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Jan 2020 02:59:20 -0500
Received: from mail-io1-f43.google.com ([209.85.166.43]:32779 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbgABH7T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Jan 2020 02:59:19 -0500
Received: by mail-io1-f43.google.com with SMTP id z8so37540638ioh.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Jan 2020 23:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to;
        bh=zXMuqrvbhbxwRTvY95+4b7nlNH7cvYlKrUWsZhjSUuI=;
        b=sU6J0iuLyI5z6K/J66tw1xinRrhYmnsUC9V+lToSHwJ85MpNfFyMtxY/tlXGC2xVbm
         K3r+m/BGDrD4DbGk19MnI1eBA82EjaxZq4VxxoYzKh+pZVEPD6xiZmZwxxnqmIU2XONp
         h91dFnAoiNBvxy7+nysxY3pnL0EBEb4Sh+axkNr0GaJj4frVnLxaIhZJlBccoUwGNzj/
         gWmH69BkXc19byaafINpp6aNe9DS1dKLkJlNrv4WCrOj+9Bp5sm5MdJvQ+OjcL/jCjHY
         HNmlOvLM7jQAEj/Sxth9EqBZm1lxnJDxDn1IEMZRqFGgUNsww6vRJf6HdcU3qwlV9BZb
         2ANg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to;
        bh=zXMuqrvbhbxwRTvY95+4b7nlNH7cvYlKrUWsZhjSUuI=;
        b=NdWf4eqsIdhRH8XjOGH0lVCCUtrAY51sJ1LvCXJ0F4x1k1yRRoh7LNAiSzOJ5J+B/u
         YCuKa0/seA/8yUprEVFHI1HB9VpfRIr7pT5f+YyipqBrxOh+hm4ccbFOmTWEXwUv2r7Z
         4R6pcr40Dl/r8qO+R7g5OeD9mR0G5NQ+Wbecw0HKDSQytUL7ZpPJlNsqUmrxqOOs6XT9
         ppvDI4m30jmrvN2IMNqun+s2ZkwbcrV2EAjW3Vb1p5GLedDMxs+mCm/uwgeHAYlR4rWD
         zN2YiXb2hTb/Gn8IMJBUvR1fSTKmKacOsE9ZKBgZIOzmR1vxHZvMnhuKGC7Xo5aMmWbe
         TtyQ==
X-Gm-Message-State: APjAAAUmGKUUDIE0+9OIxg/GlH+7dyXUiTZLVF2K0pSMNpb2K2/eGulG
        2zLfhPkWxleyhdpIB1DVpTjFNvMDmMa/LtatAYQ=
X-Google-Smtp-Source: APXvYqxIcHUMIDXlwuLnmkdyKdARHQUiFHRKgDpwmqW0et9Ba/vjQpQynb1SBbBTeWgFIpKMahOPCHHUSfj0bHxxNqw=
X-Received: by 2002:a02:cd31:: with SMTP id h17mr60656172jaq.94.1577951958895;
 Wed, 01 Jan 2020 23:59:18 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac0:aafc:0:0:0:0:0 with HTTP; Wed, 1 Jan 2020 23:59:18 -0800 (PST)
In-Reply-To: <20191231003259.GA1179@dimstar.local.net>
References: <CAA=hcWTJWi3wcWez-adCE4NvzVbbeWSpwSNCz9cebnSDnGPtcQ@mail.gmail.com>
 <20191231003259.GA1179@dimstar.local.net>
From:   JH <jupiter.hce@gmail.com>
Date:   Thu, 2 Jan 2020 18:59:18 +1100
Message-ID: <CAA=hcWRrCDHqu_vGVds==9Rzve_LUxJ0XRcB=k1fmZr9w-DoOg@mail.gmail.com>
Subject: Re: Calling mnl_socket_sendto caused error of netlink attribute type
 1 has an invalid length
To:     JH <jupiter.hce@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks Duncan, you are right, it was the wrong type and fixed.

Thank you and appreciate your helps.

Cheers.

- jh

On 12/31/19, Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> On Mon, Dec 30, 2019 at 07:50:56PM +1100, JH wrote:
>> Hi,
>>
>> I have following error of attribute type 1 has an invalid length when
>> calling following mnl_socket_sendto(channel->mnlSocket, nlh,
>> nlh->nlmsg_len), I cannot see what was wrong about it, the
>> nlh->nlmsg_len = 40 which is from libnml, is that wrong? Please advise
>> how to fix it.
>>
>> [ 3240.939609] netlink: 'wifi_signal': attribute type 1 has an invalid
>> length. I have a WiFi function using nml API:
>>
>> typedef struct {
>>         struct mnl_socket *mnlSocket;
>>         char buf[BUFFER_SIZE];
>>         uint16_t channelId;
>>         uint32_t interfaceIndex;
>>         uint32_t sequence;
>>         void *context;
>> } __attribute__ ((packed)) Netlink80211Channel_t;
>>
>> void WiFiScan::Send80211Message(struct nlmsghdr *nlh,
>> Netlink80211Channel_t *channel) {
>>     if (mnl_socket_sendto(channel->mnlSocket, nlh, nlh->nlmsg_len) < 0) {
>>          std::cout << "Failed to send socket" << std::endl;
>>     }
>> }
>>
>> Thank you.
>>
>> - jh
>>
> The kernel is complaining about the content of the message, rather than the
> length. The message you send should consist of a header followed by a series
> of
> attributes. Attributes are of the form <type> <length> <data>. <type> is
> always
> uint8_t. The kernel has seen the an attribute of type 1 (NLA_U8) but the
> following lenth byte was not 1 as it should have been. Quite possibly the
> message is garbage.
>
> The error message you see is output by function validate_nla() in file
> lib/nlattr.c at line 178.
>
> To get a more helpful answer, you would need to post a lot more code. Is it
> on
> gitbub?
>
> Cheers ... Duncan.
>
