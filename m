From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: nf_conntrack: log packets dropped by helpers
Date: Wed, 26 Aug 2009 15:20:27 +0200
Message-ID: <4A95369B.10404@trash.net>
References: <4A93D817.4080706@trash.net> <4A94073B.80106@plouf.fr.eu.org> <4A9530C1.50200@trash.net> <alpine.LSU.2.00.0908261503340.32385@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40702 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbZHZNU1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:20:27 -0400
In-Reply-To: <alpine.LSU.2.00.0908261503340.32385@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2009-08-26 14:55, Patrick McHardy wrote:
> 
>> Pascal Hambourg wrote:
>>> Hello,
>>>
>>> May I ask what are the reasons for a helper to drop packets ?
>> Mainly parsing errors, memory allocation errors and bugs.
> 
> I am not so quite sure whether parsing errors (like, a port > 65535 for 
> FTP) should cause them to be dropped; after all, it might be, for 
> example, a vendor-specific form of a protocol that just does not fit the 
> nf_conntrack_ftp parsing exactly. That is to say, packets should be let 
> through, though without setting up expectations.

Thats what usually happens. There are a few exceptions though, most
notably the SIP helper, which drops packets since they might already
have been mangled.
