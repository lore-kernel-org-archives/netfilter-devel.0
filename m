From: Victor Julien <lists@inliniac.net>
Subject: Re: libnetfilter_queue question
Date: Thu, 27 May 2010 15:25:31 +0200
Message-ID: <4BFE72CB.3040501@inliniac.net>
References: <4BF3BA47.7040109@inliniac.net> <1274299848.21477.6.camel@ice-age> <4BF6AEB0.1040303@inliniac.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:51463 "EHLO
	tulpe.vuurmuur.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab0E0N0o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 09:26:44 -0400
In-Reply-To: <4BF6AEB0.1040303@inliniac.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Victor Julien wrote:
> Eric Leblond wrote:
>> Hi Victor,
>>
>> Le mercredi 19 mai 2010 =E0 12:15 +0200, Victor Julien a =E9crit :
>>> Hi all,
>>>
>>> I'm using libnetfilter_queue for inline mode in the Suricata IDS/IP=
S
>>> (www.openinfosecfoundation.org). I'm using a callback that makes th=
e
>>> packet(s) available to the detection engine. In some special cases =
the
>>> call back could fail (only malloc failure atm).
>>>
>>> I was wondering what the proper response would be to such an event.=
 I'm
>>> assuming nfq_handle_packet() would return an (non zero) error code =
in
>>> that case.
>>>
>>> Should I verdict the packet? (drop to be safe)
>> Yes, clearly ! If you don't do this the packet will get stuck inside=
 the
>> kernel and nothing will released it (and free associated structures)=
=2E
>>
>> The only other mean to free queued packet is to unregister from the =
NF
>> queue.
>=20
> Thanks Eric, I will implement the verdict in case of error.

Actually, after giving it some more thought I was wondering if the
verdict would need to be issued in the failing callback function itself=
=2E

As far as I understand, nfq_handle_packet can process multiple packets
after a single recv.

What would be the appropriate place to issue the verdict?

--=20
---------------------------------------------
Victor Julien
http://www.inliniac.net/
PGP: http://www.inliniac.net/victorjulien.asc
---------------------------------------------

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
