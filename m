From: don-nfil@isis.cs3-inc.com (Don Cohen)
Subject: Re: NAT for IPv6
Date: Sun, 23 Nov 2003 00:48:00 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <16320.29760.954039.292601@isis.cs3-inc.com>
References: <Pine.LNX.4.44.0311221301120.20371-100000@filer.marasystems.com>
	<Pine.LNX.4.58.0311230900510.31603@mercury.sdinet.de>
	<20031123082321.GA23141@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20031123082321.GA23141@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I didn't really want to discuss what ISPs were going to offer.  
I'll even refrain, with great effort, from discussing RFC3177.

My real question is what reason anyone would have for objecting to
NAT.  So far I don't understand the end-to-end argument.  As I read
the RFCs the main argument is that places where there is a choice in
routing should not maintain connection state because the routing might
change.  If a connection between points A and B might and might not be
forwarded through point C then I agree that point C should not be
doing NAT on those packets.  The same applies to any other sort of
connection tracking.  However, I think a good definition of a firewall
is that it's a machine through which certain traffic MUST pass, and
for such a machine to do NAT on that traffic still seems reasonable.

Please enlighten me.
