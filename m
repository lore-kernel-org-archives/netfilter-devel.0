From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter 15/29: nf_conntrack: connection tracking helper name
 persistent aliases
Date: Thu, 27 Nov 2008 19:34:28 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811271933580.22601@fbirervta.pbzchgretzou.qr>
References: <20081127161503.13891.62766.sendpatchset@x2.localnet> <20081127161523.13891.6192.sendpatchset@x2.localnet> <alpine.LNX.1.10.0811271930061.21626@fbirervta.pbzchgretzou.qr> <492EE7FB.6020905@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, pablo@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33134 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYK0Se3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2008 13:34:29 -0500
In-Reply-To: <492EE7FB.6020905@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[cc morphed to more interested parties]

On Thursday 2008-11-27 19:33, Patrick McHardy wrote:

> Jan Engelhardt wrote:
>> On Thursday 2008-11-27 17:15, Patrick McHardy wrote:
>> >    
>> >    This patch adds the macro MODULE_ALIAS_NFCT_HELPER that defines a
>> >    way to provide generic and persistent aliases for the connection
>> >    tracking helpers.
>> 
>> I wonder a bit. iptables is fine with loading ipt_%s (mapped to xt_%s),
>> but conntrack requires an nfct-help-%s namespace and cannot use
>> nf_conntrack_%s?
>> Of course it makes sense to use a separate namespace - especially
>> in light of the nf_conntrack_ prefix used by both helpers and
>> protos, but I'm still asking.
>>
>
> Please CC the people that can actually answer this question.
>
Please set CC when running git-send-email :)
