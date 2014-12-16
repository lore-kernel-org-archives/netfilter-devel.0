From: Yaron Galula <ygalula@gmail.com>
Subject: Hook on non standard protocol families
Date: Tue, 16 Dec 2014 10:13:52 +0200
Message-ID: <CAHL=LFCW6aTm-qBm6T17p7eXAkYDNJcmXA+dG0kuK+-ry5RCPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:54591 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaLPINx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:13:53 -0500
Received: by mail-lb0-f182.google.com with SMTP id f15so11552348lbj.13
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2014 00:13:52 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'd like to try and hook some non standard protocol families, such as
PF_CAN for example.

Is that possible?

I have tried using nf_register_hook() with NFPROTO_UNSPEC hoping it
will act as a wildcard, but the module I have built and loaded does
not seem to be in use (it does work when I replace NFPROTO_UNSPEC with
PF_INET).

I would really appreciate your help in making this work.

Thanks!
Yaron
