From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: iptables and external processes
Date: Wed, 18 Feb 2004 01:43:41 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1077086620.2010.49.camel@ca.gts.nexusmgmt.com>
References: <Pine.LNX.4.44.0402180726110.10256-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Allen Francom <aef@prismnet.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0402180726110.10256-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-02-18 at 01:27, Henrik Nordstrom wrote:
> On Wed, 18 Feb 2004, John A. Sullivan III wrote:
> 
> > It sounds like this would be a problem using QUEUE.  Have I understood
> > you correctly? Thanks - John
> 
> You can not use QUEUE between rules in the same table. Only as final rule 
> in a table. Changing this is far from trivial.
> 
> Regards
> Henrik

So then what I am looking for really sounds like a new match.  Something
like iptables -A FORWARD -m ua --ua -j SOMECHAIN.

I would imagine it is the essence of any match to examine the contents
of the layer 3 and 4 headers, pass them to a boolean function and match
or not match on the return value of that function.  Are there any
caveats in what I have described? Again, I confess my complete ignorance
of writing iptables patches and of the netfilter code -- just trying to
ascertain if it is worth finding a volunteer or contractor to write the
proposed patch or if we are pursuing a dead end.  Thanks - John
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
