From: "Laurence J. Lane" <ljlane@nontoxic.org>
Subject: ip6tables.8.in, no LOG, MARK or REJECT
Date: Sat, 17 Jul 2004 10:33:45 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040717143345.GA20408@ljlane.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

ip6tables.8.in appears to be missing the LOG, MARK, and
REJECT targets -- which are all in a contiguos chunk in
the old ip6tables.8.
