From: "Daniel Chemko" <dchemko@smgtec.com>
Subject: CONNMARK again..
Date: Mon, 22 Mar 2004 15:44:47 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <7C9884991ADAE0479C14F10C858BCDF5122F25@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ok, I wrote a few weeks back about getting policy routing working. I
did!

The problem is that I've updated to the latest 2.4 POM and -j CONNMARK
--save-mark doesn't seemt o be working anymore. I am using iptables
1.2.9 for my userspace.

Stripped down example of my problem:

This works:
14053 6109K CONNMARK   all  --  *      *       0.0.0.0/0
0.0.0.0/0           CONNMARK restore
12788 6021K ACCEPT     all  --  *      *       0.0.0.0/0
0.0.0.0/0           MARK match !0x0
   15  1282 MARK       all  --  eth1   *       0.0.0.0/0
0.0.0.0/0           MARK match 0x0 MARK set 0x4
   15  1282 CONNMARK   all  --  eth1   *       0.0.0.0/0
0.0.0.0/0           CONNMARK match 0x0 CONNMARK set 0x4
 1263 87899 CONNMARK   all  --  *      *       0.0.0.0/0
0.0.0.0/0           CONNMARK save

This doesn't:
14053 6109K CONNMARK   all  --  *      *       0.0.0.0/0
0.0.0.0/0           CONNMARK restore
12788 6021K ACCEPT     all  --  *      *       0.0.0.0/0
0.0.0.0/0           MARK match !0x0
   15  1282 MARK       all  --  eth1   *       0.0.0.0/0
0.0.0.0/0           MARK match 0x0 MARK set 0x4
 1263 87899 CONNMARK   all  --  *      *       0.0.0.0/0
0.0.0.0/0           CONNMARK save

The CONNMARK mark is never updated with the value from MARK. Has there
been any recent changes that would have broken this functionality?
