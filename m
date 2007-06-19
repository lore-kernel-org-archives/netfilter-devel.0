From: Amin Azez <azez@ufomechanic.net>
Subject: Re: change next hop or destination MAC after routing
Date: Tue, 19 Jun 2007 13:12:01 +0100
Message-ID: <4677C811.6030707@ufomechanic.net>
References: <d41814cf0706190406o7e983be5u38c29e5d544c6918@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: pankaj jain <jainp1979@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <d41814cf0706190406o7e983be5u38c29e5d544c6918@mail.gmail.com>
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

* pankaj jain wrote, On 19/06/07 12:06:
> Hi,
> 
> In machine generated packets, can I change the next hop OR destination
> MAC after routing?
> Is it possible to do this in POSTROUTING table of iptables or ebtables?
> 
> Do we have any other technique to achieve the same? Any utility /
> patch / kernel change etc ?

The "route" match might achieve this for you; it works though by
transmitting the packet instantly and may skip any remaining rules
depending on how you use it.

Or maybe you could use ebtables DNAT, I suspect that is a better way.

You could use a packet mark to communicate this intent to ebtables.

Sam
