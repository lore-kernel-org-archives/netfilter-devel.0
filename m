From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: inconsistent address treatment.
Date: Thu, 23 Dec 2010 22:53:18 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012232253090.28085@obet.zrqbmnf.qr>
References: <4D1358C0.4060704@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51931 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab0LWVxT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Dec 2010 16:53:19 -0500
In-Reply-To: <4D1358C0.4060704@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-12-23 15:12, Stephen Clark wrote:

> Hello,
>
> Why the inconsistency in the way addresses are treated. I can use -d 2.2.2.2/32
> but not --to-source 205.201.149.214/32
>
> iptables -t nat -A POSTROUTING -o eth1 -s 10.0.128.0/17 -d 2.2.2.2/32 -j SNAT
> --to-source 205.201.149.214/32

What inconsistency?
