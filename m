From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Tue, 14 Dec 2010 04:46:47 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012140446020.19653@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu> <4D00C6A4.6090305@netfilter.org> <alpine.LNX.2.01.1012140257430.7384@obet.zrqbmnf.qr>
 <AANLkTikOeBAkGvPFUxw+FzHFZFNiaUzT7s7QxGcFgZtc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: James Nurmi <jdnurmi@qwe.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35320 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab0LNDqs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Dec 2010 22:46:48 -0500
In-Reply-To: <AANLkTikOeBAkGvPFUxw+FzHFZFNiaUzT7s7QxGcFgZtc@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-12-14 03:16, James Nurmi wrote:
>On Mon, Dec 13, 2010 at 6:01 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>>
>> Normally, the sequence number of a response message is simply
>> the one from the request message. But in a dump where there
>> can be multiple messages, do they all share the sequence number?
>
>In those cases, the sequence number does NOT change intra-messageset
>in my experience, instead it is assumed they may be received out of
>order.

That would defeat the purpose (as seen from over here) of multipart
messages in the first place.
