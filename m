Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BAA9C7EE24
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 07:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjFEHkS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 03:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjFEHkB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 03:40:01 -0400
X-Greylist: delayed 536 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Jun 2023 00:39:57 PDT
Received: from mail.paretdee.com (mail.paretdee.com [141.95.17.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DC2AD
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 00:39:57 -0700 (PDT)
Received: by mail.paretdee.com (Postfix, from userid 1002)
        id 110DFA21CE; Mon,  5 Jun 2023 07:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=paretdee.com; s=mail;
        t=1685950257; bh=YtPWhpqttWkror/OXW+RT7d5qvBhyF8jxaFrqRhKfz8=;
        h=Date:From:To:Subject:From;
        b=HQEKGHlcrbCALkZFg2jaY5XElpIcYAdN0cCAM65MI8jPQDcq5Fdlj/pS/n4exiqFW
         tXZ84NZsnpTd6vslnErUXPthpu5eAje6egEBbhyLyDsCDBCBqskq60GvbR1PaxK3Rx
         pH1tAxiiQQDw7Yi42eU2GwsiS99P0yNkck6yJ/idVEdcTzWqVfRb76LMK6zi+NB2a5
         dsTCal+pBp5enT4wYqpi9PflJpqEgF1ruQa7JEZHtZAPK85RRvIFVBX+reuJiRZEEl
         DMs+IenY2l8D7OFvGm3tiixn9b32F+BoSbAKVnqNY8xpkrGIHUYUhaVmzUsXlMiGhm
         JjUuPHDh8RqSQ==
Received: by paretdee.com for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 07:30:43 GMT
Message-ID: <20230605064520-0.1.6h.d8f7.0.kur7zemapd@paretdee.com>
Date:   Mon,  5 Jun 2023 07:30:43 GMT
From:   "Leos Sladek" <leos.sladek@paretdee.com>
To:     <netfilter-devel@vger.kernel.org>
Subject: =?UTF-8?Q?Fotovoltaick=C3=A9_rozvodnice?=
X-Mailer: mail.paretdee.com
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dobr=C3=BD den,

obrac=C3=ADm se na V=C3=A1s jm=C3=A9nem dlouholet=C3=A9ho v=C3=BDrobce fo=
tovoltaick=C3=BDch rozvodnic ur=C4=8Den=C3=BDch pro
soukrom=C3=A9 i pr=C5=AFmyslov=C3=A9 pou=C5=BEit=C3=AD.

Dod=C3=A1v=C3=A1me fotovoltaick=C3=A9 rozvodnice na zak=C3=A1zku a jsme s=
chopni realizovat i ty nejn=C3=A1ro=C4=8Dn=C4=9Bj=C5=A1=C3=AD
po=C5=BEadavky instala=C4=8Dn=C3=ADch firem, velkoobchod=C5=AF a distribu=
tor=C5=AF.

Vyu=C5=BE=C3=ADv=C3=A1me nejkvalitn=C4=9Bj=C5=A1=C3=AD komponenty a mater=
i=C3=A1ly, =C4=8D=C3=ADm=C5=BE dosahujeme vy=C5=A1=C5=A1=C3=AD odolnost, =
stabilitu
provozu a ochranu proti vod=C4=9B, vlku, prachu a n=C3=A1raz=C5=AFm.

V na=C5=A1em sortimentu jsou tak=C3=A9 omezova=C4=8De p=C5=99ep=C4=9Bt=C3=
=AD AC/DC, kter=C3=A9 zaji=C5=A1=C5=A5uj=C3=AD ochranu
fotovoltaick=C3=BDch nap=C3=A1jec=C3=ADch instalac=C3=AD p=C5=99ed negati=
vn=C3=ADmi efekty p=C5=99ep=C4=9Bt=C3=AD a chr=C3=A1n=C3=AD za=C5=99=C3=AD=
zen=C3=AD p=C5=99ed
efekty p=C5=AFsoben=C3=AD p=C5=99ep=C4=9Bt=C3=AD a bleskov=C3=BDch proud=C5=
=AF.

Chcete si vyzkou=C5=A1et na=C5=A1e =C5=99e=C5=A1en=C3=AD?


S pozdravem
Leos Sladek
