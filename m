Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F1A9C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 17:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16BF760EC0
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 17:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244816AbhIQRDz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 13:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbhIQRDy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 13:03:54 -0400
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74D0C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Sep 2021 10:02:31 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc9b.ng.seznam.cz (email-smtpc9b.ng.seznam.cz [10.23.14.15])
        id 4842bba2562753e648d3104d;
        Fri, 17 Sep 2021 19:02:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1631898144; bh=H2yeBdYXWKgtoWSRS4cDizpCW2lMSjRxjn6PsLRzG30=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:References:
         Mime-Version:X-Mailer:Content-Type:Content-Transfer-Encoding;
        b=Qm86xZ4CuYFbPfu53AKG/4hlf0M4pJEYL4jbV7XeB1ysLTosUCLWbuQ8ayqwzEZfJ
         8Y9p9xHtMy+p82FW6Mg95s+MHBefwBwUakwgTotv/7CKt9JBcsgkaHInvuLzsO5DTL
         KDQ80bvoK2mUcTPCO8j+0nFm3EJf2oetYI65xviM=
Received: from unknown ([::ffff:176.114.242.3])
        by email.seznam.cz (szn-ebox-5.0.80) with HTTP;
        Fri, 17 Sep 2021 19:02:21 +0200 (CEST)
From:   <kaskada@email.cz>
To:     "Jeremy Sowden" <jeremy@azazel.net>
Cc:     "Jan Engelhardt" <jengelh@inai.de>,
        "Netfilter Devel" <netfilter-devel@vger.kernel.org>
Subject: Re: [xtables-addons] xt_ipp2p: add ipv6 module alias
Date:   Fri, 17 Sep 2021 19:02:21 +0200 (CEST)
Message-Id: <LB.aVMR.2UsKdL7t3RE.1XHCeT@seznam.cz>
References: <FA.Zu6V.5ytypyKnDSO.1XGXsj@seznam.cz>
        <20210914140934.190397-1-jeremy@azazel.net>
        <33D.aVMp.3L4gqjighB0.1XGFsS@seznam.cz>
        <YUIJW3DPDsmmjYPA@azazel.net>
        <sqos9337-n8n6-1os2-s7qr-n4364on33nqp@vanv.qr>
        <14d.aVM5.6eKrJXfu}0l.1XGpUS@seznam.cz>
        <YUOWFQUquE59aamm@azazel.net>
Mime-Version: 1.0 (szn-mime-2.1.14)
X-Mailer: szn-ebox-5.0.80
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thank you a lot for your support. Unfortunatelly I`ll be away for next 2 w=
eeks, so I can not cooperate now. After that I`d like to continue.

see you soon
Pep.



---------- P=C5=AFvodn=C3=AD e-mail ----------

Od: Jeremy Sowden <jeremy@azazel.net>

Komu: kaskada@email.cz

Datum: 16. 9. 2021 21:13:04

P=C5=99edm=C4=9Bt: Re: [xtables-addons] xt_ipp2p: add ipv6 module alias

On 2021-09-16, at 14:25:00 +0200, kaskada@email.cz wrote:

> How can I check where iptables/ip6tables searches for plugins/modules

> please?

>

> Actually the problem is not with iptables but with ip6tables. I can

> use IPP2P module on the same Debian with no problems with iptables,

> but ip6tables give this error (still the same):

>

> ip6tables -t mangle -A PREROUTING -m ipp2p --dc -j ACCEPT

> ip6tables v1.8.4 (legacy): Couldn't load match `ipp2p':No such file or=


> directory

>

> Try `ip6tables -h' or 'ip6tables --help' for more information.

>

> BTW I`m using legacy (not nf_tables) iptables and ip6tables (changed

> with update-alternatives --config iptables, update-alternatives

> --config ip6tables).



xtables-addons installs the following kernel modules:



  /lib/modules/4.19.0-17-amd64/extra/compat_xtables.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_ACCOUNT.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_CHAOS.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_condition.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_DELUDE.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_DHCPMAC.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_DNETMAP.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_ECHO.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_fuzzy.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_geoip.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_iface.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_IPMARK.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_ipp2p.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_ipv4options.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_length2.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_LOGMARK.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_lscan.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_pknock.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_PROTO.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_psd.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_quota2.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_SYSRQ.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_TARPIT.ko



and the following user-space libraries:



  /usr/lib/x86_64-linux-gnu/xtables/libxt_ACCOUNT.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_CHAOS.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_condition.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_DELUDE.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_dhcpmac.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_DHCPMAC.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_DNETMAP.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_ECHO.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_fuzzy.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_geoip.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_gradm.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_iface.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_IPMARK.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_ipp2p.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_ipv4options.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_length2.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_LOGMARK.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_lscan.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_pknock.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_PROTO.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_psd.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_quota2.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_SYSRQ.so

  /usr/lib/x86_64-linux-gnu/xtables/libxt_TARPIT.so



Make sure you're not using the xt_ipp2p.ko kernel module:



  $ sudo ip6tables-legacy -F -t mangle

  $ sudo iptables-legacy -F -t mangle



Make sure you don't have xt_ipp2p.ko loaded:



  $ sudo modprobe -r xt_ipp2p



Make sure the files don't exists on your box:



  $ sudo rm /lib/modules/4.19.0-17-amd64/extra/xt_ipp2p.ko

  $ sudo rm /usr/lib/x86_64-linux-gnu/xtables/libxt_ipp2p.so



Run depmod:



  $ sudo depmod -av | awk '$1 ~ /xt_ipp2p/'



Make sure you've got the latest source checked out and pristine:



  $ git clean -d -f -x

  $ git reset --hard master

  HEAD is now at f144c2e xt_ipp2p: replace redundant ipp2p_addr

  $ git pull --rebase origin master

  From https://git.inai.de/xtables-addons

   * branch            master     -> FETCH_HEAD

  Already up to date.

  Current branch master is up to date.

  $ git log -1

  commit f144c2ebba17aa4c6b8d402623d53b655945be76 (HEAD -> master, origin/=
master, origin/HEAD)

  Author: Jan Engelhardt <jengelh@inai.de>

  Date:   Tue Sep 14 17:07:58 2021 +0200



      xt_ipp2p: replace redundant ipp2p_addr



Build and install it:



  $ ./autogen.sh

  $ ./configure

  $ make -j3

  $ sudo make install



Run depmod:



  $ sudo depmod -av | awk '$1 ~ /xt_ipp2p/'

  /lib/modules/4.19.0-17-amd64/extra/xt_ipp2p.ko needs "xt_unregister_matc=
hes": /lib/modules/4.19.0-17-amd64/kernel/net/netfilter/x_tables.ko

  /lib/modules/4.19.0-17-amd64/extra/xt_ipp2p.ko needs "HX_memmem": /lib/m=
odules/4.19.0-17-amd64/extra/compat_xtables.ko



Use the extension:



  $ sudo ip6tables-legacy -t mangle -A PREROUTING -m ipp2p --dc -j ACCEPT=


  $ sudo ip6tables-legacy -t mangle -L PREROUTING

  Chain PREROUTING (policy ACCEPT)

  target     prot opt source               destination

  ACCEPT     all      anywhere             anywhere             -m ipp2p  =
--dc



J.

