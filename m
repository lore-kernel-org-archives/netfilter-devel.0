From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables does not reconise ipportiphash/ipportnethash sets
Date: Wed, 22 Sep 2010 22:27:14 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009222226110.30669@obet.zrqbmnf.qr>
References: <4C9A56D3.109@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35012 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0IVU1P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:27:15 -0400
In-Reply-To: <4C9A56D3.109@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-09-22 21:19, Mr Dash Four wrote:

>I compiled xtables (1.28) from source on x86_64 system and it installs 
>OK, except that none of the above two set types seem to be recognised!
>
>Close examination of /lib/modules/... directory reveals that, actually, 
>NO ip_set_ipportiphash.ko/ipportnethash.ko modules are present.

Yes, it seems to be an unfortunate omission in the Kbuild file. A new 
release will be up shortly, since I have already been pointed towards 
2.6.36 changes.
