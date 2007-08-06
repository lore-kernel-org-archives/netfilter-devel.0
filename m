From: Krzysztof Oledzki <ole@ans.pl>
Subject: xt_policy: output policy not valid in PRE_ROUTING and INPUT
Date: Mon, 6 Aug 2007 13:22:10 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708061317410.23493@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-657807298-1186399330=:23493"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

---187430788-657807298-1186399330=:23493
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

Is there any reason why it is not possible to use "-m policy --dir out" in=
=20
PREROUTING? I tried to do something like:

-A PREROUTING -m policy --dir out --pol ipsec -j RETURN
-A PREROUTING -p tcp -i $IF_LANBR --dport 80 -j REDIRECT --to-ports 8088

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-657807298-1186399330=:23493--
