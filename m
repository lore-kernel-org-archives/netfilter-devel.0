From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables version defines
Date: Fri, 30 May 2008 12:53:49 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805301246450.11875@fbirervta.pbzchgretzou.qr>
References: <200805301016.03130.thomas.jarosch@intra2net.com> <Pine.LNX.4.64.0805301140430.14733@bizon.gios.gov.pl> <Pine.LNX.4.64.0805301155550.16963@bizon.gios.gov.pl> <200805301206.45428.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Krzysztof Oledzki <ole@ans.pl>, netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57012 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbYE3Kxv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 May 2008 06:53:51 -0400
In-Reply-To: <200805301206.45428.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-05-30 12:06, Thomas Jarosch wrote:
>Hi Krzysztof,
>
>On Friday, 30. May 2008 11:56:28 you wrote:
>> > #ifdef _XTABLES_H
>> > init(struct xt_entry_target *t)
>> > #else
>> > init(struct ipt_entry_target *t, unsigned int *nfcache)
>> > #endif

Woah this is ridiculously ugly. (Remember, such constructs were
just eliminated from the kernel in the past years.)

There is Xtables-addons which provides enough glue so that there is no reason
to play dirty preprocessor tricks like these. xt-a uses a technique where an
extra backwards-API layer is in place that translates the API (mostly
parameter shuffling, etc) in an IMHO perfect fashion.

That's for the kernel part; the same applies to the iptables glue --
of which there is not any yet, because 1.4.0.77 is the minimum required
version because of the newly exported xtables.h, and I had to start
*somewhere*. My suggestion that you follow up on it ;-)
