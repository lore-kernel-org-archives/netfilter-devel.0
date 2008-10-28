From: Greg KH <gregkh@suse.de>
Subject: Re: netfilter 00/03: netfilter -stable fixes
Date: Mon, 27 Oct 2008 19:45:29 -0700
Message-ID: <20081028024529.GA17128@suse.de>
References: <20081022174126.21341.38231.sendpatchset@x2.localnet> <alpine.LNX.1.10.0810240229550.4386@bizon.gios.gov.pl> <49014390.7080909@trash.net> <alpine.LNX.1.10.0810280311030.15543@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@kernel.org, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbYJ1DV4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Oct 2008 23:21:56 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0810280311030.15543@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 28, 2008 at 03:13:32AM +0100, Krzysztof Oledzki wrote:
>
>
> On Fri, 24 Oct 2008, Patrick McHardy wrote:
>
>> Krzysztof Oledzki wrote:
>>> On Wed, 22 Oct 2008, Patrick McHardy wrote:
>>>> The following three patches for -stable fix some netfilter issues:
>>>> - a regression in the iprange match, causing mismatches with inversion
>>>> - a memory leak in the SNMP NAT helper
>>>> - a lost #ifdef, allowing user-triggerable WARN_ONs with NETFILTER_DEBUG
>>>>  (and some minor runtime misbehaviour)
>>> Which kernels need above patches? Only 2.6.27 or also 2.6.25/2.6.26?
>>
>> I think all three patches are also needed for 2.6.25 and 2.6.26.
>
> Thank you for the confirmation.
>
> Greg, could you please put above patches info queue-2.6.25/queue-2.6.26?

Will do, thanks.

greg k-h
