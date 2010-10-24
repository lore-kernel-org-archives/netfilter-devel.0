From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Moving modified packets between processes
Date: Sun, 24 Oct 2010 13:31:47 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010241325410.23809@obet.zrqbmnf.qr>
References: <AANLkTincYmY4rALnsTTy=K32e7s1crw1nc=gBDHyjj58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kfir Lavi <lavi.kfir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45564 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448Ab0JXLbt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 07:31:49 -0400
In-Reply-To: <AANLkTincYmY4rALnsTTy=K32e7s1crw1nc=gBDHyjj58@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-10-24 10:54, Kfir Lavi wrote:

>I will need to move Ethernet, ARP and IP packets.
>What are my options regarding moving the packet modified with new
>custom header from one process to another process?

http://en.wikipedia.org/wiki/Inter-process_communication lists ways of 
transferring data between programs.
