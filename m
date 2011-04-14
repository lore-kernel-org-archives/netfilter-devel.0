From: Janis Dzerve <janisdz2@gmail.com>
Subject: SNAT in NF_INET_PRE_ROUTING not working on kernel 2.6.35
Date: Thu, 14 Apr 2011 12:57:57 -0700
Message-ID: <BANLkTimxX+sjsYpSCpyeKsejamAk_O0WYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51656 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab1DNT57 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:57:59 -0400
Received: by eyx24 with SMTP id 24so559350eyx.19
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2011 12:57:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm working on the project where incoming packets are source-natted in
NF_INET_PRE_ROUTING netfilter hook.
I know that iptables does not allow SNAT in PREROUTING but it works
fine in preroute netfilter hook in kernel 2.6.32 with rp_filter
disabled.
After upgrading to kernel 2.6.35 it does not work any more. I.e. the
natted packets are dropped somewhere after being natted and do not
appear in the forwarding hook any more.

So, I wanted to ask if this feature (snat in preroute) was explicitly
disabled? and is there any way to reenable it?

Thank you,
Janis Dzerve.
