From: Scott Feldman <scofeldm@cisco.com>
Subject: Re: [PATCH] Update jhash.h with the new version of Jenkins' hash
Date: Tue, 10 Feb 2009 13:19:55 -0800
Message-ID: <4991EF7B.90004@cisco.com>
References: <alpine.DEB.2.00.0902102026060.10299@blackhole.kfki.hu>
Reply-To: scofeldm@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:32963 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbZBJVT5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:19:57 -0500
In-Reply-To: <alpine.DEB.2.00.0902102026060.10299@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> The patch replaces the lookup2() implementation of the 'jhash*' 
> functions with that of lookup3().

Should the lookup3() be added to rather than replacing lookup2()?  In 
case some hardware vendor used the lookup2() version for weird things 
like flow classification.

>  /* The golden ration: an arbitrary value */
> -#define JHASH_GOLDEN_RATIO	0x9e3779b9
> +#define JHASH_GOLDEN_RATIO	0xdeadbeef

The #define seems mis-named now.

-scott
