From: =?iso-8859-15?q?C=E9dric?= Rivard <cedric@yemanja.net>
Subject: PPTP conntrack with CONFIG_NETFILTER_DEBUG is broken (was: newnat and patch-o-matic)
Date: 20 Sep 2002 11:11:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87d6r9jaa4.fsf@sensi.yemanja.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

As I've already reported, there is a problem with the PPTP conntrack module=
 of pom. It can't be built with the option CONFIG_NETFILTER_DEBUG. And I st=
ill receive questions about the first thread I started on this problem but =
without pointing the cause.
I hope that everyone is now aware of this issue.
Regards,
C=E9dric
