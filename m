From: "VeNoMouS" <venom@gen-x.co.nz>
Subject: iptables bidirectional flag support
Date: Tue, 11 Jan 2005 13:45:29 +1300
Message-ID: <001701c4f776$d9eee450$5746370a@nsp.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Is iptables going to ever have a birectional flag like in ipchains. =
Reason im asking this is things like quota patch from PoM would then be =
able to work on a bidirectional level which would give the effect of a =
shared data pool for both directions, rather then a byte quota for 1 =
direction or having to create a new table and 3 rules

IE


iptables -I FORWARD -s x.x.x.x -j QUOTA_TABLE
iptables -I FORWARD -D x.x.x.x -j QUOTA_TABLE

iptables -I QUOTA_TABLE --quota 50000000 -j ACCEPT

say something like that could be done with iptables -I FORWARD -s =
x.x.x.x -b --quota 50000000 -j ACCEPT you can see how much simpler that =
would be.
