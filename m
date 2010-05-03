From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ipt_LOG: MAC address output
Date: Mon, 3 May 2010 17:41:47 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005031741100.938@obet.zrqbmnf.qr>
References: <201005031558.09409.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44990 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822Ab0ECPlt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 May 2010 11:41:49 -0400
In-Reply-To: <201005031558.09409.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-05-03 15:58, Thomas Jarosch wrote:

>Hello,
>
>below is an ipt_LOG output from kernel 2.6.33.2:
>
>May  3 15:14:40 intratest kernel: REJECT IN=eth0 OUT=
>MAC=02:00:00:00:00:29:00:0c:76:28:3e:6c:08:00 SRC=172.16.1.1 DST=172.16.1.145 ...
>
>The MAC address really looks strange if you take
>the original data into consideration:


>- Output "08:00" garbage at the end.

No garbage.

It's not the MAC address, it's the (entire) MAC header that's printed.
