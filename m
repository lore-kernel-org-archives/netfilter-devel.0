From: quadong@users.sourceforge.net
Subject: childlevel's pom comment
Date: Wed, 3 Mar 2004 19:48:18 -0600 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.60.0403031947450.8957@dsl093-017-216.msp1.dsl.speakeasy.net>
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

Hi, I noticed that the childlevel patch currently has this to say about
itself in patch-o-matic:

	"This adds CONFIG_IP_NF_MATCH_CHILDLEVEL option, which be used to
	match the childlevel of a connection."

I know _I_ would be confused if I read this.  Could it be changed to the
following?

	This patch allows you to match on the childlevel of a connection.
	A master connection, such as the command stream of FTP, has a
	childlevel of zero, its first child, such as the data stream of
	FTP, has a childlevel of one.  Usage example:

	iptables ... -m childlevel --level 1 ...

Thanks,
matthew
