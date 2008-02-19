From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv5 2/5] Adds AF_BRIDGE and ARP header interpreter to  
    BASE plugin
Date: Tue, 19 Feb 2008 01:58:30 +0100
Message-ID: <47BA29B6.8040609@netfilter.org>
References: <20080211220753.796791654@endian.com>    <20080211221056.242019648@endian.com> <47B377A2.6080309@endian.com> <4279.80.214.249.17.1202974766.squirrel@mail.inl.fr> <47B42760.5080603@endian.com> <47B45D0F.8070008@netfilter.org> <47B5CB03.2070903@endian.com> <47B5CE66.4090107@endian.com> <47B62D7A.3010906@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47556 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751022AbYBSA6h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:58:37 -0500
In-Reply-To: <47B62D7A.3010906@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Warasin wrote:
> Ok, now it is fixed and works for me
> Made some confusion because i changed that type.
> Please don't slap me :)

Finally applied.

> During tests i found another bug in IP2STR. The for loop goes only
> until MAX_KEY-1, but should include MAX_KEY otherwise it will not print
> out the last key (in this case the destination ip address of the arp
> packet).
> 
> It clashes with my patch 4, so i will resend that patch, too,
> including the bugfix.

OK, wait for that patch. Thanks Peter.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
