Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244D1C2D0D1
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 08:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E18192072E
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 08:50:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TnoaI8gc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfL3Iu6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 03:50:58 -0500
Received: from mail-io1-f50.google.com ([209.85.166.50]:43491 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbfL3Iu6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 03:50:58 -0500
Received: by mail-io1-f50.google.com with SMTP id n21so29278367ioo.10
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 00:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=OT6a5Pch4kpMLj64XwWFi7oE8Kijsix1HaCNaD7iap8=;
        b=TnoaI8gc/IkqyWl+/bur1QgUq9O+kTeHCqcGu0eVN7KilID6AtgaRbuqK5u14Tzgmu
         mpH9DauI1jq2va7OOg0c1132gLG0J1UV+hbwxsBNSThVhCwtrclmd+8/VqmFQs1QrLH1
         toizh/DokrpsjGxPGJ3hdGcbQqqNzRi7KNSDfSf5DJstvLbCVbf6ASIMiEPdyGtTPdH8
         O91f2q+mrKH6l9J6CdLuD4IAMaIoMd/UW3IeiIhOkZVPb0Ds9UMNS3fPoFfFg9FL3b6/
         0/TICkbAxFxUTuGZPG8iXGUt/UiWSTiXTfPP6ig/xJCmNvFEnFX7C/xWtrZkCYFbTsqW
         hWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OT6a5Pch4kpMLj64XwWFi7oE8Kijsix1HaCNaD7iap8=;
        b=rW4en+LnDG3wVNgndcCIms/W3c4EQ91p09C462vTNVi5G03/cL6XPkpMHFBhA8O4Ek
         pnWRg35YLtDXHqeSQWqvwwfnEDRhof5WBCMJY8dpbrEHXu+FxMjBhLkG7T6BWdzGa7kK
         zstlpCwKUT/4+FsIZyhhTtQNL4aIyAxxvdW8dnrlQpBeYscnHkELfV0W/RNwfPLnGF8o
         gFSmBLj1kxvX0E3zYUNRVMBak3UsflBq2jVKEVW/hHLsjLlrKMSto4UeutlgmM1zD4je
         LF+pDD2N8ilwDTut2ZzZ/YNmtSBGyp0zu/a+XmHhE1ZKAnfeUhvBbD2phl3azSId2aeT
         GTgA==
X-Gm-Message-State: APjAAAWekh1T+REiVyI60ZpAeQfuMv80LdN4GIHqcif/iSguY8yfi7IY
        iAN5DYULF21tnRscfcQN8FPZHrLDHeatqJ6hu7FpqA==
X-Google-Smtp-Source: APXvYqyB+6gq4iyvWj/pzjikjFGO7E+/+4hQCADHyZHjEGDfFHOGeKWLehJc+X4rnED+dhVgLxe84v24mExOJrzJtBs=
X-Received: by 2002:a5d:8782:: with SMTP id f2mr34761235ion.53.1577695857259;
 Mon, 30 Dec 2019 00:50:57 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac0:aafc:0:0:0:0:0 with HTTP; Mon, 30 Dec 2019 00:50:56
 -0800 (PST)
From:   JH <jupiter.hce@gmail.com>
Date:   Mon, 30 Dec 2019 19:50:56 +1100
Message-ID: <CAA=hcWTJWi3wcWez-adCE4NvzVbbeWSpwSNCz9cebnSDnGPtcQ@mail.gmail.com>
Subject: Calling mnl_socket_sendto caused error of netlink attribute type 1
 has an invalid length
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I have following error of attribute type 1 has an invalid length when
calling following mnl_socket_sendto(channel->mnlSocket, nlh,
nlh->nlmsg_len), I cannot see what was wrong about it, the
nlh->nlmsg_len = 40 which is from libnml, is that wrong? Please advise
how to fix it.

[ 3240.939609] netlink: 'wifi_signal': attribute type 1 has an invalid
length. I have a WiFi function using nml API:

typedef struct {
        struct mnl_socket *mnlSocket;
        char buf[BUFFER_SIZE];
        uint16_t channelId;
        uint32_t interfaceIndex;
        uint32_t sequence;
        void *context;
} __attribute__ ((packed)) Netlink80211Channel_t;

void WiFiScan::Send80211Message(struct nlmsghdr *nlh,
Netlink80211Channel_t *channel) {
    if (mnl_socket_sendto(channel->mnlSocket, nlh, nlh->nlmsg_len) < 0) {
         std::cout << "Failed to send socket" << std::endl;
    }
}

Thank you.

- jh
