From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCHv5 2/2] Addrtype match: limit address type checking to
 an interface
Date: Mon, 26 Nov 2007 09:11:09 +0100
Message-ID: <474A7F9D.6070002@trash.net>
References: <11955456442652-git-send-email-panther@balabit.hu> <11955456451525-git-send-email-panther@balabit.hu> <11955456453362-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48681 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbXKZIL4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:11:56 -0500
In-Reply-To: <11955456453362-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Laszlo Attila Toth wrote:
> Addrtype match has a new revision (1), which lets address type checking
> limited to the interface the current packet belongs to. Either incoming
> or outgoing interface can be used depending on the current hook. In the
> FORWARD hook two maches should be used if both interfaces have to be checked.
> The new structure is ipt_addrtype_info_v1.
> 
> Revision 0 lets older userspace programs use the match as earlier.
> ipt_addrtype_info is used.


I only applied this to spare you a sixth resend, it had overly long
lines as well and added a useless module alias for the same name.
Anyway, I've fixed up a basically 100% reject with Jan's renaming
patch and applied it.

I still don't like the way the interface is specified very much,
mainly the fact that with the interface limitation you can't
reasonable match on both source and destination type anymore,
so I might change this.

