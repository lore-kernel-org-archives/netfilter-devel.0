From: Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH iptables v2]: Support the iptables lock in ip[6]tables-restore
Date: Thu, 16 Mar 2017 16:55:00 +0900
Message-ID: <20170316075502.2337-1-lorenzo@google.com>
Cc: pablo@netfilter.org, jscherpelz@google.com,
        subashab@codeaurora.org, zlpnobody@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:32943 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdCPHzl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Mar 2017 03:55:41 -0400
Received: by mail-pf0-f175.google.com with SMTP id w189so20656345pfb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Mar 2017 00:55:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series adds support for -w and -W to ip[6]tables-restore,
which currently do not perform any locking.

The lock is not acquired on startup. Instead, it is acquired when
a new table handle is created (on encountering '*') and released
when the table is committed (COMMIT). This makes it possible to
keep long-running iptables-restore processes in the background
(for example, reading commands from a pipe opened by a system
management daemon) and simultaneously run iptables commands.
An example usage is Android's IptablesRestoreController.cpp.

The first patch factors out to common functions the code that
parses -w and -W, in order not to have to add more copies of it.
The second patch actually adds support to iptables-restore.

