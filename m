From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: How do I use ip_conntrack_destroyed?
Date: Wed, 3 Dec 2003 22:57:37 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312032243000.11739-100000@filer.marasystems.com>
References: <3FCDD197.6050700@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
In-Reply-To: <3FCDD197.6050700@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 3 Dec 2003, Emmanuel Guiton wrote:

> I am writing a new target module which needs to be aware about the 
> number of conntracks that are currently known for a particular 
> destination. Thus, to make my counter I wish to detect when a conntrack 
> is destroyed. I have noticed the following in ip_conntrack.h :
> 
> /* Call me when a conntrack is destroyed. */
> extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);

Unfortunately the comment is somewhat misleading.. while this is indeed
called when the ip conntrack is destroyed there is only one of this and it
is reserved for use by NAT. So if you use this then your target becomes 
mutually exclusive with the use of NAT which is maybe not what you want.

If you want to do this I think you should first extend
ip_conntrack_destroyed into a list of handlers with a suitable
registration functions to allow more than one module to register a 
"ip_conntrack_destroyed" function.

Regards
Henrik
