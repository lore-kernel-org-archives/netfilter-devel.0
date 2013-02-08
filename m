From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Assorted fixes v3
Date: Fri, 8 Feb 2013 02:11:29 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1302080204350.10433@nerf07.vanv.qr>
References: <1360111625-1759-1-git-send-email-jengelh@inai.de> <20130207185330.GA18719@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40697 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759783Ab3BHBLa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2013 20:11:30 -0500
In-Reply-To: <20130207185330.GA18719@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2013-02-07 19:53, Pablo Neira Ayuso wrote:
>> ----------------------------------------------------------------
>> Jan Engelhardt (4):
>>       build: bump SONAME for libxtables
>
>Applied this one, thanks a lot for catching up this.
>
>>       libxtables: centralize checking for a .save function
>>       extensions: eui64: set userspacesize=0
>>       iptables: fall back to using save function when print is not defined
>
>Not applying these, they are not fixes, sorry.

If you say so. (But it would have been nice to get told that the first time.)

Now, I can't put these onto nf/next without someone having to go through
a merge conflict later on, so besides getting put on hold again,
what is the preferable action?
