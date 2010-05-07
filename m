From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ipt_LOG: MAC address output
Date: Fri, 7 May 2010 11:31:30 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005071130370.5643@obet.zrqbmnf.qr>
References: <201005031558.09409.thomas.jarosch@intra2net.com> <alpine.LSU.2.01.1005031741100.938@obet.zrqbmnf.qr> <201005071002.49899.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41169 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab0EGJbc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 May 2010 05:31:32 -0400
In-Reply-To: <201005071002.49899.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-05-07 10:02, Thomas Jarosch wrote:

>On Monday, 3. May 2010 17:41:47 Jan Engelhardt wrote:
>> >The MAC address really looks strange if you take
>> >the original data into consideration:
>> >
>> >
>> >- Output "08:00" garbage at the end.
>> 
>> No garbage.
>> 
>> It's not the MAC address, it's the (entire) MAC header that's printed.
>
>Thanks, Jan. So would it make sense to output a human readable
>MACSRC= and MACDST=? We also don't print the raw IP header...

We do print the raw IP options... :)
