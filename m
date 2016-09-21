From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: libnftnl XML parsing seems broken with libmxml 2.10
Date: Wed, 21 Sep 2016 14:24:16 +0200
Message-ID: <CAOkSjBij7=O59NN_szdgMWHBCZreajJ9h=wM_hcYV=QNGmZe6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38363 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753663AbcIUMbn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Sep 2016 08:31:43 -0400
Received: by mail-wm0-f51.google.com with SMTP id l132so89032864wmf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Sep 2016 05:31:42 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

just to let you know that something happened in libmxml 2.10 which
seems to break libnftnl XML parsing capabilities.

Here is a debian bug for this issue: #838370 [0].

regards

[0] https://bugs.debian.org/838370

--=20
Arturo Borrero Gonz=C3=A1lez
