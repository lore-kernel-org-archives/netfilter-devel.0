From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] Release conntrack-tools 0.9.6
Date: Tue, 11 Mar 2008 12:30:57 +0100
Message-ID: <47D66D71.8090200@netfilter.org>
References: <47D28F29.6080707@netfilter.org> <Pine.LNX.4.64.0803092018460.24925@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48538 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752524AbYCKLbF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Mar 2008 07:31:05 -0400
In-Reply-To: <Pine.LNX.4.64.0803092018460.24925@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> On Sat, 8 Mar 2008, Pablo Neira Ayuso wrote:
>> The netfilter project proudly presents another development release of
>> the conntrack-tools. This release includes important improvements, new
>> features and bugfixes:
> 
> <CUT>
> 
> I attached two patches to fix two warnings about shadowed declarations.

Applied. Thanks.

> BTW: It seems there is somethig wrong with --dst-nat/--src-nat filtering:
> 
> # conntrack -L --src-nat|wc -l;conntrack -L --src-nat=1.2.3.4|wc
> -l;conntrack -L --src-nat=244.244.244.244|wc -l
> 5010
> 5010
> 5010
> 
> If I understand it properly "conntrack -L --src-nat=A.B.C.D" is supposed
> to show only connections snated to A.B.C.D, but as you can see it
> ignores this parameter and shows all snated connections.
> 
> From the other hand --dst-nat works in exactly opposite way: it filters
> out all connections, even matching ones.

Will investigate. I'd appreciate a patch for this.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
