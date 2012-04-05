From: Gorik Van Steenberge <gorik.vansteenberge@gmail.com>
Subject: ipsets and network namespaces
Date: Thu, 5 Apr 2012 13:04:48 +0200
Message-ID: <CAFJYBU3q9au5qS0_CC4kp_jsRo-r08hejhQb_nvMqXGt57WdSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60092 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962Ab2DELEt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Apr 2012 07:04:49 -0400
Received: by lahj13 with SMTP id j13so1366059lah.19
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Apr 2012 04:04:48 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I've noticed that when creating a new network namespace (using the lxc
tools) that ipsets (userspace v6.11 on kernel 3.3.1) are still global,
i.e. an ipset created in the container is visible in the host and vice
versa. Iptables rulesets, however, are isolated.

Is this an as of yet unimplemented feature or a conscious design decision?

Thanks,
gvs
