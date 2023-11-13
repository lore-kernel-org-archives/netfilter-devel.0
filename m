Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81958C4167D
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 20:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjKMUNb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 15:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjKMUNa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 15:13:30 -0500
X-Greylist: delayed 239 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Nov 2023 12:13:27 PST
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1781EF5
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 12:13:27 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 84B4CCC02CD;
        Mon, 13 Nov 2023 21:13:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
        :from:from:received:received:received; s=20151130; t=1699906403;
         x=1701720804; bh=a2zI8zOrvq3GyCPJ54oh2sYGzNuU0CoYr/UK/9t3cAY=; b=
        A2yjiFar7XJ4qN7b5Go7fua52C8RS6SEZQDYLbE2SgW4MJDJIC3xEw48E+8mz5HJ
        tSSbADbm3Of0owf8RjcEzKknwE62JUSZP60P5JikP3G/7CkUPehbU8691IyOwvlZ
        CNVm/ef1gta6Hn6QRzBbn03OWOb+WDQ60vB6BRca3oQ=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 13 Nov 2023 21:13:23 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 54508CC02CC;
        Mon, 13 Nov 2023 21:13:23 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 13AD93431A9; Mon, 13 Nov 2023 21:13:23 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Linkui Xiao <xiaolinkui@kylinos.cn>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/1] ipset patch to fix race condition between swap/destroy and add/del/test, v3
Date:   Mon, 13 Nov 2023 21:13:22 +0100
Message-Id: <20231113201323.1747378-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

[Resend: sorry, patch subject was not updated properly.]

Please apply the next patch to your nf tree, which fixes a race condition=
:

* There's a race between a fast swap/destroy and a slow kernel side add/d=
el/test element
  operation in ipset. The attached patch fixes it by forcing ip_set_swap(=
) to wait for
  all readers to finish accessing the old set pointers.
  v2: synchronize_rcu() is moved into ip_set_swap() in order not to burde=
n
      ip_set_destroy() unnecessarily when all sets are destroyed.
  v3: Florian Westphal pointed out that all netfilter hooks run with rcu_=
read_lock() held
      and em_ipset.c wraps the entire ip_set_test() in rcu read lock/unlo=
ck pair
      So there's no need to extend the rcu read locked area in ipset itse

Thanks!
Jozsef

The following changes since commit 7153a404fb70d21097af3169354e1e5fda3fbb=
02:

  Merge tag 'nf-23-09-06' of https://git.kernel.org/pub/scm/linux/kernel/=
git/netfilter/nf (2023-09-07 11:47:15 +0200)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf 2c9d59f0074ade

for you to fetch changes up to 2c9d59f0074ade26f2324209383d3699ad1790be:

  netfilter: ipset: fix race condition between swap/destroy and kernel si=
de add/del/test, v3 (2023-11-13 21:10:42 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: fix race condition between swap/destroy and kerne=
l side add/del/test, v3

 net/netfilter/ipset/ip_set_core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)
