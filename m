From: Sergei Zhirikov <sfzhi@yahoo.com>
Subject: Re: [PATCH] netfilter: LED: fix man page fragment inclusion
Date: Sat, 3 Jul 2010 03:31:52 -0700 (PDT)
Message-ID: <684658.18910.qm@web112308.mail.gq1.yahoo.com>
References: <4C2D98F4.5050602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web112308.mail.gq1.yahoo.com ([98.137.26.148]:29377 "HELO
	web112308.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754844Ab0GCKic (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Jul 2010 06:38:32 -0400
In-Reply-To: <4C2D98F4.5050602@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

No, it was the correct patch. The Makefile looks for NFPROTO_UNSPEC in the source file in order to decide whether the manpage fragment should be included.

--- On Fri, 7/2/10, Patrick McHardy <kaber@trash.net> wrote:

> From: Patrick McHardy <kaber@trash.net>
> Subject: Re: [PATCH] netfilter: LED: fix man page fragment inclusion
> To: "Sergei Zhirikov" <sfzhi@yahoo.com>
> Cc: netfilter-devel@vger.kernel.org
> Date: Friday, July 2, 2010, 9:44 AM
> Sergei Zhirikov wrote:
> > The man page fragment of the recently added LED target
> does not get included into iptables.8 and ip6tables.8
> produced during build. This patch fixes that.
> 
> You seem to have attached a different patch, please
> resend.
> 


