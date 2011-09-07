From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: install nf_nat.h and related headers to INSTALL_HDR_PATH
Date: Wed, 07 Sep 2011 16:50:43 +0200
Message-ID: <4E6784C3.70906@trash.net>
References: <1315075784-10163-1-git-send-email-basile@opensource.dyc.edu> <20110905174847.GB32733@1984> <4E664E05.4090907@opensource.dyc.edu> <alpine.LNX.2.01.1109062001450.19110@frira.zrqbmnf.qr> <20110907093104.GA9078@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	"Anthony G. Basile" <basile@opensource.dyc.edu>,
	davem@davemloft.net, blueness@gentoo.org, gurligebis@gentoo.org,
	base-system@gentoo.org, kernel@gentoo.org, toolchain@gentoo.org,
	mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62315 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab1IGQqa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:46:30 -0400
In-Reply-To: <20110907093104.GA9078@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.09.2011 11:31, Pablo Neira Ayuso wrote:
> On Tue, Sep 06, 2011 at 08:11:30PM +0200, Jan Engelhardt wrote:
>>
>> On Tuesday 2011-09-06 18:44, Anthony G. Basile wrote:
>>>>
>>>> Could anyone clarify why miniupnpd (or any other application) require
>>>> this?
>>>>
>>>> Those headers contain structure layouts that may change along time
>>>> without further notice, thus breaking backward compatibility.
>>>
>>> It makes use of
>>>
>>>   union nf_conntrack_man_proto
>>>   struct nf_nat_range
>>>   struct nf_nat_multi_range_compat
>>
>> miniupnpd is fiddling with the binary representation. Yes, classic
>> case of "all the xt headers are exported, just DNAT/SNAT's structs are not".
>>
>> Did miniupnpd consider using the text-based interface?
> 
> The iptables NAT targets are using this binary representation, so we
> should export those definitions. We gain nothing from keeping them
> defined privately.
> 

Agreed.
