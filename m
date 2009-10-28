From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_ACCOUNT and big endian machines
Date: Wed, 28 Oct 2009 18:51:14 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0910281840390.15948@obet.zrqbmnf.qr>
References: <200910231623.42725.thomas.jarosch@intra2net.com> <200910261003.01234.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0910271038170.13188@obet.zrqbmnf.qr> <200910271149.10969.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55580 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298AbZJ1RvL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:51:11 -0400
In-Reply-To: <200910271149.10969.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-10-27 11:49, Thomas Jarosch wrote:
>
>> @@ -817,7 +817,7 @@ static int ipt_acc_handle_get_data(uint32_t hand=
le,
>>  void *to_user) struct ipt_acc_mask_24 *network =3D
>>  					network_16->mask_24[b];
>>  				if (ipt_acc_handle_copy_data(to_user, &to_user_pos,
>> -				    &tmpbuf_pos, network, net_ip, (b << 16)))
>> +				    &tmpbuf_pos, network, ntohl(net_ip), (b << 16)))
>>  					return -1;
>>  			}
>>  		}
>
>I'm starting to get my mind ready for endian issues :)
>The "net_OR_mask" is in host order if I understood it correctly,
>so shouldn't this read "(b << 8)"?

Yes it should be <<8.

Besides, "the 8 bit" comment is confusing, because both CIDR/8 and
CIDR/24 have eight bits either way - just one has eight 1s, one has
eight 0s.

    =E2=86=92   /* 8 bit network */=20
    =E2=86=92   if (depth =3D=3D 0) {=20
    =E2=86=92       =E2=86=92   struct ipt_acc_mask_24 *network =3D=20


I am in the process of annotating the entire source with the BE
markers and I am already getting into situations where I think
"there's more bswapping amiss"
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
