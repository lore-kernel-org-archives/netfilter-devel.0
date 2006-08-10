From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [Fwd: [Bug 499] ipp2p error. ip_tables: ipp2p match: invalid
 size 0 != 8]
Date: Thu, 10 Aug 2006 11:04:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0608101103440.9097@bizon.gios.gov.pl>
References: <44DA7298.9070805@arcoscom.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1083095380-1155200693=:9097"
Cc: ipp2p@ipp2p.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-1?Q?Samuel_D=EDaz_Garc=EDa?= <samueldg@arcoscom.com>
In-Reply-To: <44DA7298.9070805@arcoscom.com>
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

---187430788-1083095380-1155200693=:9097
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 10 Aug 2006, Samuel D=EDaz Garc=EDa wrote:

> Sorry for the inconvenence, but I don't know where to look for help about=
=20
> this problem.

The ipp2p extension was moved into external repository and removed from=20
pom-ng. For a 2.6.17.x kernel you need a recent pom-ng extended with=20
"./runme --download".

Please verify that you have a properly patched kernel - the ipt_ipp2p.c=20
file should be 25144 bytes long with md5: a674ded594abbf43893ae32630208d08


Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1083095380-1155200693=:9097--
