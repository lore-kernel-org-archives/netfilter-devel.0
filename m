From: Krzysztof Oledzki <olenf@ans.pl>
Subject: ipt_REJECT-fake-source
Date: Mon, 3 Oct 2005 22:55:36 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0510032255170.14273@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed;
	BOUNDARY="-187430788-836995738-1128369966=:12533"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Content-ID: <Pine.LNX.4.62.0510032255171.14273@bizon.gios.gov.pl>
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

---187430788-836995738-1128369966=:12533
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2; FORMAT=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.62.0510032255172.14273@bizon.gios.gov.pl>

Hello,

In old patch-o-matic (not -ng) we had the ipt_REJECT-fake-source patch, whi=
ch=20
allowed to send icmp-unreachable messages with IP address of destination ho=
st.

This patch was dropped when moving to patch-o-matic-ng. Why?

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-836995738-1128369966=:12533--
