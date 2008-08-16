From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't
 work
Date: Sat, 16 Aug 2008 19:59:18 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808161958431.27260@fbirervta.pbzchgretzou.qr>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>  <48A5CEFE.5090407@netfilter.org>  <alpine.LNX.1.10.0808151633500.10478@fbirervta.pbzchgretzou.qr>  <Pine.LNX.4.64.0808152243280.20098@blackhole.kfki.hu>
 <alpine.LNX.1.10.0808151743310.10478@fbirervta.pbzchgretzou.qr>  <Pine.LNX.4.64.0808160037390.20328@blackhole.kfki.hu>  <412e6f7f0808151738k3b03cafax900b01f45726051e@mail.gmail.com>  <Pine.LNX.4.64.0808161947450.20963@blackhole.kfki.hu>
 <412e6f7f0808161648g428b0717u237afb6a7c2874b8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44041 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbYHPX7U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2008 19:59:20 -0400
In-Reply-To: <412e6f7f0808161648g428b0717u237afb6a7c2874b8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2008-08-16 19:48, Changli Gao wrote:
>>
>>> > But as the ECN options has not been documented so far, I think it'd be
>>> > better to rename them at the same time to something like
>>> >
>>> > --ecn-tcp-cwr-remove
>>> > --ecn-tcp-ece-remove
>>> > --ecn-ip-ect-set
>>> >
>>> > and clashing with the ecn options were resolved.
>>>
>>> It sounds a good idae. But in order to avoid clashing, we'd better
>>> change all the options for all matches in this way:
>>>
>>> match: foo
>>> match-options: --foo-bar
>>
>> I think changing the existing clashing option names (with keeping the old
>> ones for backward compatibility) is just enough - we can use the "rule"
>> above for future new matches.
>
>Well, If so, we'd better make this rule well documented to let more
>people know the issue we talked here if they don't obey it.

I would not make this a hard requirement. (NAKing the NAK.)
