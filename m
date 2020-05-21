Return-Path: <SRS0=/RxB=7D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E074C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 May 2020 21:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41636207D3
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 May 2020 21:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbgEUVJH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 May 2020 17:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729803AbgEUVJG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 May 2020 17:09:06 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3D2C061A0E
        for <netfilter-devel@vger.kernel.org>; Thu, 21 May 2020 14:09:06 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id C1B185889E32A; Thu, 21 May 2020 23:09:01 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id BE40260E404CF;
        Thu, 21 May 2020 23:09:01 +0200 (CEST)
Date:   Thu, 21 May 2020 23:09:01 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Oskar Berggren <oskar.berggren@gmail.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: ipset make modules_install fails to honor INSTALL_MOD_PATH
In-Reply-To: <CAHOuc7OX=a0OjLpyJf3bU9sfmrd+_XbMBt+JN3w1QeKGPod0pw@mail.gmail.com>
Message-ID: <nycvar.YFH.7.77.849.2005212305180.7617@n3.vanv.qr>
References: <CAHOuc7OX=a0OjLpyJf3bU9sfmrd+_XbMBt+JN3w1QeKGPod0pw@mail.gmail.com>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2020-05-21 21:27, Oskar Berggren wrote:

>make
>make modules
>DESTDIR=... make install
>INSTALL_MOD_PATH=... make modules_install

» make modules_install DESTDIR=/tmp/RT INSTALL_MOD_PATH=/tmp/RT2
make -C /home/jengelh/code/linux M=$PWD/kernel/net \
                KDIR=$PWD/kernel modules_install
make[1]: Entering directory '/home/jengelh/code/linux'
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_bitmap_ip.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_bitmap_port.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_hash_ip.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_hash_ipmac.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_hash_ipmark.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_hash_ipport.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_hash_ipportip.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_hash_ipportnet.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_hash_mac.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_hash_net.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_hash_netiface.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_hash_netnet.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_hash_netport.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_hash_netportnet.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/ipset/ip_set_list_set.ko
  INSTALL /ipset-7.6/kernel/net/netfilter/xt_set.ko
  INSTALL /ipset-7.6/kernel/net/sched/em_ipset.ko
  DEPMOD  5.7.0-rc6-2.gb520bde-default+
Warning: modules_install: missing 'System.map' file. Skipping depmod.
make[1]: Leaving directory '/home/jengelh/code/linux'
modinfo: ERROR: Module alias ip_set_hash_ip not found.

!!! WARNING !!! WARNING !!! WARNING !!!

Your distribution seems to ignore the /lib/modules/<kernelrelease>/extra/
subdirectory, where the ipset kernel modules are installed.

Add the 'extra' directory to the search definition of your depmod
configuration (/etc/depmod.conf or /etc/depmod.d/) and re-run

        depmod <kernelrelease>

otherwise the ipset kernel modules in the extra subdir will be ignored.


» find /tmp/RT2/
/tmp/RT2/
/tmp/RT2/lib
/tmp/RT2/lib/modules
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/sched
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/sched/em_ipset.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/xt_set.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_list_set.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_hash_netportnet.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_hash_netport.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_hash_netnet.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_hash_netiface.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_hash_net.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_hash_mac.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_hash_ipportnet.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_hash_ipportip.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_hash_ipport.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_hash_ipmark.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_hash_ipmac.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_hash_ip.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_bitmap_port.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_bitmap_ipmac.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set_bitmap_ip.ko
/tmp/RT2/lib/modules/5.7.0-rc6-2.gb520bde-default+/extra/netfilter/ipset/ip_set.ko


