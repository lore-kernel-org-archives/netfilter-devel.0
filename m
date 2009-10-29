From: Patrick McHardy <kaber@trash.net>
Subject: Re: resend your pending patches, please
Date: Thu, 29 Oct 2009 17:02:19 +0100
Message-ID: <4AE9BC8B.2070303@trash.net>
References: <4AE6FD76.40705@netfilter.org> <4AE6FDB5.4060500@netfilter.org> <4AE866F9.5040503@trash.net> <4AE96F11.103@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, jkosina@suse.cz,
	"David S. Miller" <davem@davemloft.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53694 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZJ2QCV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:02:21 -0400
In-Reply-To: <4AE96F11.103@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Thanks for taking care of this.
> 
> ;-)
> 
>> I'm working through my backlog, I'll simply start pickup all patches
>> that are not in your tree yet, unless you want me to submit those as
>> well.
> 
> Please, submit those in my tree yourself if you want.

OK, I already have the NAT fix queued, but will wait with the
NF_CT_ACCT patch until Krzysztof sends the final version that
will take care of automatically enabling accounting when the
connbytes match is used.
