From: Poltorak Serguei <poltorak@df.ru>
Subject: target MARK in filter table?
Date: Sun, 13 Jul 2003 05:34:22 +0400 (MSD)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.3.95.1030713053210.10817A-100000@cannabis.dataforce.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Why not to allow MARK packets in filter table? As i know it doesn't mangle
(change) the packet, it changes only information about it on local this
router. So, why not to use it widely in filter table?

PoltoS/
