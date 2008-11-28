From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter 15/29: nf_conntrack: connection tracking helper name
 persistent aliases
Date: Fri, 28 Nov 2008 08:15:25 +0100
Message-ID: <492F9A8D.90709@trash.net>
References: <20081127161503.13891.62766.sendpatchset@x2.localnet> <20081127161523.13891.6192.sendpatchset@x2.localnet> <alpine.LNX.1.10.0811271930061.21626@fbirervta.pbzchgretzou.qr> <492EE7FB.6020905@trash.net> <alpine.LNX.1.10.0811271933580.22601@fbirervta.pbzchgretzou.qr> <492F16AC.10801@netfilter.org> <alpine.LNX.1.10.0811272313330.23969@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36588 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbYK1HP1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Nov 2008 02:15:27 -0500
In-Reply-To: <alpine.LNX.1.10.0811272313330.23969@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2008-11-27 22:52, Pablo Neira Ayuso wrote:
>>> I wonder a bit. iptables is fine with loading ipt_%s (mapped to xt_%s),
>>> but conntrack requires an nfct-help-%s namespace and cannot use
>>> nf_conntrack_%s?
>>> Of course it makes sense to use a separate namespace - especially
>>> in light of the nf_conntrack_ prefix used by both helpers and
>>> protos, but I'm still asking.
>> It is not the same point. The xt_* aliases in iptables were introduced
>> to keep backward compatibility for iptables (old versions try to load
>> ipt_* or ip6t_* modules, as they don't know anything about xt_*. Of
>> course, this is no longer true for current iptables versions).
> 
> Sadly enough, iptables still loads ipt_%s instead of xt_%s.
> Maybe it's time for a patch..

Its needed to select the proper module, f.i. in case of REJECT.

