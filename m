From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd [ERROR] commit: Invalid argument
Date: Thu, 12 Jun 2008 17:05:07 +0200
Message-ID: <48513B23.40706@netfilter.org>
References: <e1aa27e00806090621r3fa83ac0s7bb89d903de3be41@mail.gmail.com>	 <484FD25F.2010800@netfilter.org> <e1aa27e00806111111n7ca3c97en89b7b1b973b5b245@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Marco Barbero <marco.barbero@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51727 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751756AbYFLO4p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:56:45 -0400
In-Reply-To: <e1aa27e00806111111n7ca3c97en89b7b1b973b5b245@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Marco Barbero wrote:
> Thanks Pablo,
> Now I'm getting:
> 
> [Wed Jun 11 20:04:07 2008] (pid=9974) [notice] Committed 1179 new entries
> [Wed Jun 11 20:04:07 2008] (pid=9974) [notice] 1179 entries ignored,
> already exist
     ^^^
I'll fix this, the patch that I have sent (yet uncommitted to netfilter 
git) says "ignored" but it should say "updated" instead.

> [Wed Jun 11 20:04:07 2008] (pid=9974) [notice] 8 entries can't be committed
> [Wed Jun 11 20:04:07 2008] (pid=3012) [notice] resync with master table
> 
> 
> So it seems issue is now only on 8 entries
> 
> 4 entries with:
> [ERROR] commit-create: Invalid argument

Could you post the complete log message to check if the entry that we 
want to inject is malformed?

> and 4 entries with:
> [ERROR] commit-create: Cannot allocate memory

Could you also give a try to the kernel patch that I have sent to Rainer?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
