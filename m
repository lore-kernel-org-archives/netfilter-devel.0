Return-Path: <SRS0=/RxB=7D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0966BC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 May 2020 19:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C470C207D3
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 May 2020 19:27:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eu/F41Pt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbgEUT1V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 May 2020 15:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729475AbgEUT1V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 May 2020 15:27:21 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0A9C061A0E
        for <netfilter-devel@vger.kernel.org>; Thu, 21 May 2020 12:27:20 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id q2so9676413ljm.10
        for <netfilter-devel@vger.kernel.org>; Thu, 21 May 2020 12:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=4Q4GvY9u1kfbi2AFyiWbCBEPRCAYm0pprMVxN+ui5uo=;
        b=eu/F41Pt823JYD+OAUtfXlnLW0pxDltUcAB78HCEzkWuUE4g2IL+IA/fxUBkHOVBqj
         fIgfPEzIaUctYY3x897D+ondtMoZqGIjp+EaW+Eg0Oj/VMXpH3v2J4hljTuNgCX0xDMc
         zktdlwy5yvJi6nONnQoOeaHWq7hR3yLfIU8VNUApvL8UY+Km7WciMscjREIM9beHIH8o
         CH4wTgMT0OiY+auZIwpgvJfPTH1zvbwO1FPcCo0oVjbr/HxPn2FBLyip74PlHy3k/KYE
         WTt9U8pZzAQgfH1U0Q+VXVafyYqvLYzGTz6p+vzbdfVfDq4GPPOx3PvC2WgaJU8st5IP
         pRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4Q4GvY9u1kfbi2AFyiWbCBEPRCAYm0pprMVxN+ui5uo=;
        b=f76QTQaFbbYJ5E7eSCR9ugAu3hGlhAzx6YWbrDJAAyKRID2x7oqo9rAF7BiEVN/uGd
         7/IL9wPjKZZhPWyf5q4IqVdUiuqOSJKyERbB5O9yTJZROdXbqMAe1W3eKmOWljNxhBom
         5RUo0SUJ38jVbcokBYPeZGAbOT+kXatnDVBlNjq8fFqf394spJqrCEH641AlMoVNRKD+
         pNxIjMcLzlVDCR/XFF8lsX07ux4tRyDtfyTJNVICuq6rFXVEDDa1vjw6dWuNsS/BCKtQ
         jyHiX3mBUkX5LK7A/CCGPMF1kvPIPnTLQBnaV0dYvVsrGXuQIBpFI4VJfC0LVy2yC4pr
         c2mQ==
X-Gm-Message-State: AOAM532NUh6U+dAlI1mrvVDRj7KHGMXFyvHdxgUpWvl8a1NlkS16UAZb
        VBOl6cpK4CIkK3WohpmkuxLGuKTFe1DaROEKzp8qYjXce6nfYA==
X-Google-Smtp-Source: ABdhPJwvNmdWo29Ag0gVEEiU27eCH3G/gLgCMrRZHi2dA9XCGL7BEw3uBOi0Cpl7SlYyD3U4BWoYQn0w6md9/da5RYk=
X-Received: by 2002:a2e:3309:: with SMTP id d9mr3311301ljc.401.1590089238966;
 Thu, 21 May 2020 12:27:18 -0700 (PDT)
MIME-Version: 1.0
From:   Oskar Berggren <oskar.berggren@gmail.com>
Date:   Thu, 21 May 2020 21:27:01 +0200
Message-ID: <CAHOuc7OX=a0OjLpyJf3bU9sfmrd+_XbMBt+JN3w1QeKGPod0pw@mail.gmail.com>
Subject: ipset make modules_install fails to honor INSTALL_MOD_PATH
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

In build scripts for a custom environment I have since about a decade
something like this to build ipset and package the binaries:

make
make modules
DESTDIR=... make install
INSTALL_MOD_PATH=... make modules_install

It was a long time since I last updated this, but this seems to have
worked for at least one of ipset 6.11 or 6.24.

However, with ipset 7.6, despite setting INSTALL_MOD_PATH, the scripts
tries to install under the real /lib directory.

In the makefile I find this line, which seems to override whatever I
set for INSTALL_MOD_PATH:

    INSTALL_MOD_PATH = /

Oddly enough, this line was introduced by a commit titled "Support
chroot buildroots":
http://git.netfilter.org/ipset/commit/Makefile.am?id=5bad18403fa258204214d45580ca0d235e1a4486

Changing the line to the following seems to make it possible for my
script to override and get the desired relocation:

    INSTALL_MOD_PATH ?= /


Or is there a different solution I should be using?

Best regards,
Oskar
