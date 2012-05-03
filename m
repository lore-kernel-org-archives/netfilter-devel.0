From: rahul shrivastava <shrivastavaone@gmail.com>
Subject: facing problem with iptables nat rules and traffic flow scnerios
Date: Thu, 3 May 2012 14:25:34 +0530
Message-ID: <CAE1WnGdo1O0AyS0Q=00m3vou0nQnE0FzSR3-NWi-YMr3zwn8dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51742 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2ECIzf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 May 2012 04:55:35 -0400
Received: by dady13 with SMTP id y13so1356404dad.5
        for <netfilter-devel@vger.kernel.org>; Thu, 03 May 2012 01:55:35 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am using iptables for nat
kernel version is 2.6.35+
working on powerpc target

case 1) traffic is already flowing and we apply a rule, that rule will
become effective only when we stop traffic and start again.

case 2) traffic is already flowing and we delete a rule, this rule
will still be effective unless we stop and start traffic again.

observation: /proc/net/ip_conntrack file is updated only after stoping
and starting traffic again.


These two are the limitations i am facing. Is there a way to overcome
these limitations. Please reply

Thanks and Regards,
Rahul Shrivastava
