From: Wayne Schroeder <raz@positivenetworks.net>
Subject: What basic sanity checking on packet headers is done
Date: Fri, 29 Sep 2006 11:20:53 -0500
Message-ID: <451D47E5.7000108@positivenetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

I've written a new target module that uses the ip header fields of ihl
and tot_len for offsets into the packets.  How safe is the data in the
ip headers?  Is there sanity checking when the packet is received off
the wire... for instance -- is it safe to assume in the prerouting chain
of the mangle table that tot_len will not put me past the memory
allocated for the packet?  Same goes for ihl?

Wayne
