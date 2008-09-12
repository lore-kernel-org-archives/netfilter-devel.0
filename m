From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ULOGD2 PATCH 2/3] Make NFLOG and NFCT build conditionnal
Date: Thu, 11 Sep 2008 22:39:33 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809112238520.17877@fbirervta.pbzchgretzou.qr>
References: <1221166085-23435-3-git-send-email-eric@inl.fr> <48C99429.2020406@netfilter.org> <20080911221504.GC20985@ice-age>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40663 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbYILCjf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 22:39:35 -0400
In-Reply-To: <20080911221504.GC20985@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-09-11 18:15, Eric Leblond wrote:
>Hello,
>On Thursday, 2008 September 11 at 23:56:57 +0200, Pablo Neira Ayuso wrote:
>> Eric Leblond wrote:
>> > This patch modifies the build system behaviour to be able to compile
>> > ulogd on system without recent release of libnetfilter library. If
>> > a library is absent or too old, it will simply not compile the concerned
>> > input module.
>> 
>> I don't see any gain from this patch. We had this sort of conditional
>> compilation in iptables - that we finally removed - and it was source of
>> user-side problems.
>
>Hmm, even if you think autodetection is a mistake, it is useful to
>be able to compile ulogd on system where NFLOG or NFCT is not installed
>or not usable (too old kernel).

That's just what iptables does. It ships the necessary header files
to compile even if things are not present in the kernel.
...And then autodetection becomes useless.
