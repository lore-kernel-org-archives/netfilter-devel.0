From: "Neville C. Dempsey" <NevilleD.Netfilter@sgr-a.net>
Subject: revisit: ipset nethash set type limited to /31
Date: Fri, 17 Aug 2007 16:54:30 +1000
Message-ID: <1187333670.3949.81.camel@delta.sgr-a.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

(Original post on netfilter@lists.netfilter.org: 
https://lists.netfilter.org/pipermail/netfilter/2007-August/069497.html)

My employer has an interest in having enhancing the functionality of
netfilter/trunk/ipset/ipset_nethash.c with the 2.6.18+ kernels and is
exploring the possibility of sponsoring a netfilter developer to make
this happen.

As ipset_nethash.c stands it handles subnet masks from /1 to /31 fine,
but the cases /0 & /32 are required to be handled in a different chain.
unifying these would vastly simplify and reduce our rules.  And reduce
the delay it takes to update some rule sets.  Is there anyone interested
in doing this?

There has been some previous discussion on this in March last year:
http://lists.netfilter.org/pipermail/netfilter/2006-March/065088.html
http://lists.netfilter.org/pipermail/netfilter/2006-March/065090.html

In particular:
http://lists.netfilter.org/pipermail/netfilter/2006-March/065091.html
This explains that the IPAddr & Mask is stored in 32 bits, leaving no
room for /0 & /32.

http://lists.netfilter.org/pipermail/netfilter/2006-March/065130.html
Jozsef suggested a potentially alternative method of a "union" set type.
Did anyone manage to implement this new type?

We are still wondering about the /0 & /32 "subnets".  /0 could be handled
as a special case, if the IPAddr & Mask was allowed to use more then 4
bytes, eg 5.  Then at the cost of 25% more memory in the hash we could
in some cases half the number of netfilter entries.

If it helps, we also have resources available to test development versions
of the ipset_nethash.c

ThanX
Neville Dempsey
Developer @ NetBox Blue (http://netboxblue.com)
