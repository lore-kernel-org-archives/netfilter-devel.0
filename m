From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft] Using variable sized data types in concat expressions
Date: Wed, 7 Sep 2016 11:20:59 +0200
Message-ID: <CAOkSjBgWckUug_7yGqMpVrq2u3bP+o5v_7zTYDD4jL=YerpA7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36598 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751212AbcIGJVV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 05:21:21 -0400
Received: by mail-wm0-f42.google.com with SMTP id b187so105159610wme.1
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Sep 2016 02:21:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

It would be great it this were supported:

 iifname . oifname vmap { eth1 . eth0 : jump chain1, eth2 . eth0 : jump cha=
in2 }

Error: can not use variable sized data types (string) in concat expressions

Why iifname rather than iifindex?

I would like to test/deploy my ruleset in machines which doesn't have
(yet) all the interfaces.

Why concat?

I would like to map every possible network direction to a custom
chain. (dmz->inet, inet->dmz, et al) using a single rule.

--=20
Arturo Borrero Gonz=C3=A1lez
