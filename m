From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: netfilter: ipset: use nla_parse_nested()
Date: Wed, 02 Feb 2011 07:42:16 +0100
Message-ID: <4D48FCC8.60706@trash.net>
References: <4D4826E6.2050200@trash.net> <alpine.DEB.2.00.1102012034140.24267@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61016 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1BBGm3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 01:42:29 -0500
In-Reply-To: <alpine.DEB.2.00.1102012034140.24267@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01.02.2011 21:10, Jozsef Kadlecsik wrote:
> On Tue, 1 Feb 2011, Patrick McHardy wrote:
> 
>> I'll be sending a few cleanup patches, I'm already committing them
>> to my tree, just NACK the ones you think are wrong and I'll back
>> them out again.
> 
> It's cool, thanks! Your patches 01-03 are OK, I applied them to my tree.

Thanks, I've pushed them out in my tree and will include them in the
submission to Dave.
