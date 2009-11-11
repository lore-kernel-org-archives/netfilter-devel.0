From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset 4.0 released
Date: Wed, 11 Nov 2009 19:20:52 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911111920010.20309@obet.zrqbmnf.qr>
References: <alpine.DEB.2.00.0911102208000.23130@blackhole.kfki.hu> <20091111095700.5b621878@s6510>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51529 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758349AbZKKSUr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2009 13:20:47 -0500
In-Reply-To: <20091111095700.5b621878@s6510>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-11-11 18:57, Stephen Hemminger wrote:
>> 
>> I'm happy to announce the new ipset release which fixes kernel version 
>> compatibility and alignment issues:
>
>I would like to see ipset submitted for upstream kernel. It would mean one
>less kernel patch that we would have to maintain in the our distro kernel, and
>get wider usage.

It works flawlessy as a DKMS/KMP. Vyatta not using modules?
