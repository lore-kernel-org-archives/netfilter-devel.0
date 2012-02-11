From: Al <aas02929@gmail.com>
Subject: conntrack events latency
Date: Sat, 11 Feb 2012 11:02:09 -0600
Message-ID: <CAE+FTtc2cXxcj_oF-RQpNJiFvdDY9H7fBcQP9nrg+TJLF9E4Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34943 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab2BKRCK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Feb 2012 12:02:10 -0500
Received: by vcge1 with SMTP id e1so2409267vcg.19
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Feb 2012 09:02:09 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Is there any information available on the expected latency between the
moment the kernel sees a new packet/connection and the time the user
space library (and consequently the conntrack process) is notified
with an event regarding the new connection?

I understand this depends on scheduling in general and just want to
know if there is any by design intended delay in sending connection
tracking events from the kernel to user space (for example due to
grouping of events to reduce the frequency of messaging).

Thank you,
Al.
