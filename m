From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: NAT IPv6/IPv4 translator - request for review, plus two questions
 regarding code
Date: Thu, 15 Mar 2012 23:07:13 -0700
Message-ID: <CAHo-Ooy2Rmu=gwgoAcKfVoYbHfABkJkjK2_MSDu1j7Eq0Sac_g@mail.gmail.com>
References: <CALJVcJFZ_qk_qdNFnfveQx+GJF3iXLmMBe=ezgphUiY2uiFpng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?xYF1a2FzeiBDennFvA==?= <lukasz.czyzz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45572 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2CPGHO convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Mar 2012 02:07:14 -0400
Received: by ghrr11 with SMTP id r11so3862737ghr.19
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Mar 2012 23:07:14 -0700 (PDT)
In-Reply-To: <CALJVcJFZ_qk_qdNFnfveQx+GJF3iXLmMBe=ezgphUiY2uiFpng@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Disclaimer: I haven't looked at the code, and only gave a 5 minute
glance at your web page.

I would probably suggest implementing this not as netfilter hooks,
but rather as a virtual device (tun/tap/veth/dummy like).

You route v6 netblock 64:ff9b::/96 towards this device (and similarly
with the v4 subnet(s) it uses as source addresses for generated
traffic).
All translation packet mirroring is then confined to the transmit
function of this virtual point-to-point device.

=46rom the web page it doesn't sound like there's any actual netfilter
interaction...

=46urthermore, I would hazard a guess that requiring an IPv4 address fo=
r
every IPv6 host desiring to connect to an IPv4 address makes
this a little uninteresting.... to quote:

"For every IPv6 node communicating with IPv4 network one translator
address is reserved as node's representative. Because of this maximal
number of IPv6 nodes that are able to connect to IPv4 network at the
same time is limited by translator prefix size."

OTOH, Fixing this _might_ just require much deeper integration with net=
filter.
Although netfilter isn't really setup to handle v4-v6 connection so it
might be a wash...

On Thu, Mar 15, 2012 at 11:58, =C5=81ukasz Czy=C5=BC <lukasz.czyzz@gmai=
l.com> wrote:
> Hello all
>
> I have implemented IPv6/IPv4 NAT for Linux OS. It is written as kerne=
l
> module which registers its functions in netfilter hooks. I would like
> some netfilter programming expert to review my code (it is first
> kernel module written by me) and I am wondering what is the best form
> of contributing source to make somebody willing to glance at it. I am
> not sure if patch is the best way here, because I didn't make any
> changes in any other netfilter-related code, just created new module
> which only depends on netfilter hook register functions. Maybe tarbal=
l
> with Makefile is enough?
>
> Ttranslator is released under GPLv2 license - You can find more info
> about it at <http://czyzu.pl/xlat.html>.
>
>
> I would like to take occasion and ask two questions regarding my code=
 here.
>
> 1. I have following structure defined:
>
> /*
> =C2=A0* Helper struct used during packet translation
> =C2=A0*/
> struct xlat_translation_buffer {
> =C2=A0 =C2=A0/* Following entries must not be splitted */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iphdr =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0hdr4;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct icmphdr =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0i_hdr4;
> =C2=A0 =C2=A0/* End of entries */
>
> =C2=A0 =C2=A0/* Following entries must not be splitted */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ipv6hdr =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0hdr6;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0union {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct frag_hd=
r =C2=A0 =C2=A0 =C2=A0 =C2=A0 f_hdr;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct icmp6hd=
r =C2=A0 =C2=A0 =C2=A0 =C2=A0 i_hdr6;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0} hdrs6;
> =C2=A0 =C2=A0/* End of entries */
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hdr_len;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hfrag_off;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 frag;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0s16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hdr_diff;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u16 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 payload_len;
> };
>
> As You can guess from comments, there are particular fields in that
> structure which have to follow immediately, one after the other.
> That's because sometimes they are copied at the same time, by using
> one memcpy() call. Can I be sure that compiler won't put any void
> bytes between them (for alignment purposes) on any platform? Or maybe
> I should use substructures with 'packed' attribute to prevent such
> situation?
>
> 2. Second question - I have already posted it on kernel-newbies
> mailing list, but I am still not sure about it. Does every function
> which is used during packet translation (so it may be called many
> times every second) should be declared as inline? If no - what rules
> should I follow when determining if function has to be inlined in
> networking code.
>
>
> Lukasz
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
