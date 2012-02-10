From: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Subject: Re: BUG nf_conntrack_ffff880863c50000: Objects remaining on kmem_cache_close()
Date: Fri, 10 Feb 2012 08:58:41 +0100
Message-ID: <4F34CE31.7030404@univ-nantes.fr>
References: <4F328A81.4050607@univ-nantes.fr> <20120209155753.GB5951@1984>  <4F33F03C.5030805@univ-nantes.fr> <20120209193917.GB6881@1984>  <4F34CAC0.7060800@univ-nantes.fr> <1328860499.4030.2.camel@edumazet-laptop>
Reply-To: jean-philippe.menil@univ-nantes.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-tls1.univ-nantes.fr ([193.52.101.145]:37376 "EHLO
	smtp-tls.univ-nantes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab2BJH65 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Feb 2012 02:58:57 -0500
In-Reply-To: <1328860499.4030.2.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 10/02/2012 08:54, Eric Dumazet a =C3=A9crit :
> Le vendredi 10 f=C3=A9vrier 2012 =C3=A0 08:44 +0100, Jean-Philippe Me=
nil a =C3=A9crit :
>
>> No, the NetlinkEventsReliable is commented in the configuration file=
=2E
>>
>> However, on the same hosts, i see strange things:
>> ths host boot with the following parameter:
>> net.netfilter.nf_conntrack_max=3D262144
>> net.netfilter.nf_conntrack_tcp_timeout_established=3D10800
>>
>> nf_conntrack is loaded with the following parameter:
>> options nf_conntrack hashsize=3D262144
>>
>> But it seems that the nf_conntrack_max reset to his default value
>> (65536) periodically.
>> Three days ago, i manually increase the nf_conntrack_max to 262144,
>> yesterday i see plenty of "nf_conntrack: table full, dropping packet=
".
>> checking the value, is fall down to 65536.
>>
>> It's maybe not related, but i can't understand how the value can cha=
nge?
>>
> 65536 is the default value when module is loaded.
>
> Something unloads it and loads it again, and sysctl is not run after
> this module load.
>
>
>
>
Yes, that's what i'm thinking.
And i found the culprit:
my lxc guest start with the default value (65536), and it seems to rese=
t=20
the value on the hosts ...

--=20
Jean-Philippe Menil - P=C3=B4le r=C3=A9seau Service IRTS
DSI Universit=C3=A9 de Nantes
jean-philippe.menil@univ-nantes.fr
Tel : 02.53.48.49.27 - Fax : 02.53.48.49.09

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
