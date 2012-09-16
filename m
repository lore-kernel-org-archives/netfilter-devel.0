From: =?ISO-8859-1?Q?Miguel_Alejandro_Gonz=E1lez?= <maggonzz@gmail.com>
Subject: Re: conntrack tuple
Date: Sat, 15 Sep 2012 19:08:48 -0500
Message-ID: <CA+Z0r8OwQzXax9oT2hpsfmKHVHaBLE5iqD5qHJmpdcMBCTiU2g@mail.gmail.com>
References: <CA+Z0r8Mg3X8LQF0Y-kODT+SGgYuOm7FwwWWZoz5R+XP=vFLRLQ@mail.gmail.com>
 <20120915211450.GA11216@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48824 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab2IPAJU convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Sep 2012 20:09:20 -0400
Received: by pbbrr13 with SMTP id rr13so7350260pbb.19
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Sep 2012 17:09:20 -0700 (PDT)
In-Reply-To: <20120915211450.GA11216@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So,

I have this code, I got it from the Writing netfilter code ebook:

      	  const struct nf_conn *ct;
          const struct nf_conntrack_tuple *t;
          enum ip_conntrack_info ctinfo;
          enum ip_conntrack_dir dir;
          ct =3D nf_ct_get(skb, &ctinfo);
          if (ct !=3D NULL && (ctinfo =3D=3D IP_CT_NEW || ctinfo =3D=3D=
 IP_CT_RELATED))
                  return false;
          dir =3D CTINFO2DIR(ctinfo);
          t =3D &ct->tuplehash[dir].tuple;


Assuming there was already an established UDP or TCP connection that
passed by conntrack. And with what you told me, conntrack should get a
tuple with the inner headers upon receiving a Destination unreachable
error message with an inner packet. I'm testing this code and I get a
ICMP tuple with 771 as id, is this ok? I think I should be getting a
UDP or TCP tuple with the l4 headers from the inner packet...

I'm using kernel 2.6.38, I think you guys changed the tuple to have
type and code instead of id in later versions.... maybe I should use
the latest version...

In my module I have the function need_ipv4_conntrack() in the init
function, I think this is enough to load conntrack.

Regards!

On Sat, Sep 15, 2012 at 4:14 PM, Pablo Neira Ayuso <pablo@netfilter.org=
> wrote:
> Hi,
>
> On Fri, Sep 14, 2012 at 09:57:36AM -0500, Miguel Alejandro Gonz=E1lez=
 wrote:
>> Hello
>>
>> I have some questions about how conntrack tuple handles ICMP error m=
essages...
>>
>> When a ICMP error packet arrives containing an embedded UDP or TCP
>> packet, assuming there was already a UDP or TCP connection being
>> tracked by conntrack, what are the IP addresses of the tuple, the on=
es
>> from the ICMP error message or the ones from the embedded packet?
>
> It uses inner headers of the ICMP error message, ie. "the ones from
> the embedded packet".
>
> See net/ipv4/netfilter/nf_conntrack_proto_icmp.c
>
>> Also does the tuple saves port information in this case as well as i=
cmp
>> type and code?
>
> Conntrack does not save any ICMP error information.
>
>> How does conntrack know that ICMP error message is related to an
>> existing connection?
>
> The conntrack code looks up for some existing entry by using the
> information in the inner headers of the ICMP error message.
>
> If no entry is found, the packet is considered invalid, and you can
> drop it with iptables ... -m state --state INVALID
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
