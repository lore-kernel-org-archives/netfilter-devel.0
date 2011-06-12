From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: option "--state" cannot be inverted
Date: Sun, 12 Jun 2011 19:40:38 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106121939360.10943@frira.zrqbmnf.qr>
References: <it2te9$o7a$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergei Zhirikov <sfzhi@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33222 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab1FLRkk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jun 2011 13:40:40 -0400
In-Reply-To: <it2te9$o7a$1@dough.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2011-06-12 19:36, Sergei Zhirikov wrote:

> Hi,
>
> If I try to use
>
> -m state ! --state NEW
>
> as a part of the iptables command line I get this error message:
>
> iptables v1.4.11.1: state: option "--state" cannot be inverted.
>
> It worked fine with iptables 1.4.10. I'm wondering if this an intended change
> or one more in the series of similar bugs introduced in 1.4.11?

Similar oversight, unfortunately. But you can use -m conntrack instead 
which does not have the issue.
