From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Tue, 1 Nov 2005 11:29:30 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511011116550.3512@bizon.gios.gov.pl>
References: <4361EAAB.1090206@fliegl.de> <4361F6DF.3050106@eurodev.net>
	<43621028.40705@fliegl.de> <43627A8F.9060307@eurodev.net>
	<436281BB.2010100@fliegl.de>
	<436373E8.7040606@eurodev.net> <436398C7.4070402@fliegl.de>
	<4365A097.1080001@eurodev.net>
	<Pine.LNX.4.62.0510310911090.9468@bizon.gios.gov.pl>
	<4366C031.6020504@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-303441108-1130840970=:3512"
Cc: Deti Fliegl <deti@fliegl.de>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4366C031.6020504@eurodev.net>
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

---187430788-303441108-1130840970=:3512
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 1 Nov 2005, Pablo Neira wrote:
<CUT>
> You can't use -E together with -i. But I think that adding the conntrack =
ID=20
> to the event information that is dumped could be worth for accounting=20
> purposes, so I'll add this to my pending patches for ctnetlink, ok?
OK, thank you.

<CUT>
> You can't kill conntracks *just* by the ID. The connection tracking table=
=20
> currently uses the tuple information (source, destination, protocol=20
> information) to place the conntrack in hashes, same thing to perform look=
ups.
So, why do we need this conntrack ID? Only for userspace applications?

> Implementing the ability of killing conntracks just by its ID would be O(=
n),
True :(

> so we would need to walk through the buckets until we find a matching, no=
t so=20
> good. Just a wild thought, how bad would be hashing the conntracks by its=
 ID?

AFAIK quite bad since netfilter code really needs src/dst/proto hashing=20
when processing received packet.

> In that case we could implement this feature. So, currently you'll always=
=20
> need the information about the source, destination and protocol specific=
=20
> stuff together with the ID.
OK.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-303441108-1130840970=:3512--
