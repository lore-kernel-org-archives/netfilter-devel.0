From: Jeff Hall <hall@vdata.com>
Subject: PPTP connection tracking and NAT patches
Date: Fri, 21 Mar 2003 21:05:12 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.03.10303212057150.27231-100000@shemp.vdata.com>
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

The explanation I gave for the problem running the PoPToP server in my
previous message was incorrect. What I should have said was that without
CONFIG_IP_NF_NAT_LOCAL there is no LOCAL_IN hook, and pptp_nat_expected
is not called to setup the SRC manip in the original direction (no manip
is required) AND the DST manip in the reply direction. The missing DST
manip in the reply direction broke the connection.
