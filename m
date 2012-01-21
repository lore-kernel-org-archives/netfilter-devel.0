From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables2 a8, netlink interface
Date: Sat, 21 Jan 2012 16:53:15 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1201211645300.28799@frira.zrqbmnf.qr>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de> <alpine.DEB.2.00.1201201422230.11124@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44348 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab2AUPxR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jan 2012 10:53:17 -0500
In-Reply-To: <alpine.DEB.2.00.1201201422230.11124@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2012-01-21 15:10, Jozsef Kadlecsik wrote:

>Hi Jan,
>
>On Thu, 19 Jan 2012, Jan Engelhardt wrote:
>
>> So here is the first set of patches implementing part of the xt2 core
>> and nfnl interface. Please review, I am sure you will have something
>> to say :)
>
>At a first glance I must say it looks very promising. Good job!
>What seems to be missing is some kind of protocol version negotiation 
>support between kernel and userspace. Or it'll come in the next batch of 
>patches? :-)

Can be an attribute returned with NFXTM_IDENTIFY messages.
But I had not really given thought to that (ipset is also still at protocol 
6, so..)
