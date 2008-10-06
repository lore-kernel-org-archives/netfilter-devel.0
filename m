From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH RFC] xt_layer7
Date: Mon, 6 Oct 2008 15:15:16 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810061508360.10698@fbirervta.pbzchgretzou.qr>
References: <38bcb3ec0810040022w79ccea3dk134c3f03d375a601@mail.gmail.com>  <alpine.LNX.1.10.0810040750300.19954@fbirervta.pbzchgretzou.qr>  <48E8C637.5060700@trash.net> <38bcb3ec0810061157k14d15ae3h902265f42095b469@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Matthew Strait <quadong@users.sourceforge.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40242 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYJFTPS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:15:18 -0400
In-Reply-To: <38bcb3ec0810061157k14d15ae3h902265f42095b469@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-10-06 14:57, James King wrote:
>> Jan Engelhardt wrote:
>>>
>>> Right now, you still cannot use it with a vanilla kernel because
>>> patches like #3 you attached enlarges the allocated region (remember,
>>> NF_CT_EXT_NUM just increased by one!), which is going to be a big
>>> impact {for users not using all the extensions} {if every imaginable
>>> extensions adds itself a NF_CT_EXT_ number}.

Let me rephrase that one: you cannot use layer7 with vanilla right now
because patch #3 is not in vanilla [yet] ;-)

>update_alloc_size() skips over unregistered extensions, and it's a bug
>to pass (id == NULL) to nf_ct_ext_add() or nf_ct_ext_create(), so
>unused extensions shouldn't really impact memory allocation in terms
>of allocated region size.  Under patch #3, nf_cf_ext_types[] has a
>single size increase by sizeof(nf_ct_ext_type), and it increases
>ct->ext->offset by one u8 (so per-conntrack increase).  Is this size
>increase alone enough to rule it out, or am I missing something else
>here?

What I meant is the offset[] array. If we were to add 1000 new ct
extensions, all users of the particular kernel would pay 1000 bytes
for space they will never fully use.
Additionally, NF_CT_EXT_NUM might be too undersized for
*yet more* modules (e.g. out-of-tree) to register their stuff.
It's like tcp port numbers - the number is only finite.
A linked list would "solve" this (allow for infinitely many extensions,
well, as long as your memory holds it), but of course at the cost
of traversing it, etc. as Patrick pointed out.

I am not against these patches - over time, we only accumulated 2
modules, and maybe there is not that much of a market for more
than a handul ones.
