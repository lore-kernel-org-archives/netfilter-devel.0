From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Counter problem in a new nat target.
Date: Mon, 8 Dec 2003 13:28:51 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312081319100.10693-100000@filer.marasystems.com>
References: <3FD46638.5000300@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
In-Reply-To: <3FD46638.5000300@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 8 Dec 2003, Emmanuel Guiton wrote:

> Does someone has a good advice on where I can store my variable? Can I 
> use the void *userdata ? (I do not really know to what it points).

You should be able to use the userdata I think. It is a pointer to the
original targetinfo sent/seen by userspace iptables command. The kernel
operates on another copy of the table per CPU. But I would not recommend 
doint this. I think it is better if you keep the needed counters 
elsewhere. You can use reference counting from the check/destroy functions 
to determine which counters you need to maintain.

Regards
Henrik
