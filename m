From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem with ipset on sparc64
Date: Wed, 4 Nov 2009 23:08:15 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911042258430.16456@obet.zrqbmnf.qr>
References: <4513233BE7DF454BB62D30017EEE55436CFB9228E4@GVW1115EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Chini, Georg (HP App Services)" <georg.chini@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45981 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290AbZKDWIK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:08:10 -0500
In-Reply-To: <4513233BE7DF454BB62D30017EEE55436CFB9228E4@GVW1115EXC.americas.hpqcorp.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-11-04 22:50, Chini, Georg (HP App Services) wrote:
>>
>>I'm using ipset 3.2 on a sparc64 system (ultra2), kernel 2.6.31.5, Debian 5.
>>Everything works fine, but the -L option shows strange values for a portmap.
>
>
>If you explicitly compile ipset as a 64-bit program rather than the
>32-bit default that is used on sparc, will the correct values be
>shown?
>
>Thanks for the fast reply. I added -m64 to cc and ld options and
>recompiled. Is that correct? If yes, I now get a bus error instead
>of a wrong listing. Or do I have to change anything else?

Bus error means something was not quite correctly aligned
(yet another ipset bug).

The lack of cheap access to big-endian, alignment-sensitive hardware
means many codes do not get the testing they deserve :-/

To workaround the alignedness issue, you could take an x86_64 machine
and compile a strictly 32-bit ipset on it, and see whether the values
are also off.
