From: "Eric Leblond" <eric@inl.fr>
Subject: Re: [PATCHv2 2/5] Adds AF_BRIDGE and ARP header interpreter to
     BASE plugin
Date: Thu, 14 Feb 2008 08:39:26 +0100 (CET)
Message-ID: <4279.80.214.249.17.1202974766.squirrel@mail.inl.fr>
References: <20080211220753.796791654@endian.com>
    <20080211221056.242019648@endian.com> <47B377A2.6080309@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org
To: "Peter Warasin" <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:60592 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757585AbYBNHj1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:39:27 -0500
In-Reply-To: <47B377A2.6080309@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

> Hi guys
>
> Fixed the type for  KEY_ARP_SPA and KEY_ARP_TPA,
> as Eric mentioned.

I did not drink cofee this morning, and thus I may be wrong, but it seems
you've sent the same patch as yesterday. KEY_ARP_SPA is still of type RAW
for example. The other patch seems also unchanged.

BR,
--
Eric

