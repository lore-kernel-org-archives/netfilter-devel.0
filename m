From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables and external processes
Date: Wed, 18 Feb 2004 08:07:34 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402180805280.10964-100000@filer.marasystems.com>
References: <1077086620.2010.49.camel@ca.gts.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Allen Francom <aef@prismnet.com>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
In-Reply-To: <1077086620.2010.49.camel@ca.gts.nexusmgmt.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 18 Feb 2004, John A. Sullivan III wrote:

> So then what I am looking for really sounds like a new match.  Something
> like iptables -A FORWARD -m ua --ua -j SOMECHAIN.

This only works if your new match can be evaluated immediately within the 
kernel. It is not possible to write a match which will ask userspace.

> I would imagine it is the essence of any match to examine the contents
> of the layer 3 and 4 headers, pass them to a boolean function and match
> or not match on the return value of that function.  Are there any
> caveats in what I have described?

Not as long as you want to stay within the kernel, and don't need to wait 
for anything.

Regards
Henrik
