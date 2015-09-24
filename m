From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: SIP messages with no/invalid CSeq are dropped by nf_ct_sip, 400
 Bad Request is expected instead
Date: Thu, 24 Sep 2015 13:49:48 +0200
Message-ID: <5603E35C.4040500@c-s.fr>
References: <5603BA34.60700@c-s.fr>
 <20150924111908.GA32673@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	TIXADOU Jean-Yves <jean-yves.tixadou@c-s.fr>,
	PERRONNY Olivier <olivier.perronny@c-s.fr>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20150924111908.GA32673@macbook.localdomain>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



Le 24/09/2015 13:19, Patrick McHardy a =E9crit :
> On 24.09, Christophe Leroy wrote:
>> I have an issue with the SIP conntrack:
>>
>> In commit 30f33e6dee [NETFILTER]: nf_conntrack_sip: support method s=
pecific
>> request/response handling
>> Modified by b20ab9cc63 netfilter: nf_ct_helper: better logging for d=
ropped
>> packets
>>
>> SIP requests with no CSeq header are dropped by kernel before reachi=
ng the
>> user app.
>>
>> According to RFC4475 "Session Initiation Protocol (SIP) Torture Test
>> Messages", requests with invalid CSeq should be responded with 400 B=
ad
>> Request, and that's what my app does, but it can only do it if it re=
ceives
>> the request.
> I don't see anything about missing CSeq-headers in that RFC, could yo=
u point
> me to the correct chapter?
>
RFC4475 gives no exemple explicitly about missing CSeq-headers, but it=20
has some exemples for bad CSeq-headers in =A73.1.2.4, =A73.1.2.17 and =A7=
3.3.8=20
where it expects 400 Bad request response.

In addition, =A73.3.1 "Missing Required Header Fields" shows that 400 B=
ad=20
Request is also expected in the case of missing Call-ID, From, or To=20
mandatory headers. Taking into account RFC3261 =A78.1.1, CSeq is also a=
=20
mandatory header in the same way as Call-ID, From, or To, so the same=20
answer should be expected.

RFC3261 =A721.4.1 shows that 400 Bad request is to be used for missing=20
headers.

Christophe
