From: "Jiangbo Li" <jiangbo@cs.uky.edu>
Subject: How to reflect received packet in PreRouting hook
Date: Sat, 29 Mar 2003 01:19:36 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000101c2f5bb$2c7379d0$fe9d10ac@ljb>
Reply-To: <jiangbo@cs.uky.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear all,

I am developing a kernel module to handle IP packet. My problem is 
how to reflect received packet to the sender.

I got the packet by a NF_PRE_ROUTING hook. I switched the source 
and destination address( which is local address ) of the IP header, and 
then return NF_ACCEPT.But after doing this, the packet will be dropped.

If I switch the src and dst address, and modify the src(local) address
to  be a non local address. The packet will traverse the FORWARD and 
POST_ROUTING hooks, and will be send back to the sender.

But change the src address to be a non-local address is not allowed in
my project. 

How to solve this problem.

Thank you very much

Jiangbo Li
