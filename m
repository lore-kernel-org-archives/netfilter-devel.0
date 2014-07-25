From: Patrick McHardy <kaber@trash.net>
Subject: Re: [linux PATCH v3 0/5] NAT updates for nf_tables
Date: Fri, 25 Jul 2014 17:54:54 +0100
Message-ID: <8d6bafc8-7615-4ee8-a8da-69aa57e60c4f@email.android.com>
References: <20140701162801.2847.14389.stgit@nfdev.cica.es> <20140725164806.GA22375@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57068 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbaGYQzF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:55:05 -0400
In-Reply-To: <20140725164806.GA22375@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25. Juli 2014 17:48:06 GMT+01:00, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>Hi Patrick,
>
>Would you be OK if we push this patchset into mainstream? I think we
>can investigate the fetch interface address and store in register
>approach that you proposed to implement masquerading later on. The
>missing bits are the conntrack cleanup routine, I think that needs
>some "scratchpad" area to store the last address/interface that have
>been used. We can probably revisit this later once that generic state
>infrastructure for nf_tables (to support stateful expressions in some
>generic way) is in place?

Not sure right now about the specifics, I'm out of order until my notebook has been repaired.

>If you don't like the idea, please let me know, and I'll defer this
>masquerading patchset.
>
>Thanks!

Sure, please go ahead.




