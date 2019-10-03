Return-Path: <SRS0=hHnn=X4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1E3ECE596
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 285D02133F
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="abiFCtJY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387919AbfJCT4N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 15:56:13 -0400
Received: from kadath.azazel.net ([81.187.231.250]:51174 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732358AbfJCT4L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 15:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HOkc+OL7jjzZMQPc4SIE4Q97cZxU7vHFloZWkyrPhn8=; b=abiFCtJY0AfQ+9A5C6sKIt5EU9
        y8eUI23U0KHbWG422Mbm5vIaZ74eRaNptySbLaxrVN3bwKIl35JI9gQG4TjPHOqwpNKQJkNz6Egb5
        S9Px8205VKnNvur1DzR5/qfjZaKJXgwezsFiUSoFnaoNX5dqm+GRnXBpuyTWz52YbxBCoJ58PPawy
        AcR5K7ueeU8iJGmswPHUluazGscfaZhFSl0kwk5kIkirCpiCWundfRqBAQRdeJPMHBlFzrRabhjZ2
        ktlkq+hI+TpjKrRa3zQzzdKyHfCK+h1jjmrd773wKTc5CqAtxC/eZt5jYqXD6QqApx1heohysIT9H
        AbPie2aw==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iG7Cp-0004KM-Nq; Thu, 03 Oct 2019 20:56:07 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 0/7] ipset: remove static inline functions
Date:   Thu,  3 Oct 2019 20:56:00 +0100
Message-Id: <20191003195607.13180-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In his feedback on an earlier patch series [0], Pablo suggested reducing
the number of ipset static inline functions.

0 - https://lore.kernel.org/netfilter-devel/20190808112355.w3ax3twuf6b7pwc7@salvia/

This series:

  * removes inline from static functions in .c files;
  * moves some static functions out of headers and removes inline from
    them if they are only called from one .c file,
  * moves some static functions out of headers, removes inline from them
    and makes them extern if they are too big.

The changes reduced the size of the ipset modules by c. 13kB, when
compiled with GCC 9 on x86-64.

Jeremy Sowden (7):
  netfilter: ipset: add a coding-style fix to ip_set_ext_destroy.
  netfilter: ipset: remove inline from static functions in .c files.
  netfilter: ipset: move ip_set_comment functions from ip_set.h to
    ip_set_core.c.
  netfilter: ipset: move functions to ip_set_core.c.
  netfilter: ipset: make ip_set_put_flags extern.
  netfilter: ipset: move function to ip_set_bitmap_ip.c.
  netfilter: ipset: move ip_set_get_ip_port() to ip_set_bitmap_port.c.

 include/linux/netfilter/ipset/ip_set.h        | 196 +---------------
 include/linux/netfilter/ipset/ip_set_bitmap.h |  14 --
 .../linux/netfilter/ipset/ip_set_getport.h    |   3 -
 net/netfilter/ipset/ip_set_bitmap_gen.h       |   2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c        |  26 ++-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c     |  18 +-
 net/netfilter/ipset/ip_set_bitmap_port.c      |  41 +++-
 net/netfilter/ipset/ip_set_core.c             | 212 +++++++++++++++++-
 net/netfilter/ipset/ip_set_getport.c          |  28 ---
 net/netfilter/ipset/ip_set_hash_gen.h         |   4 +-
 net/netfilter/ipset/ip_set_hash_ip.c          |  10 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c       |   8 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c      |   8 +-
 net/netfilter/ipset/ip_set_hash_ipport.c      |   8 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c    |   8 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c   |  24 +-
 net/netfilter/ipset/ip_set_hash_mac.c         |   6 +-
 net/netfilter/ipset/ip_set_hash_net.c         |  24 +-
 net/netfilter/ipset/ip_set_hash_netiface.c    |  24 +-
 net/netfilter/ipset/ip_set_hash_netnet.c      |  28 +--
 net/netfilter/ipset/ip_set_hash_netport.c     |  24 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c  |  28 +--
 net/netfilter/ipset/ip_set_list_set.c         |   4 +-
 23 files changed, 376 insertions(+), 372 deletions(-)

-- 
2.23.0

