From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: NetBIOS datagram nat helper proposal
Date: Mon, 19 Sep 2005 17:10:15 -0400
Message-ID: <1127164215.25000.44.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

It appears that we may need a netbios datagram NAT helper.  Unless we
can find a workaround, it we have encountered a couple of environments
where we need to NAT netbios datagram packets.  Since they have embedded
IP address information in the netbios header, this protocol breaks with
NAT.  We see the packets enter the server with the NAT address but the
replies are addressed to the original address as per the netbios header.

We have not seen such a helper within netfilter.  There appears to be a
simple helper for this at
http://suif.stanford.edu/~csapuntz/ip_nat_netbios.c

We are seeing if we have the resources to finish and polish this patch
and submit it.  It seems that we then simply post it to this list to
submit it.  Is that the correct procedure?

We are likely not to have the in-house resources to do this.  We might
be interested in sponsoring someone to write this patch.  If you are
interested, please contact me.  Thanks - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

If you would like to participate in the development of an open source
enterprise class network security management system, please visit
http://iscs.sourceforge.net
