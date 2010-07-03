From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables addons; mktemp
Date: Sat, 3 Jul 2010 08:30:39 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007030827100.20900@obet.zrqbmnf.qr>
References: <4C2E9964.5030002@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: martinbarrowcliff <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39381 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab0GCGak (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Jul 2010 02:30:40 -0400
In-Reply-To: <4C2E9964.5030002@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2010-07-03 03:59, martinbarrowcliff wrote:

> With my embedded firewall system the busybox mktemp function
> fails due to unsupported flags, so the xtables-addons build fails
> on the native toolchain.
> I think this issue should be considered, because so many appliances
> do use busybox and some may even have a working toolchain...
>
> make[1]: Leaving directory
> `/usr/src/source/build/firewall/xtables-addons-1.27/extensions'
> mktemp: invalid option -- u

The fact that $(shell mktemp -dtu) fails should not abort the 
build. I can pick a standard system, add the unknown option -x, and 
still have make succeed as long as you don't try to execute the make 
tarball target.
