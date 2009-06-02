From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: [RFD,patch] ICMP echo conntrack timeout
Date: Tue, 2 Jun 2009 14:47:21 +0200
Message-ID: <20090602124721.GC3205@fi.muni.cz>
References: <20090601174352.GH31797@fi.muni.cz> <4A251127.8000605@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from minas.ics.muni.cz ([147.251.4.40]:51315 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZFBMr0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:47:26 -0400
Content-Disposition: inline
In-Reply-To: <4A251127.8000605@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
: The only problem that I see is that you patch relaxes the current
: checking that we're doing. I mean, for every packet in one direction we
: only accept one ICMP reply packet. With your patch, we can accept more
: than one packet in the reply direction.

	I think it is perfectly legal, as we _want_ to se the duplicates,
if there are any.

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
>> If we wanted to trade simplicity and kewl design for usability I think <<
>> we all know the URL of the Apple Store.               --jmorris42 @LWN <<
