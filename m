From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem with ipset on sparc64
Date: Thu, 5 Nov 2009 21:10:54 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911052110040.30403@obet.zrqbmnf.qr>
References: <4513233BE7DF454BB62D30017EEE55436CFB9228E4@GVW1115EXC.americas.hpqcorp.net> <alpine.LSU.2.00.0911042258430.16456@obet.zrqbmnf.qr> <alpine.DEB.2.00.0911052100010.14609@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Chini, Georg (HP App Services)" <georg.chini@hp.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49152 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757906AbZKEUKt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:10:49 -0500
In-Reply-To: <alpine.DEB.2.00.0911052100010.14609@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2009-11-05 21:03, Jozsef Kadlecsik wrote:

>On Wed, 4 Nov 2009, Jan Engelhardt wrote:
>
>> To workaround the alignedness issue, you could take an x86_64 machine
>> and compile a strictly 32-bit ipset on it, and see whether the values
>> are also off.
>
>On x86_64 using a 32-bit ipset, the listed values are correct.

But that would not tell you if there are 64-bit quantities that
do not fulfill the 64-bit alignment, because x86 handles misaligned
reads transparently in hardware. Then again, the number of 64-bit
items is probably manageable and statically analyzable.
