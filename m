From: Stephen Hemminger <shemminger@osdl.org>
Subject: TCP traversal through NATs
Date: Thu, 20 Oct 2005 14:02:14 -0700
Message-ID: <20051020210214.GA7366@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Has anyone looked at recent work on allowing two machines
both behind NAT firewalls to establish a connection. There is information
at http://nutss.gforge.cis.cornell.edu/stunt.php

Interestingly, they classify NAT's by how they assign ports.
It would be interested to make sure netfilter is doing the right
thing.
