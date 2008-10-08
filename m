From: "James King" <t.james.king@gmail.com>
Subject: Re: [PATCH RFC] xt_layer7
Date: Wed, 8 Oct 2008 13:48:08 -0700
Message-ID: <38bcb3ec0810081348r67ee499an7be14db05481cc96@mail.gmail.com>
References: <38bcb3ec0810040022w79ccea3dk134c3f03d375a601@mail.gmail.com>
	 <alpine.LNX.1.10.0810040750300.19954@fbirervta.pbzchgretzou.qr>
	 <48E8C637.5060700@trash.net>
	 <38bcb3ec0810061157k14d15ae3h902265f42095b469@mail.gmail.com>
	 <alpine.LNX.1.10.0810061508360.10698@fbirervta.pbzchgretzou.qr>
	 <38bcb3ec0810061248w71dd0480y56a014d0a015288@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
	"Matthew Strait" <quadong@users.sourceforge.net>,
	"Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:48433 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbYJHUsL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:48:11 -0400
Received: by ey-out-2122.google.com with SMTP id 6so1311642eyi.37
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Oct 2008 13:48:09 -0700 (PDT)
In-Reply-To: <38bcb3ec0810061248w71dd0480y56a014d0a015288@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 6, 2008 at 12:48 PM, James King <t.james.king@gmail.com> wrote:
> On Mon, Oct 6, 2008 at 12:15 PM, Jan Engelhardt wrote:
>>
>> On Monday 2008-10-06 14:57, James King wrote:
>>>update_alloc_size() skips over unregistered extensions, and it's a bug
>>>to pass (id == NULL) to nf_ct_ext_add() or nf_ct_ext_create(), so
>>>unused extensions shouldn't really impact memory allocation in terms
>>>of allocated region size.  Under patch #3, nf_cf_ext_types[] has a
>>>single size increase by sizeof(nf_ct_ext_type), and it increases
>>>ct->ext->offset by one u8 (so per-conntrack increase).  Is this size
>>>increase alone enough to rule it out, or am I missing something else
>>>here?
>>
>> What I meant is the offset[] array. If we were to add 1000 new ct
>> extensions, all users of the particular kernel would pay 1000 bytes
>> for space they will never fully use.
>> Additionally, NF_CT_EXT_NUM might be too undersized for
>> *yet more* modules (e.g. out-of-tree) to register their stuff.
>> It's like tcp port numbers - the number is only finite.
>> A linked list would "solve" this (allow for infinitely many extensions,
>> well, as long as your memory holds it), but of course at the cost
>> of traversing it, etc. as Patrick pointed out.
>>
>> I am not against these patches - over time, we only accumulated 2
>> modules, and maybe there is not that much of a market for more
>> than a handul ones.
>
> Ah, ok, your first response felt like a NAK, thanks for clarifying.  I
> agree that being able dynamically register unknown extensions in that
> fashion could be useful in the long run if lots of extensions were to
> start popping up, but at this point it's an dead even tradeoff between
> the two approaches, and my immediate goal is to get a module that many
> people already find very useful supported without an unnecessary
> patching process.

Patrick, do you have any objections to these patches (specifically
adding NF_CT_EXT_LAYER7), or were you just against Jan's suggestion to
make ct_extend to use a linked list for all extensions?  If not, would
you like me to send a proper patch series?
