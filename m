From: "zze-Proxy GRALL O ext FTRD/SVA/LAN" <ograll.ext@rd.francetelecom.com>
Subject: Apply rules to 1 UDP port but port used as a socket: possible?
Date: Tue, 10 Feb 2004 14:18:03 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <D4EF10CCEB2CE742BEEA9838C590B0E80113FA46@ftrdmel2.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Class: urn:content-classes:message
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

Hello to IPTables developpers,

I'm trying to use a socket (on port 1727) to decode some proprietary UDP
packets. When I've decoded them I want to apply a DNAT rule (and then a
SNAT  too) to this port using a filter on @IP:port source for all
following packets...

I use libiptc to manage iptables from my application.

My problem is that I can't apply rule to the packets. They all arrive on
the socket. I think it may be due to connection tracking but I would
like your points of view to be sure.

Is there any solution to do it ? For the moment I use v1.2.5a but I'm
installing v1.2.9.

Thanx in advance,

Olivier GRALL.
