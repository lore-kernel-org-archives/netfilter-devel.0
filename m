From: Jan Engelhardt <jengelh@medozas.de>
Subject: RE: iptables rule matching error
Date: Thu, 19 Aug 2010 21:59:46 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008192129010.7622@obet.zrqbmnf.qr>
References: <AANLkTin-QPu+vaZaRy62J80qwVbz1XiazCvi9iYZ1tR3@mail.gmail.com> <alpine.LSU.2.01.1008162227430.5282@obet.zrqbmnf.qr> <AANLkTi=MwadVp=0Yx93QsMkz2f6=Fc6LsMCGnZ9CscFH@mail.gmail.com> <AANLkTimJVo1fY=qnzzm5vt6DLEnC9eY2MKedjLB9f4Jd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mistick Levi <gmistick@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41279 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab0HST7s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Aug 2010 15:59:48 -0400
In-Reply-To: <AANLkTimJVo1fY=qnzzm5vt6DLEnC9eY2MKedjLB9f4Jd@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-08-19 21:21, Mistick Levi wrote:
>Hi,
>thanks for the quick reply.
>
>Could you point a few links with more information? for example what
>modules update internal state and why the evaluation order is
>important?

xt_hashlimit.ko
xt_limit.ko
xt_quota.ko
xt_recent.ko
xt_statistic.ko

>and why does it matter which match evaluate first when the issue here
>is with deletion of a rule... could you give a few examples?

 -m statistic --mode nth --every 10 -m limit --limit 1/s -j FOO
vs
 -m limit --limit 1/s -m statistic --mode nth --every 10 -j FOO

First one looks at every 10th packet and of those FOOs only 1 per 
second.
Second one looks at one packet every second and then FOOS every 10th of 
them.

Big difference.
