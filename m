From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Data rate of a connection using conntrack
Date: Wed, 28 Oct 2009 18:39:10 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0910281839000.15948@obet.zrqbmnf.qr>
References: <4d5b51f60910060816i35c9ffd8y9bf2695f9d28bca3@mail.gmail.com> <4AE8706A.30205@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Anand Raj Manickam <anandrm@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59931 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbZJ1RjF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:39:05 -0400
In-Reply-To: <4AE8706A.30205@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2009-10-28 17:25, Patrick McHardy wrote:

>Anand Raj Manickam wrote:
>> I understand from RATEEST that data rate of an interface is estimated
>> using the gen_new_estimator , which is also used by the TC , qdisc n
>> folks ...
>> Has anybody tried to estimate the data rate of a connection using conntrack ?
>> Anyone's previous attempts or experiences  are welcome.
>
>There has been a patch a (long) while ago which was somehow
>based on conntrack. You should be able to find it in the
>old patch-o-matic (not -ng) repository.

The extension's name was "connrate" and was in -ng.
