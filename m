From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: NetBIOS datagram nat helper proposal
Date: Mon, 19 Sep 2005 23:30:36 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0509192329420.32519@bizon.gios.gov.pl>
References: <1127164215.25000.44.camel@localhost>
	<20050919212756.GA26816@linuxace.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1357460006-1127165436=:32519"
Cc: "John A. Sullivan III" <jsullivan@opensourcedevel.com>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050919212756.GA26816@linuxace.com>
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

---187430788-1357460006-1127165436=:32519
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 19 Sep 2005, Phil Oester wrote:

> On Mon, Sep 19, 2005 at 05:10:15PM -0400, John A. Sullivan III wrote:
>> It appears that we may need a netbios datagram NAT helper.  Unless we
>> can find a workaround, it we have encountered a couple of environments
>> where we need to NAT netbios datagram packets.  Since they have embedded
>> IP address information in the netbios header, this protocol breaks with
>> NAT.  We see the packets enter the server with the NAT address but the
>> replies are addressed to the original address as per the netbios header.
>
> Like this one:
>
> http://www.kernel.org/git/gitweb.cgi?p=3Dlinux/kernel/git/torvalds/linux-=
2.6.git;a=3Dcommit;h=3Da2978aea393b5e00b55b219786a5b8a47f838a7f
>
> which was merged 12 days ago?

No. This is a connection tracking helper, not NAT helper.

Best regards,
 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1357460006-1127165436=:32519--
