From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][libnetfilter_conntrack] add support for explicit helper
 assignment
Date: Fri, 10 Oct 2008 15:02:07 +0200
Message-ID: <48EF524F.7070705@trash.net>
References: <48EDDE81.9070606@netfilter.org> <alpine.LNX.1.10.0810091814490.13257@bizon.gios.gov.pl> <48EE386A.1010602@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53898 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbYJJNCL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:02:11 -0400
In-Reply-To: <48EE386A.1010602@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Krzysztof Oledzki wrote:
>> Any chances to make it more frendly to new helpers and compatible with
>> out-of-tree helpers by registering a name directly from a helper and
>> using it? We may for example introduce something like /proc/net/nf_helpers.
> 
> We may directly set the name of the helper using the string that
> identifies it instead of this id. However, this means more memory
> consumption but more flexibility. I have another patch here that uses
> strings to do so. The problem is that helpers doesn't have a limitation
> in the name length and I don't like the idea of having a field
> "helper_name" with variable length inside the nf_conntrack object. We
> could make some reasonable assumptions, like considering that the helper
> name would not be larger than 32 bytes.

Limiting the name makes sense. The helper match can only match
on I think 16 bytes, and that seems big enough.
