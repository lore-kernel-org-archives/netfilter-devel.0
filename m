From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: doc: escape minus sign in manpages
Date: Fri, 16 Jan 2009 09:19:39 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901160918150.22357@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901090313110.16418@fbirervta.pbzchgretzou.qr> <496A9E8A.10405@netfilter.org> <alpine.LSU.2.00.0901120339080.20867@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0901120706460.21692@fbirervta.pbzchgretzou.qr> <496AE148.6000909@trash.net>
 <alpine.LSU.2.00.0901140645040.29956@fbirervta.pbzchgretzou.qr> <49703FCD.9020205@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52013 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZAPITk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:19:40 -0500
In-Reply-To: <49703FCD.9020205@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-01-16 09:05, Patrick McHardy wrote:
>>>> doc: escape minus sign in manpage (2)
>>> Something in this patch seems to be confusing "patch":
>>>
>>> patching file ip6tables.8.in
>>> patching file iptables.8.in
>>> Hunk #1 FAILED at 23.
>>> 1 out of 1 hunk FAILED -- saving rejects to file iptables.8.in.rej
>>
>> Hm... but format/flowed is disabled already.
>
> It doesn't apply nevertheless. Just send it over gzipped, that will
> hopefully keep it intact.
>
I have a better idea...!

Please pull from
	git://dev.medozas.de/iptables master

to receive:
Jan Engelhardt (2):
      doc: escape minus sign in manpage (2)
      doc: augment ICMP manpage by type/code syntax

(Both have been posted already, so allow me to skip the diff here.)
