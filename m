From: Pete Kay <petedao@gmail.com>
Subject: Re: question about libfilter_conntrack
Date: Tue, 27 Jul 2010 17:31:31 +0800
Message-ID: <AANLkTi=EXoTg+eUrgxpWU73Rd-EPwHtc3V+um+4sj917@mail.gmail.com>
References: <AANLkTinSbAJfzTyxJRawHzA05u73fZpgoUXDABNQ+v=y@mail.gmail.com>
	<1280211159.1462.54.camel@andybev>
	<AANLkTi=xLxmMeKz2kuz1myZY4dg4_Go=1spLJ1H8dQO7@mail.gmail.com>
	<20100727095224.134553gv7kfpneiw@www.simplelists.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35461 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab0G0Jbc convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jul 2010 05:31:32 -0400
Received: by pzk26 with SMTP id 26so1282908pzk.19
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2010 02:31:31 -0700 (PDT)
In-Reply-To: <20100727095224.134553gv7kfpneiw@www.simplelists.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andy,

thanks alot.  It works now.

P

On Tue, Jul 27, 2010 at 4:52 PM, Andrew Beverley <andy@andybev.com> wro=
te:
>>>> I would like to use libfilter_conntrack to remove an entry in the
>>>> conntrack table.
>>>>
>>>> Does anyone have an example showing how to do that programmaticall=
y?
>>>
>>> There's an example in the source code, in utils/conntrack_delete.c
>>>
>> I am using the conntrack_delete example to try to delete this entry:
>> udp =A0 =A0 =A017 29 src=3D192.168.1.56 dst=3D192.168.1.114 sport=3D=
16385
>> dport=3D26956 packets=3D28149 bytes=3D7881720 [UNREPLIED] src=3D192.=
168.1.114
>> dst=3D192.168.1.56 sport=3D26956 dport=3D16385 packets=3D0 bytes=3D0=
 mark=3D0
>> secmark=3D0 use=3D2
>>
>> But I am having problem doing so with the lines of code below:
>>
>> =A0 =A0 =A0ct =3D nfct_new();
>> =A0 =A0 =A0 =A0if (!ct) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0perror("nfct_new");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>>
>> =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0nfct_set_attr_u8(ct, ATTR_L3PROTO, AF_INET);
>> =A0 =A0 =A0 =A0nfct_set_attr_u32(ct, ATTR_ORIG_IPV4_SRC,
>> inet_addr("192.168.1.56"));
>>
>> =A0 =A0 =A0 =A0nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_UDP);
>> =A0 =A0 =A0nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, htons(16385));
>>
>
> You need to also specify the destination IP address and port number. =
I think
> that as a minumum you must specify all 6 peices of information: sourc=
e/dest
> IP address and port number, and the layer 3 and layer 4 protocol.
>
> Regards,
>
> Andy
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
