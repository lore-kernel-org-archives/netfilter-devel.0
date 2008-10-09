From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH][libnetfilter_conntrack] add support for explicit helper
 assignment
Date: Thu, 9 Oct 2008 16:30:55 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810091630400.19777@fbirervta.pbzchgretzou.qr>
References: <48EDDE81.9070606@netfilter.org> <alpine.LNX.1.10.0810091814490.13257@bizon.gios.gov.pl> <48EE386A.1010602@netfilter.org> <alpine.LNX.1.10.0810091911240.26944@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56514 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbYJIUa5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 16:30:57 -0400
In-Reply-To: <alpine.LNX.1.10.0810091911240.26944@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-10-09 13:15, Krzysztof Oledzki wrote:
>
>> Using this patch, the new helpers would need a new version of the
>> library as you have said. However, the argument of supporting
>> out-of-tree helpers doesn't convince me, what out-of-tree helpers are
>> you refering to?
>
> nf_conntrack_rtsp for example
>
And whatever is lingering in crapomatic, eh? ;-)
