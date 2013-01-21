From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Build fixes for old Linuxes
Date: Mon, 21 Jan 2013 17:29:08 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301211729040.7798@nerf07.vanv.qr>
References: <1358274002-6042-1-git-send-email-jengelh@inai.de> <20130118004455.GA20537@1984> <alpine.LNX.2.01.1301180228250.14064@nerf07.vanv.qr> <20130118020603.GA25887@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:48548 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab3AUQ3N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:29:13 -0500
In-Reply-To: <20130118020603.GA25887@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2013-01-18 03:06, Pablo Neira Ayuso wrote:

>On Fri, Jan 18, 2013 at 02:29:43AM +0100, Jan Engelhardt wrote:
>[...]
>> So, what is the minimum {kernel, userspace} configuration that
>> we should require from users and which to put into INSTALL?
>> Do we still care about 2.4.x?
>
>As long as it is maintained, 2.4.x matters. Same thing with maintained
>third party library dependencies.
>
Then the first patch should be applied.

