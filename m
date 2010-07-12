From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: unable to find struct ip_nat_multi_range
Date: Mon, 12 Jul 2010 20:36:45 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007122031370.27727@obet.zrqbmnf.qr>
References: <AANLkTiknjTq-sw5RKFaczEHlIVu_1DJQitTGiG9MX2HJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pete Kay <petedao@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35972 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab0GLSgr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jul 2010 14:36:47 -0400
In-Reply-To: <AANLkTiknjTq-sw5RKFaczEHlIVu_1DJQitTGiG9MX2HJ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-07-12 16:44, Pete Kay wrote:

>Hi,
>
>I am using kernel 2.6.33 right now, and I can no longer find ip_nat.h
>anywhere in the file system.
>
>I used to have that file with 2.6.18 kernel.

I'll be enterprisy: if there isn't anything in for me, it's not worth 
looking at such oooold things. :)

>Is there any alternative other than using struct ip_nat_multi_range?

nf_nat.h
