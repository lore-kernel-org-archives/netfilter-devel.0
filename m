From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Wed, 23 Jul 2008 18:38:30 +0100
Message-ID: <48876C96.2070405@gmx.ch>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org> <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch> <4884B270.5010104@trash.net> <4884CC17.3020905@gmx.ch> <488740E7.3040005@gmx.ch> <48874272.1020503@trash.net> <48875887.8040209@gmx.ch> <488763F3.5020506@trash.net> <4887656B.1090504@trash.net> <48876AAA.9020609@gmx.ch> <48876B48.4060605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44576 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751089AbYGWRic (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:38:32 -0400
In-Reply-To: <48876B48.4060605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Fabian Hugelshofer wrote:
>> Why do you think the padding causes problems? For hashing e.g. src/dst 
>> .u3 and .u are referenced independently of potential padding. Where 
>> does access to the padding data occur?
> 
> The hash function hashes the entire tuple in one go.
> The padding needs to have deterministic content for
> that.

Ok, I see. This has been changed since 2.6.24. Makes sense...
