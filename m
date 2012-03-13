From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: 10GbE Connectivity & Netfilter
Date: Tue, 13 Mar 2012 15:10:31 +0100
Message-ID: <201203131510.32083.thomas.jarosch@intra2net.com>
References: <4F5F49FC.1080207@f-secure.com> <alpine.LNX.2.01.1203131458170.5880@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Tarkan Erimer <tarkan.erimer@f-secure.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:36254 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab2CMOaX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:30:23 -0400
In-Reply-To: <alpine.LNX.2.01.1203131458170.5880@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday, 13. March 2012 15:02:13 Jan Engelhardt wrote:
> > 1- Is netfilter subsystem multi-threaded/multi-core enabled ? So that,
> > it can spread the loads across the CPUs/Cores.
> 
> Like most kernel subsystems, it is.
> 
> > 2- Can it handle such loads consistently (without any
> > issues/bottlenecks) as I've mentioned above ?
> 
> Question is more like, can your hardware handle it.

On that note, Holger Eitzenberger's irqd might be worth a look:
https://github.com/vaesoo/irqd#readme

http://workshop.netfilter.org/2011/wiki/images/6/69/Nfws2011-multiqueue-and-rps.pdf

Thomas

-- 
Address (better: trap) for people I really don't want to get mail from:
hubert.farnsworth@cactusamerica.com
