From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: filter for adding/checking TCP MD5 option
Date: Fri, 23 Jan 2004 13:03:57 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401231248320.12080-100000@filer.marasystems.com>
References: <E1Aitrb-0004cA-00@services3.virtu.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Remco van Mook <remco@virtu.nl>
In-Reply-To: <E1Aitrb-0004cA-00@services3.virtu.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 20 Jan 2004, Remco van Mook wrote:

> The first line would do something as follows:
> - decrease MSS to make the extra option fit (a staggering 18 bytes extra in
> the TCP header)
> - calculate the MD5 based on the key and the information contained in the
> packet
> - insert the TCP MD5 option field, recalculate checksum and send the packet
> on its way
> 
> The second line would:
> - check whether the MD5 matches the key
> - DROP the packet if it doesn't match
> - if the MD5 matches, strip off the MD5 option field, recalculate checksum
> and treat the packet as if nothing happened

Some conceptual changes to make this more in line with iptables:

1. a match which can verify the MD5 option. The same match should also be 
able to check if a MD5 option exists or not, allowing differentiation into 
the following packet classes:
   - Has valid TCPMD5 option
   - Has invalid TCPMD5 option
   - Does not have TCPMD5 option

2. a target which can add/delete/modify the MD5 option.


Note: As this is TCP payload dependent you need to make sure packets are 
defragmented before processed. This is most easily accomplished by 
depending on conntrack.


> As I'm a complete newbie when it comes to netfilter development, could
> anybody provide me some pointers on how to do this in the right way?
> Borrowing code from TCPMSS and using the Crypto API from the kernel for
> the MD5 checksum are things I'm currently considering.

Looks like a very reasonable approach to me.

If you look closely at the TCPMSS you will also notice there is a tcpmss 
match along the lines described above.

There is also a netfilter hacking howto which partially describes how to
write matches/targets which may be good to read if you have not already.

Note: The userspace part is found in the iptables tree under extensions in 
case you have not found these already.


Regards
Henrik
