From: Henrik Nordstrom <hno@marasystems.com>
Subject: FYI: iptables binary compatibility mess
Date: Thu, 30 Oct 2003 01:56:54 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310300142250.32233-100000@filer.marasystems.com>
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

This is just a notice that there seems to be a p-o-m patch in 2.4
pending/base CVS which breaks compatibility with older iptables binaries.

Noticed this when after a kernel upgrade to 2.4.22+latest p-o-m our
iptables 1.2.8 (CVS 15 May) binaries no longer worked. It could list the
(empty) tables, but any attempts to insert any kind of rule was always
rejecter by the kernel, even the simplest "null" rule without any matches 
or targets.

The errors returned was someting like the following:

  iptables -A INPUT
  Invalid argument

  iptables-restore
  *filter
  COMMIT
  Error occurred at line: 2


A recompile of iptables to the current CVS version corrected the problem.

Regards
Henrik
