From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Request: Remove duplicate file names in the kernel source
Date: Wed, 3 Sep 2008 09:40:55 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809030940470.29016@fbirervta.pbzchgretzou.qr>
References: <BLU122-W19B435CA307A7ED8A80E18DA5F0@phx.gbl> <20080902.160601.109446139.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: hallberg68@hotmail.com, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33375 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYICNk5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:40:57 -0400
In-Reply-To: <20080902.160601.109446139.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-09-02 19:06, David Miller wrote:
>
>> The netfilter sources in the Linux Kernel contains a number of files
>> that is duplicates expect for the case, like foo.c and FOO.c, this
>> creates a problem when untaring the kernel source on a filesystem
>> that doesn't support it like the common Windows file systems,
>> sometimes you have the need to study the kernel source on other
>> systems and it really is unecessary and confusing to have this
>> naming so I would like to ask you to change it, below is a list of
>> the files:
>
>We can't change these, especially the ones under include/linux,
>without breaking userspace as userspace includes these files.

-> http://thread.gmane.org/gmane.comp.security.firewalls.netfilter.devel/25930
