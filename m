From: quadong@users.sourceforge.net
Subject: [PATCH] Layer7 v0.6
Date: Tue, 17 Feb 2004 18:52:19 -0600 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.60.0402171851160.3450@dsl093-017-216.msp1.dsl.speakeasy.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: l7-filter-developers@lists.sf.net, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I've released a new version of the layer7 patch on sourceforge:

http://sourceforge.net/project/showfiles.php?group_id=80085

It's significantly cleaned up in terms of CodingStyle, GPL notices, file
locations, and so on.  The childlevel code has been removed from it.  I've
attempted to make it SMP-safe, but I'd love for someone who's done this
before to read it over and see if I've done it right.

-matthew
