From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: 10GbE Connectivity & Netfilter
Date: Tue, 13 Mar 2012 15:02:13 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1203131458170.5880@frira.zrqbmnf.qr>
References: <4F5F49FC.1080207@f-secure.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Tarkan Erimer <tarkan.erimer@f-secure.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:49406 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451Ab2CMOCP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:02:15 -0400
In-Reply-To: <4F5F49FC.1080207@f-secure.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2012-03-13 14:22, Tarkan Erimer wrote:
>
> 1- Is netfilter subsystem multi-threaded/multi-core enabled ? So that, it can
> spread the loads across the CPUs/Cores.

Like most kernel subsystems, it is.

> 2- Can it handle such loads consistently (without any issues/bottlenecks) as
> I've mentioned above ?

Question is more like, can your hardware handle it.

> 4- What kind of netfilter/kernel configs recommended for such a load ?

Does not really matter.
