From: "Ryan Hagelstrom" <rhagelstrom@atcorp.com>
Subject: Hardware Address
Date: Mon, 27 Sep 2004 10:37:36 -0500
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <018401c4a4a7$ea627030$b2aca8c0@AMBERJACK>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I'm building my one netfilter kernel module.

When filtering outgoing packets using the netfilter rules, the packets =
that
I get do not have the hardware header on the packet on them. It seems =
that
the hardware header is placed on the packet after the packet has gone =
though
netfilter. Can anyone suggest any way to get the hardware header for an
outgoing packet? I'm looking for a good workaround approach.


Thanks


Ryan Hagelstrom
