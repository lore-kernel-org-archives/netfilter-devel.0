From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: 2.6.17.1 compile error with a netfilter module
Date: Mon, 3 Jul 2006 16:19:04 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A208D0A6@mail733.InfraSupportEtc.com>
References: <925A849792280C4E80C5461017A4B8A206F784@mail733.InfraSupportEtc.com>
	<1151700888.2709.4.camel@murdegern.hindenburgdamm.example>
	<44A9615C.2050405@trash.net>
	<Pine.LNX.4.64.0607032135220.9324@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Torsten Luettgert <t.luettgert@pressestimmen.de>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Krzysztof Oledzki" <olenf@ans.pl>,
	"Patrick McHardy" <kaber@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Thanks guys.  Meanwhile, I went ahead and built up a box with just the =
kernel.org 2.6.17.2 kernel and no POM patches for now.=20
=20
- Greg
=20

________________________________

From: Krzysztof Oledzki [mailto:olenf@ans.pl]
Sent: Mon 7/3/2006 2:38 PM
To: Patrick McHardy
Cc: Torsten Luettgert; netfilter-devel@lists.netfilter.org; Greg Scott
Subject: Re: 2.6.17.1 compile error with a netfilter module





On Mon, 3 Jul 2006, Patrick McHardy wrote:

> Torsten Luettgert wrote:
>> On Fri, 2006-06-30 at 12:36 -0500, Greg Scott wrote:
>>
>>> Hmmm -
>>
>>
>>> I'll try another build, this time with 2.6.17.2 and POM 20060629 =
using
>>> these POM
>>> modules:
>>>  time
>>>  ipp2p
>>>  ROUTE
>>>  sip-conntrack-nat
>>
>>
>> time, ipp2p and ROUTE won't work with 2.6.17 without API patches -
>> I posted those last saturday, but they didn't get committed yet.
>> You can grab them from the archives. Don't know about =
sip-conntrack-nat,
>> but I suspect it'll have the same problem.
>
> Just applied ROUTE and u32. I think Jozsef already fixed u32, the
> remaining patchlets are not part of official pomng anymore, although
> I still haven't received the URL of the new external repository.

Need a day or two, sorry. :( I have been very busy for the last two =
weeks
but now I'm going to finish this ASAP.

Best regards,

                                Krzysztof Oledzk=20
