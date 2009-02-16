From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024  entries,
 dropping packets(s). Dropped: 582) - bug or just some defaults  increase
 required?
Date: Mon, 16 Feb 2009 14:42:33 +0100
Message-ID: <49996D49.9050606@netfilter.org>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com> <200902121545.16590.anton.vazir@gmail.com> <4996FBBE.20009@netfilter.org> <200902161819.27630.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59366 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756829AbZBPNiA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:38:00 -0500
In-Reply-To: <200902161819.27630.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anton wrote:
> The code for full application is quite a big and overloaded 
> with extra functionality like threading, database 
> connectivity and so on. We'll try to make a simple 
> emulation app to trigger the case and i'll send it.

Threading is the point that I wanted to hear. Are you creating those 
queues inside threads? The queue creation path is not thread-safe and it 
  requires mutex.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
