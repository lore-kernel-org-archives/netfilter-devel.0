From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] Expose x_tables /proc entries as 0444 not 0440
Date: Wed, 11 Nov 2015 19:48:11 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1511111945170.32360@nerf40.vanv.qr>
References: <20151107074939.GA4003@compaq.slightly-cracked.com> <20151111165026.GA20549@salvia> <20151111184052.GA26909@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Philip Whineray <phil@firehol.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:46223 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbbKKSsM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2015 13:48:12 -0500
In-Reply-To: <20151111184052.GA26909@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2015-11-11 19:40, Florian Westphal wrote:
>Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > Hiding the contents from non-root users does not achieve anything
>> > practical. Possible values are well-known and the specifics can
>> > be inferred from a list of loaded modules on most systems.

Conversely, an administrator could just load all modules to give a false 
impression. Since the adversary can in turn expect it, he knows as 
little as before. In particular, containerized environments will have it 
such that many modules are loaded, but each container still has their 
own ruleset.
So yeah, hiding the contents is not going to achieve anything - nor is 
showing. (I am concurring here with the other respondents.)
