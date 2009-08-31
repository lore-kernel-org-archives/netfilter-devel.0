From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: initial (im)port of ipt_ACCOUNT, ipt_pknock and ipt_stealth to
 xtables-addons-1.17
Date: Mon, 31 Aug 2009 17:39:43 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908311731020.11966@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.2.00.0908262011580.20390@cedric.unob.cz> <200908311727.26512.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>,
	netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60382 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZHaPjm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:39:42 -0400
In-Reply-To: <200908311727.26512.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2009-08-31 17:27, Thomas Jarosch wrote:

>Hello Jan Rafaj,
>
>On Thursday, 27. August 2009 17:53:33 Jan Rafaj wrote:
>> - files have all been renamed from {lib,}ipt_* to {lib,}xt_*
>>    (I know, they are still IPv4-only projects, but thats the policy
>>    of Xt-a)
>
>Thanks for your effort.
>
>ipt_ACCOUNT is IPv4 only. Giving it a name of xt_ACCOUNT
>will give the impression it works for IPv6, right?

"What's in a name"

Users should not look at names to see what what can be used with. 
xt_osf, xt_TPROXY and xt_socket have no v6 mode either (besides recent 
submissions). ipt_ and so on have been remnants from before 
x_tables.c was added around 2.6.17.

