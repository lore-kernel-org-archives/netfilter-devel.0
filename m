From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: cntl_test fail
Date: Fri, 2 Dec 2005 21:13:41 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0512022113160.4068@bizon.gios.gov.pl>
References: <43905DC0.9020805@minag.gob.pe>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1484647516-1133554421=:4068"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Geffrey Velasquez <gvelasquez@minag.gob.pe>
In-Reply-To: <43905DC0.9020805@minag.gob.pe>
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

---187430788-1484647516-1133554421=:4068
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 2 Dec 2005, Geffrey Velasquez wrote:

> Hi pals, I'm trying to understand the code of libnetfilter_conntrack=20
> (starting with the example from utils) but the cntl_test fail with this=
=20
> errors:
>
> Test for libnetfilter_conntrack
>
> NFNETLINK answers: Invalid argument
> TEST 1: create conntrack (-22)
> TEST 2: dump conntrack table and reset (-22)
> TEST 3: dump conntrack table (-22)
> TEST 4: get conntrack (-22)
> TEST 5: update conntrack (-22)
> NFNETLINK answers: Invalid argument
> TEST 6: delete conntrack (-22)
> nfnl_open: bind(netlink): Operation not permitted
> Can't open handler
>
>
> I'm running the kernel 2.6.14.3 (from kernel.org) on Centos-4.
>
> Any ideas?
=2Econfig please :)

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1484647516-1133554421=:4068--
