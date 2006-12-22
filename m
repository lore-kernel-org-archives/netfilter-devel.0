From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: Network compression...
Date: Fri, 22 Dec 2006 11:37:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612221134350.28327@bizon.gios.gov.pl>
References: <200612221139.AA2964652346@todaktech.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-254573431-1166783829=:28327"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: safiudeen <safiudeen@todaktech.com>
In-Reply-To: <200612221139.AA2964652346@todaktech.com>
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

---187430788-254573431-1166783829=:28327
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 22 Dec 2006, safiudeen wrote:

> Hi,
Hi,

> I want to compress TCP/IP packet (payload and IP header) in out going=20
> packet and uncmpress in incomming packet. Is it possible to do this=20
> using netfilter hook ?. If possible what type of network hook can be=20
> used ?.
>
> I tryed adding a fiew code in side linux kernel TCP/IP stack netif_rx ()=
=20
> call and dev_queue_xmit (), but kernel hang after fiew second.
>
> If someone already done similor work or know how to do this please provid=
e me some informatiom.
>
> Thank you very much.

I think IPSec (IPComp) should do the job...

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-254573431-1166783829=:28327--
