From: Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [PATCH] libxt_TCPMSS.c: unbreak build without ipv6 after ea2a02f7
Date: Fri, 22 Jul 2011 12:49:35 +0200
Message-ID: <87zkk6y4hs.fsf@macbook.be.48ers.dk>
References: <1311312260-16102-1-git-send-email-jacmet@sunsite.dk>
	<alpine.LNX.2.01.1107221157540.17453@frira.zrqbmnf.qr>
	<874o2ezk67.fsf@macbook.be.48ers.dk>
	<alpine.LNX.2.01.1107221227180.4330@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39934 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1GVKtw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:49:52 -0400
Received: by wyg8 with SMTP id 8so1409064wyg.19
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Jul 2011 03:49:51 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1107221227180.4330@frira.zrqbmnf.qr> (Jan
	Engelhardt's message of "Fri, 22 Jul 2011 12:31:04 +0200 (CEST)")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>>>> "Jan" == Jan Engelhardt <jengelh@medozas.de> writes:

Hi,

 >> But those structs define the network format of ipv4 and ipv6 headers, so
 >> they are not likely to change.

 Jan> I was pondering on a hypothetical implementation with CHAR_BIT=16.

Using iptables? Even so, the ipv6 header would need to be the same to be
able to communicate with other ipv6 hosts.

 Jan> How about 
 Jan> http://dev.medozas.de/gitweb.cgi?p=iptables;a=commitdiff;h=4d8656ad9d0afd04820f125a85a7b673c7e74fe6

That works as well (if we assume that all systems have netinet/ip.h even
when built with --disable-ipv4):

checking size of struct ip6_hdr... 0

So you end up with a wrong TCPMSS6_opts.max value (UINT16_MAX), but that
presumably doesn't matter if you don't use ipv6.

-- 
Bye, Peter Korsgaard
