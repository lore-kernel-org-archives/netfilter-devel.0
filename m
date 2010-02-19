From: Yacin Nadji <ynadji@gmail.com>
Subject: Add Rules from Within the Kernel -- Where to Start?
Date: Thu, 18 Feb 2010 21:14:44 -0500
Message-ID: <f503ee681002181814y11321d3cqb9e0b42c314e64d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f196.google.com ([209.85.223.196]:62837 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0BSCPF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 21:15:05 -0500
Received: by iwn34 with SMTP id 34so339726iwn.15
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2010 18:15:04 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Howdy list!

I'm working on a research project where I'd like to be able to
create/update iptables entries from within kernel-space instead of the
usual route through user-space (with the client iptables). The idea is
to have a separate rule set that can only be altered by the kernel,
and not by the normal iptables client in user-space. I've looked
around the documentation, but the majority of it seems focused on
adding extensions that would operate in userland.

My question is, where should I look for this functionality in
netfilter/the kernel? I was originally planning on tracing the calls
up into the kernel through the client iptables to see what kernel
functions end up being called, but things got pretty muddy for me as
it passed through libiptc/tipc. Any suggestions on where to look to
achieve iptables-like functionality entirely within the kernel would
be much appreciated.

Thanks!

Yacin
