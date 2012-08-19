From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: netfilter code question
Date: Sun, 19 Aug 2012 13:11:59 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208191304210.23804@frira.zrqbmnf.qr>
References: <CALcq1oMgPsk3JiYVvPQr8y7GaSV9oLb1oWVV3VN-txfH0HuGDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Vasilis Bakellas <avalon78.gr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:38968 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab2HSLMC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Aug 2012 07:12:02 -0400
In-Reply-To: <CALcq1oMgPsk3JiYVvPQr8y7GaSV9oLb1oWVV3VN-txfH0HuGDA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2012-08-18 23:17, Vasilis Bakellas wrote:

>hi guys,
>
>Can you point me to  the netfilter code that implements ip forwarding
>to other interfaces??

Forwarding is not part of Netfilter, but of core networking. It 
absolutely requires the use of addresses. You cannot forward to 
interfaces, because that has no meaning for output processing.

See net/ipv6/ip6_output.c:ip6_forward for some code.

