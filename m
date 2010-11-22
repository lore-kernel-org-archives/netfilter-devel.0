From: Ulrich Weber <uweber@astaro.com>
Subject: Re: [RFC PATCH] nfqueue: nf_conntrack_confirm race condition
Date: Mon, 22 Nov 2010 13:34:52 +0100
Message-ID: <4CEA636C.80904@astaro.com>
References: <4CE64A5A.4010707@astaro.com> <AANLkTimFXUSKTLLMiDVH8Rb0kjVFhtQZQtm+zKT75jhk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ulrich Weber <uweber@astaro.com>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-50.dex002.intermedia.net ([64.78.21.148]:51683 "EHLO
	dhost002-50.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755433Ab0KVMuP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:50:15 -0500
In-Reply-To: <AANLkTimFXUSKTLLMiDVH8Rb0kjVFhtQZQtm+zKT75jhk@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yes you are right, queuing could be done in raw table PRE_ROUTING and
LOCAL_OUT. However I dont like the idea of queuing packets which are
going to be dropped anyway, could trigger an DOS attack.

We could add two additional raw hooks for LOCAL_IN and POST_ROUTING,
after conntrack is confirmed and queue packets then...

Conntrack lookup after reinjection is racy too with multiple queues.

Cheers
 Ulrich

On 11/20/2010 07:49 AM, Changli Gao wrote:
> On Fri, Nov 19, 2010 at 5:58 PM, Ulrich Weber <uweber@astaro.com> wro=
te:
>> Hi,
>>
>> glibc 2.9 implement parallel IPv4/IPv6 DNS lookup. This caused lots =
of
>> trouble
>> in all kind of implementations, so all major Linux distributions rem=
oved
>> _nss_dns_gethostbyname4_r in their glibc version, except for Debian =
Squeeze,
>> see also "options single-request" for more information.
>>
>> Normally parallel DNS lookups works fine, first packet is received a=
nd
>> forwarded, so conntrack is confirmed before second packet is receive=
d.
>>
>> However in combination with NFQUEUE, the second DNS requests is
>> received while the first one is still in the queue and both DNS requ=
ests
>> have an unconfirmed conntrack. So the second one will be dropped
>> in nf_conntrack_confirm, which results in an DNS timeout and retrans=
mit.
>>
>> Can be reproduced with: adnshost yahoo.com google.com
>>
>> My first idea was to re-lookup the conntrack in nf_conntrack_confirm=
,
>> but at that time the seconds request was already NATed. So I moved
>> that code to nf_nat_fn(). Of course this only works if nat is loaded=
=2E..
>>
>> Any comments or ideas, how to address this problem?
>=20
> It seems that you queue packets in the middle of conntrack. Beside
> NFQUEUE, IMQ may causes the same problem. I think you'd better queue
> packets before conntrack, raw table? Or lookup the conntrack again
> after packets are reinjected.
>=20


--=20
Ulrich Weber | uweber@astaro.com | Software Engineer
Astaro GmbH & Co. KG | www.astaro.com | Phone +49-721-25516-0 | Fax =96=
200
An der RaumFabrik 33a | 76227 Karlsruhe | Germany
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
