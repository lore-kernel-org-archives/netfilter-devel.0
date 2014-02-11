From: Duncan Eastoe <duncaneastoe@gmail.com>
Subject: Netfilter Extension Development Queries
Date: Tue, 11 Feb 2014 21:30:37 +0000
Message-ID: <CAECcapiTOutsUuaukD7uzuXtLeJTmqua4jhzZFZZ735OQ+L9dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:40590 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaBKVa6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:30:58 -0500
Received: by mail-ve0-f177.google.com with SMTP id jz11so6474103veb.8
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Feb 2014 13:30:57 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I wish to build an extension that strips LSRR IPv4 Options from
outgoing traffic and re-inserts it for inbound traffic. I've been
given some pointers about how to approach this which are:
    * A match extension which matches on the presence of LSRR options.
    * A target extension, similar to NAT, that removes/reinserts the
appropriate LSRR options.

On the Netfilter Extensions HOWTO I have found a match extension by
Fabrice Marie (http://www.netfilter.org/documentation/HOWTO/netfilter-extensions-HOWTO-3.html#ss3.6)
which should already do what I want. There is also a target extension
which strips all IP Options
(http://www.netfilter.org/documentation/HOWTO/netfilter-extensions-HOWTO-4.html#ss4.2).

I believe these extensions were in the deprecated Patch-O-Matic system
(?) and this has been replaced by Xtables-addons which appears to
contain an IP Options match extension but not a target extension?

Also, regarding the switch to nftables from iptables. Will my approach
listed above work with iptables and nftables or is a different
approach required for nftables?

Thank you in advance.

Duncan
