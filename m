From: Steven J Scott <sjscott@ra.rockwell.com>
Subject: sk_buff examples
Date: Fri, 3 Dec 2004 11:35:28 -0600
Message-ID: <OFB4CE1F6C.C2B29CDF-ON86256F5F.006018FF-86256F5F.00609A78@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

Hello,

I am trying to decode packets within the kernel using netfilter hooks, and 
I have read through multiple examples of parsing the src and dst address, 
ports, etc., but I am unable to find any information on parsing the 
payload of the packet.  What I am trying to do is examine payload to find 
a string match. Could anyone point me in the right direction.

Thanks a lot.

Steve
