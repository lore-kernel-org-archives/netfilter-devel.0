From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Missing kernel header files
Date: Fri, 1 Oct 2010 23:09:09 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010012248410.24065@obet.zrqbmnf.qr>
References: <AANLkTinPD=3yC=KF_juTvUumXwmuMzgjrXyRg4NmML-C@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: David Corrales <corrales.david@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58002 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab0JAVJL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Oct 2010 17:09:11 -0400
In-Reply-To: <AANLkTinPD=3yC=KF_juTvUumXwmuMzgjrXyRg4NmML-C@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-09-30 22:51, David Corrales wrote:

>Hi everyone,
>
>Recently I ran across some issues when compiling iptables 1.2.9
>against kernel 2.6.24.

Choosing arbitrary kernels is not designed to work before 1.4.3.

>I recon that the iptables version is rather old but I was wondering if
>it possible to patch it in order to compile with the upgrades.

Why bother with patching when just using 1.4.9 yields equivalent 
behavior?
