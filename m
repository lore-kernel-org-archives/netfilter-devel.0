From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons suggestions
Date: Tue, 16 Feb 2010 22:32:33 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002162230430.29148@obet.zrqbmnf.qr>
References: <20100216215128.1c154cdb@outerspace> <alpine.LSU.2.01.1002162057390.20293@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53124 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065Ab0BPVcf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2010 16:32:35 -0500
In-Reply-To: <alpine.LSU.2.01.1002162057390.20293@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-02-16 21:23, Jan Engelhardt wrote:
>On Tuesday 2010-02-16 20:51, Jonas Berlin wrote:
>>
>>Hi, I am using xtables-addons-1.22 and needed to do some changes to get
>>it to compile in my setup. I thus present a few suggestions below:
>>
>>1. When using --with-xtables, I got problems at linking time, failing
>>to find libxtables.. By changing configure.ac like below I was able to
>>solve the issue.

Well after all, libxtables_LIBS is currently never used.
(Extension modules don't link to it.)
So I cannot imagine linking problems, but that's the point
where you have to provide logs.
