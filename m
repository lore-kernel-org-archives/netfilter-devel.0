From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd [ERROR] commit: Invalid argument
Date: Fri, 08 Aug 2008 10:27:19 +0200
Message-ID: <489C0367.1010408@netfilter.org>
References: <e1aa27e00806090621r3fa83ac0s7bb89d903de3be41@mail.gmail.com> <200806130122.16216.sabelka@iue.tuwien.ac.at> <4855B44B.5030504@netfilter.org> <200806162228.17436.sabelka@iue.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Marco Barbero <marco.barbero@gmail.com>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Rainer Sabelka <sabelka@iue.tuwien.ac.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55942 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754494AbYHHLhs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:37:48 -0400
In-Reply-To: <200806162228.17436.sabelka@iue.tuwien.ac.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Rainer,

Rainer Sabelka wrote:
> Thanks Pablo. I've tested your patches but unfortunately I still get "Cannot 
> allocate memory" sometimes.
> 
> Jun 16 22:24:45 fw1b conntrack-tools[5599]: committing external cache
> Jun 16 22:24:45 fw1b conntrack-tools[5599]: commit-create: Cannot allocate 
> memory
> Jun 16 22:24:45 fw1b conntrack-tools[5599]: Committed 623 new entries
> Jun 16 22:24:45 fw1b conntrack-tools[5599]: 1 entries can't be committed

Sorry for the late reply. The problem seems to be in the kernel side. It
was introduced in 2.6.23. I have posted a patch that fixes it [1]. It
applies to 2.6.27-rc but it should be easy to backport it.

[1] http://marc.info/?l=netfilter-devel&m=121812264402131&w=2

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
