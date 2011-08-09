From: Dan McGee <dan@archlinux.org>
Subject: iptables: libxt_statistic.so undefined symbol: lround
Date: Tue, 9 Aug 2011 10:35:11 -0500
Message-ID: <CAEik5nPmurYA8tysJ7+LRH-uM5Nx=Odr-YYwsrxUKGFivQu1BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45090 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab1HIPfL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:35:11 -0400
Received: by pzk37 with SMTP id 37so149040pzk.1
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Aug 2011 08:35:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arch Linux bug report: https://bugs.archlinux.org/task/25358

Looks like this is simply a case of not adding -libm to xt_statistic
after this [1] commit, should be a quick fix.

Thanks!
-Dan

[1] http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=commitdiff;h=39d3aa36ea38668a2c343b5af42b2d8d3616a9de
