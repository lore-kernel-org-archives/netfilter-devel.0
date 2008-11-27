From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netfilter 15/29: nf_conntrack: connection tracking helper name
 persistent aliases
Date: Thu, 27 Nov 2008 22:52:44 +0100
Message-ID: <492F16AC.10801@netfilter.org>
References: <20081127161503.13891.62766.sendpatchset@x2.localnet> <20081127161523.13891.6192.sendpatchset@x2.localnet> <alpine.LNX.1.10.0811271930061.21626@fbirervta.pbzchgretzou.qr> <492EE7FB.6020905@trash.net> <alpine.LNX.1.10.0811271933580.22601@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58798 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753648AbYK0Vw7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2008 16:52:59 -0500
In-Reply-To: <alpine.LNX.1.10.0811271933580.22601@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> [cc morphed to more interested parties]
> 
> On Thursday 2008-11-27 19:33, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> On Thursday 2008-11-27 17:15, Patrick McHardy wrote:
>>>>    
>>>>    This patch adds the macro MODULE_ALIAS_NFCT_HELPER that defines a
>>>>    way to provide generic and persistent aliases for the connection
>>>>    tracking helpers.
>>> I wonder a bit. iptables is fine with loading ipt_%s (mapped to xt_%s),
>>> but conntrack requires an nfct-help-%s namespace and cannot use
>>> nf_conntrack_%s?
>>> Of course it makes sense to use a separate namespace - especially
>>> in light of the nf_conntrack_ prefix used by both helpers and
>>> protos, but I'm still asking.

It is not the same point. The xt_* aliases in iptables were introduced
to keep backward compatibility for iptables (old versions try to load
ipt_* or ip6t_* modules, as they don't know anything about xt_*. Of
course, this is no longer true for current iptables versions).

The reason why I introduced the nfct-help aliases is to avoid a change
in every request_module() invocation if we ever rename the helper files
to something like nf_conntrack_helper_*.c or whatever. If that happens
at some point, we will only have to change the MODULE_ALIAS_NFCT_HELPER
macro to point to the new name-space. This looks much cleaner to me.

>> Please CC the people that can actually answer this question.
>>
> Please set CC when running git-send-email :)

Burp!

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
