From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter: nf_conntrack: log packets dropped by helpers
Date: Wed, 26 Aug 2009 15:04:50 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908261503340.32385@fbirervta.pbzchgretzou.qr>
References: <4A93D817.4080706@trash.net> <4A94073B.80106@plouf.fr.eu.org> <4A9530C1.50200@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56288 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963AbZHZNEt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:04:49 -0400
In-Reply-To: <4A9530C1.50200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-08-26 14:55, Patrick McHardy wrote:

>Pascal Hambourg wrote:
>> Hello,
>> 
>> May I ask what are the reasons for a helper to drop packets ?
>
>Mainly parsing errors, memory allocation errors and bugs.

I am not so quite sure whether parsing errors (like, a port > 65535 for 
FTP) should cause them to be dropped; after all, it might be, for 
example, a vendor-specific form of a protocol that just does not fit the 
nf_conntrack_ftp parsing exactly. That is to say, packets should be let 
through, though without setting up expectations.
