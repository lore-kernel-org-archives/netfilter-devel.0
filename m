From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Illegal option `-i' with conntrack -I
Date: Thu, 3 Nov 2005 15:33:59 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511031524400.5613@bizon.gios.gov.pl>
References: <Pine.LNX.4.63.0511031427190.1341@bizon.gios.gov.pl>
	<200511031507.52812@nienna>
	<Pine.LNX.4.63.0511031510130.4331@bizon.gios.gov.pl>
	<200511031523.48170@nienna>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1556590086-1131028439=:5613"
Cc: netfilter-devel@lists.netfilter.org, Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <200511031523.48170@nienna>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1556590086-1131028439=:5613
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 3 Nov 2005, KOVACS Krisztian wrote:

>
>  Hi,
>
> On Thursday 03 November 2005 15.12, Krzysztof Oledzki wrote:
>>> On Thursday 03 November 2005 14.36, Krzysztof Oledzki wrote:
>>>> It seems it is not possible to specify conntrack id while adding
>>>> new conntrack. Is it intentionally?
>>>
>>>  I guess it's intentional. For the netlink dump to work you need
>>> the IDs of conntrack entries to be unique and monotonously
>>> increasing, and that's what setting the ID from userspace could
>>> ruin.
>>
>> So netlink will never allow to save & restore exact status of
>> the ip_conntrack?
>
>  Apart from the netlink interface nothing uses the ID, so obviously
> there's no way it could have any influence on connection tracking or
> packet classification. But then what's the point in restoring it?

For userspace I think... Of course if one day netlink will allow to=20
preserve ip_conntrack between reboots or to synchronize two firewalls.

I think that netlink could easly check if selected ID is valid as it have=
=20
to be bigger than last used one.

Anyway, there are more important problems like keeping tcp segment=20
numbers, so no problem.


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1556590086-1131028439=:5613--
