From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [LARTC] Opinions about pom/patches [was: iptables 1.3.7, kernel
 2.6.19, ROUTE and Layer7 issues]
Date: Fri, 9 Feb 2007 17:57:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0702091741250.9884@bizon.gios.gov.pl>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
	<457E6997.1050001@trash.net>
	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>
	<457FBBFD.6060009@trash.net>
	<Pine.LNX.4.64.0612282158360.16672@bizon.gios.gov.pl>
	<45A48087.8090200@trash.net>
	<Pine.LNX.4.61.0701101233080.3029@yvahk01.tjqt.qr>
	<54696.195.55.244.106.1168435275.squirrel@www.arcoscom.com>
	<1169746884.4253.51.camel@andybev.localdomain>
	<45C005EB.1040704@netfilter.org>
	<1171028254.4244.26.camel@andybev.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1896620433-1171040242=:9884"
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	linux@arcoscom.com, Pablo Neira Ayuso <pablo@netfilter.org>
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1171028254.4244.26.camel@andybev.localdomain>
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

---187430788-1896620433-1171040242=:9884
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 9 Feb 2007, Andrew Beverley wrote:

> On Wed, 2007-01-31 at 03:58 +0100, Pablo Neira Ayuso wrote:
>> Andrew Beverley wrote:
>>> I would also like to see as many of the POM included in the stable
>>> kernel. It's a bit of a headache to patch in what I want each time I
>>> update the kernel, and on a fresh system I have to install CURL just to
>>> update POM just to add connlimit to the kernel...
>>
>> IMHO, patching kernels to add some certain shiny-feature(TM) is
>> generally a bad idea if you don't know how the patch internally works or
>> if you can't directly get support from the author of such patch.
>
> Yes, agreed. I was more thinking of those that (look like) they have
> been stable for a few years.
>
>> Anyway, if you think that some certain patch is stable enough to push it
>> forward to mainline, encourage the author to push it forward. Probably
>> there is a reason why he decided not to do that.
>
> Okay, I've emailed the author (of connlimit) but not received a reply. I
> did ask him a while ago on the same subject but didn't really get a
> reason as to why it is not. Anybody have any ideas?
>
> In this case can *I* push it forward to the stable kernel?

Please excuse me - I have been _extremely _ busy for the last three weeks.

Getting back to the question: generally I have no objection for forwarding=
=20
connlinit to the mainline but I believe we should first investigate a=20
possibilty to add support for other protocols than TCP. AFAIK at least UDP=
=20
support could be very usefull - p2p software generates not only a lot of=20
tcp cnnections but also udp flows and main job for this extension is to=20
prevent conntrack database overflows.

BTW: I'm not the author of this code - I only volunteered to maintain it.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1896620433-1171040242=:9884--
