From: "Egon Phillips" <egon.phillips@sympatico.ca>
Subject: Owner on Input table
Date: Sat, 12 Feb 2005 19:26:35 -0500
Message-ID: <000101c51162$aceabfa0$9600a8c0@netcontent>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
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

I read in the docs that the owner match as described below is not
available on the input chain.

    This module attempts to match various
    characteristics of the packet creator, 
    for locally-generated packets. It is 
    only valid in the OUTPUT chain, and even
    this some packets (such as ICMP ping responses)
    may have no owner, and hence never match. 

Are there any plans to change this policy?  If not, is this a limitation
of the software or of the OS?  Is it not possible to use the destination
ports process id to determine the owner?
____________________________________________________
The Brockton Initiative (http://brockton.dyndns.org)
Egon Phillips, Chair
