From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: sk_buff examples
Date: Sat, 4 Dec 2004 15:57:06 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412041556190.14126@filer.marasystems.com>
References: <OFB4CE1F6C.C2B29CDF-ON86256F5F.006018FF-86256F5F.00609A78@ra.rockwell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Steven J Scott <sjscott@ra.rockwell.com>
In-Reply-To: <OFB4CE1F6C.C2B29CDF-ON86256F5F.006018FF-86256F5F.00609A78@ra.rockwell.com>
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

On Fri, 3 Dec 2004, Steven J Scott wrote:

> I am trying to decode packets within the kernel using netfilter hooks, and
> I have read through multiple examples of parsing the src and dst address,
> ports, etc., but I am unable to find any information on parsing the
> payload of the packet.  What I am trying to do is examine payload to find
> a string match. Could anyone point me in the right direction.

See either the NAT helpers or the STRING match.

Beware of non-linear SKBs in Linux-2.6. Looking into the payload is not as 
easy as it was in Linux-2.4.

Regards
Henrik
