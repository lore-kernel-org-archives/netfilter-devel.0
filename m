From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Tue, 1 Nov 2005 16:17:40 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511011605010.12220@bizon.gios.gov.pl>
References: <4361EAAB.1090206@fliegl.de> <4361F6DF.3050106@eurodev.net>
	<43621028.40705@fliegl.de> <43627A8F.9060307@eurodev.net>
	<436281BB.2010100@fliegl.de>
	<436373E8.7040606@eurodev.net> <436398C7.4070402@fliegl.de>
	<4365A097.1080001@eurodev.net>
	<Pine.LNX.4.62.0510310911090.9468@bizon.gios.gov.pl>
	<4366C031.6020504@eurodev.net>
	<Pine.LNX.4.63.0511011116550.3512@bizon.gios.gov.pl>
	<436773EB.6000608@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1910068402-1130858260=:12220"
Cc: Deti Fliegl <deti@fliegl.de>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <436773EB.6000608@eurodev.net>
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

---187430788-1910068402-1130858260=:12220
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 1 Nov 2005, Pablo Neira wrote:

> Krzysztof Oledzki wrote:
>>> You can't kill conntracks *just* by the ID. The connection tracking tab=
le=20
>>> currently uses the tuple information (source, destination, protocol=20
>>> information) to place the conntrack in hashes, same thing to perform=20
>>> lookups.
>>=20
>> So, why do we need this conntrack ID? Only for userspace applications?
>
> Because of two reasons:
>
> a) We have to provide a way to uniquely identify a conntrack. On slow=20
> devices, it could happen that a connection with the same src/dst/proto co=
uld=20
> be re-created in a very short period of time. So the user can be sure tha=
t=20
> he's killing that conntrack, and not a similar that represents a re-opene=
d=20
> connection.
So one can pass this id as an additional information? OK. :)

BTW: I think conntrack-tool should inform that conntrack killing fails=20
because kernel isn't able to find a matching conntrack.

> b) Netlink dumping is not atomic, for that reason we need a way to know f=
rom=20
> which point we stopped dumping the connection tracking table. Keeping a=
=20
> pointer to the lastest conntrack processed won't work because of the time=
rs.=20
> It could happen that a conntrack expires at the time that  the process of=
=20
> dumping continues. So the idea is using the ID to establish such breakpoi=
nt,=20
> and continue from the lastest conntrack ID processed if it's still presen=
t,=20
> otherwise we'll process the next conntrack ID higher than the lastest=20
> processed.

But to do this you need to travel the structure from the beginning and so=
=20
dumping may require operations like O(n) anyway?


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1910068402-1130858260=:12220--
