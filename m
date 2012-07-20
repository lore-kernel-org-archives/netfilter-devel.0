From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: nf_conntrack and nf_conntrack_ipv4 modules are missing
Date: Fri, 20 Jul 2012 11:25:30 -0700
Message-ID: <CAAJpzgb3aZF9QU_Y5zonqVapNSWfMVfa2EYmskT=tsPHVbyNpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58399 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2GTSZv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:25:51 -0400
Received: by obbuo13 with SMTP id uo13so5168476obb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jul 2012 11:25:50 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have installed the following rpms in my system.

conntrack-tools-1.2.1-30.2.x86_64.rpm
libnetfilter_log1-1.0.1-21.1.x86_64.rpm
libmnl0-1.0.3-22.1.x86_64.rpm
libnfnetlink0-1.0.0+git28-25.1.x86_64.rpm
libnetfilter_acct1-1.0.0-15.1.x86_64.rpm
libnetfilter_conntrack3-1.0.1-25.1.x86_64.rpm  ulogd-2.0.0-9.1.x86_64.rpm
libnetfilter_cttimeout1-1.0.0-15.1.x86_64.rpm

When I tried to modprobe nf_conntrack and nf_conntrack_ipv4, I am
getting fatal error.
Those modules are not available in /lib/modules directory. How I can
get those modules?

Your help would be much appreciated.

Thanks & Regards,
