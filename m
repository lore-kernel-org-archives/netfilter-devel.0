From: Stephan Arndt <arndt.stephan@gmail.com>
Subject: Writing nftables extension / modifying packets via nftables and netfilter
Date: Wed, 30 Mar 2016 13:30:02 +0200
Message-ID: <CADe663tomjpV68twUaR7+vQcuqsEhs_=XJ1qiZHUOhM-i9bkkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36786 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbcC3LaE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Mar 2016 07:30:04 -0400
Received: by mail-wm0-f49.google.com with SMTP id 127so93340210wmu.1
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Mar 2016 04:30:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

I would like to write a netfilter module to modify packets going in
and out of my machine (TCP/IP headers, maybe content) after some
analysis of the packet. For this, I wanted to extend nftables with new
matches or targets that control this modification behavior. I've
looked around some, but couldn't find documentation on how to do this
properly using nftables, can someone point me in the right direction?

Using a netfilter/iptables combo, this kind of extension seems to be
pretty well documented (e.g. at the HOWTO page for netfilter hacking
[1]). I could also go this route, but as nftables seems to be poised
to succeed iptables, I wanted to try my hands at using the
future-proof technology.

Regards,

Stephan

[1] http://www.netfilter.org/documentation/HOWTO/netfilter-hacking-HOWTO-4.html

PS: Offtopic: The header of the mailing lists webpage:
http://netfilter.org/mailinglists.html seems to be missing a 't' :
Mailinglists of _he netfilter/iptables project
