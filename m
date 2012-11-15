From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: make conntrackd namespace aware
Date: Thu, 15 Nov 2012 13:20:42 +0100
Message-ID: <20121115122042.GA1701@1984>
References: <1346461915-6309-1-git-send-email-aatteka@nicira.com>
 <20120906170253.GA17317@1984>
 <CAA=3Oq=G9g=9LkKxhobU1cTLtU3jyuGJZn4kn_E4LJXk11Escw@mail.gmail.com>
 <20120911154458.GB28012@1984>
 <CAA=3Oqm_tGgKpWf2V=Ki7Le-UcA7o_-_o+77TRjPX6-4RYha2Q@mail.gmail.com>
 <20120918192320.GA1182@1984>
 <CAA=3OqkaM_s4DEdL3D8tG5SCkRpubgzfw2a0snGZBGU0KD09Gg@mail.gmail.com>
 <20120919082143.GA20453@1984>
 <CAA=3Oq=COQS_gYuTT3mQ5KssEdNJHAj4gYz8dcg+rfr9XA_Sdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ansis Atteka <aatteka@nicira.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41188 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767659Ab2KOMUr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:20:47 -0500
Content-Disposition: inline
In-Reply-To: <CAA=3Oq=COQS_gYuTT3mQ5KssEdNJHAj4gYz8dcg+rfr9XA_Sdg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 15, 2012 at 09:55:09PM -0700, Ansis Atteka wrote:
[...]
> >> Here is how I am currently doing that:
> >>
> >> struct nethdr {
> >> #if __BYTE_ORDER == __LITTLE_ENDIAN
> >>       uint8_t type:4,
> >>               version:4;
> >> #elif __BYTE_ORDER == __BIG_ENDIAN
> >>       uint8_t version:4,
> >>               type:4;
> >> #else
> >> #error  "Unknown system endianess!"
> >> #endif
> >>       uint8_t flags;
> >>       uint16_t len;
> >>       uint32_t seq;
> >>       uint32_t nsid; < -present only if nethdr.flag &
> >> };
> >> nsid is the namespace id. This field would be present only
> >> if nethdr.flags & NET_F_NAMESPACE != 0.
> >
> > That adds an always zero field for the non-namespace case in the
> > protocol fixed header. TLVs can be used for optional fields.
> 
> What is your take on encapsulating namespace id in control messages
> (e.g. state resync requests)?
> 
> It seems that as of now control messages do not have TLVs...
> 
> Of course I could put some logic inside build.c and parse.c to deal
> with that. For example, if caller passes NULL for nf_conntrack *ct,
> then that would handle control message case?
> 
> Any better ideas?

It took me a long while to decide on this, sorry for the delay.

I think adding some 32-bits ID to the nethdr is fine since I can reuse
in case I decide to support cluster-based firewall clusters composed
of more than two firewalls.

The ID will allows us to identify messages coming from different
firewall and to keep different external caches, one per node ID.

So go ahead with adding that ID to the nethdr.
