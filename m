From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Per session rule matching (TC)
Date: 15 Sep 2003 13:24:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1063625053.2123.17.camel@henrik.marasystems.com>
References: <BAY3-F37iY6QYb6cnzu00038ebc@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Avi Lipa <alipa_54@msn.com>
In-Reply-To: <BAY3-F37iY6QYb6cnzu00038ebc@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

s=F6n 2003-09-14 klockan 16.33 skrev Avi Lipa:

> I think that supporting a dedicated entry in ip_conntrack for cached qu=
euing=20
> discipline rule matching
> is a capability that would improve performance for system where numerou=
s of=20
> classifiers are configured and
> deals with multiple sessions.

See the CONNMARK patch for one possible approach.

Regards
Henrik

--=20
Henrik Nordstrom <hno@marasystems.com>
MARA Systems AB
