From: Ansis Atteka <aatteka@nicira.com>
Subject: Re: [PATCH] conntrackd: make conntrackd namespace aware
Date: Thu, 15 Nov 2012 21:34:53 +0200
Message-ID: <CAA=3Oqk+2OgeQ5Z8FeCg0mtB6gFDsWag-khqUhnc3Ocs2kTMgA@mail.gmail.com>
References: <1346461915-6309-1-git-send-email-aatteka@nicira.com>
	<20120906170253.GA17317@1984>
	<CAA=3Oq=G9g=9LkKxhobU1cTLtU3jyuGJZn4kn_E4LJXk11Escw@mail.gmail.com>
	<20120911154458.GB28012@1984>
	<CAA=3Oqm_tGgKpWf2V=Ki7Le-UcA7o_-_o+77TRjPX6-4RYha2Q@mail.gmail.com>
	<20120918192320.GA1182@1984>
	<CAA=3OqkaM_s4DEdL3D8tG5SCkRpubgzfw2a0snGZBGU0KD09Gg@mail.gmail.com>
	<20120919082143.GA20453@1984>
	<CAA=3Oq=COQS_gYuTT3mQ5KssEdNJHAj4gYz8dcg+rfr9XA_Sdg@mail.gmail.com>
	<20121115122042.GA1701@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:53521 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1768775Ab2KOTfR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 14:35:17 -0500
Received: by mail-oa0-f70.google.com with SMTP id k14so7761237oag.1
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Nov 2012 11:34:53 -0800 (PST)
In-Reply-To: <20121115122042.GA1701@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 15, 2012 at 2:20 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Oct 15, 2012 at 09:55:09PM -0700, Ansis Atteka wrote:
> [...]
>> >> Here is how I am currently doing that:
>> >>
>> >> struct nethdr {
>> >> #if __BYTE_ORDER == __LITTLE_ENDIAN
>> >>       uint8_t type:4,
>> >>               version:4;
>> >> #elif __BYTE_ORDER == __BIG_ENDIAN
>> >>       uint8_t version:4,
>> >>               type:4;
>> >> #else
>> >> #error  "Unknown system endianess!"
>> >> #endif
>> >>       uint8_t flags;
>> >>       uint16_t len;
>> >>       uint32_t seq;
>> >>       uint32_t nsid; < -present only if nethdr.flag &
>> >> };
>> >> nsid is the namespace id. This field would be present only
>> >> if nethdr.flags & NET_F_NAMESPACE != 0.
>> >
>> > That adds an always zero field for the non-namespace case in the
>> > protocol fixed header. TLVs can be used for optional fields.
>>
>> What is your take on encapsulating namespace id in control messages
>> (e.g. state resync requests)?
>>
>> It seems that as of now control messages do not have TLVs...
>>
>> Of course I could put some logic inside build.c and parse.c to deal
>> with that. For example, if caller passes NULL for nf_conntrack *ct,
>> then that would handle control message case?
>>
>> Any better ideas?
>
> It took me a long while to decide on this, sorry for the delay.
>
> I think adding some 32-bits ID to the nethdr is fine since I can reuse
> in case I decide to support cluster-based firewall clusters composed
> of more than two firewalls.
>
> The ID will allows us to identify messages coming from different
> firewall and to keep different external caches, one per node ID.
>
> So go ahead with adding that ID to the nethdr.

I have been on vacations for the last month. I will get back on this
multi-namespace patch sometime next week.

It seems that we actually would prefer TLV ID (so that ID could be an
arbitrary string. For example,if namespaces are named the same way on
both firewalls, then the namespace name could be used as this ID).
Otherwise this 32-bit ID would be an extra thing that needs to be
negotiated between all firewalls.

The only problem is that as of now control messages do not have this
payload where to put TLV variables. I will refresh my memory on
options here, once I will get back.
