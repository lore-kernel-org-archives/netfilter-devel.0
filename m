From: David Corrales <corrales.david@gmail.com>
Subject: Missing kernel header files
Date: Thu, 30 Sep 2010 14:51:52 -0600
Message-ID: <AANLkTinPD=3yC=KF_juTvUumXwmuMzgjrXyRg4NmML-C@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39510 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0I3Uvx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:51:53 -0400
Received: by ewy23 with SMTP id 23so1062367ewy.19
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2010 13:51:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi everyone,

Recently I ran across some issues when compiling iptables 1.2.9
against kernel 2.6.24. It seems that between kernel versions 2.6.31 to
2.6.32, lots of headers were removed from linux/include/netfilter and
linux/include/netfilter_ipv4. Some of them are ipt_connmark.h,
ipt_conntrack.h, ipt_MARK.h and so on.

I recon that the iptables version is rather old but I was wondering if
it possible to patch it in order to compile with the upgrades. I just
can't seem to find any good info on these changes, what was merged or
what's now deprecated. There's no "migrating" guide anywhere and
google isn't helping as much as I would like it to.

Thanks in advance,
-David
