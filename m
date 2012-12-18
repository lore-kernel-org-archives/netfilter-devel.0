From: =?ISO-8859-1?Q?Miguel_Alejandro_Gonz=E1lez?= <maggonzz@gmail.com>
Subject: NAT pool
Date: Tue, 18 Dec 2012 16:32:05 -0600
Message-ID: <CAOSBYzcjkZiPA7zFC62OoQGdzTiw7c4aavvBE1_FM+Su1x5Mxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:63721 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab2LRWhq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:37:46 -0500
Received: by mail-qa0-f43.google.com with SMTP id cr7so3837091qab.2
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Dec 2012 14:37:46 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

I was wondering how the pool of ipv4 addresses works in netfilter. I
know you can configure a range or subnet from iptables when you are
configuring NAT.I was reading some NAT code from the kernel, but I
think it just checks if the packet's address is in the range
specified.

I guess my main question is, if there is a ipv4 pool implementation in
netfilter. If so, can it be used by other modules?

Regards
