From: Peter Skvarka <pet3243@gmail.com>
Subject: net_device features
Date: Sat, 7 Jan 2017 19:48:30 +0100
Message-ID: <CAOwjcYfEeBHrL0TsD6yY9piMcmZkEsYfysYV+hsGF=YrTm6cqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36488 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933394AbdAGSsb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Jan 2017 13:48:31 -0500
Received: by mail-oi0-f48.google.com with SMTP id u143so59151619oif.3
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Jan 2017 10:48:31 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I need to change net_device->features i.e. segmentation offload when
my netfilter module is loaded.
I tried it in my module by directly zeroing flag when module is loaded
in register device notification handler.
It seems that it is really functional and I verified it by ethtool -k
modulename and no skb with fragments appears in netfilter hook.
When I change it back to original state with ethtool -K ... then
console outputs original state but it seems that still no skb with
fragments comes and this state is somewhere remembered.

How to proper set such flags to have required behavior when module
runs ? Is directly changing in net_device structure right ?

I appear function pointer ndo_fix_features() that can be used to
adjust required features. But it's parent structure is constant. Does
exist some way how to set my own handlers in net_device_ops structure
in my module code ?

Thank you !
Peter
