From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Use of Kernel Headers
Date: Wed, 18 Aug 2004 22:03:48 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408182200120.23460@filer.marasystems.com>
References: <4122743A.7020309@jg555.com> <Pine.LNX.4.61.0408180123380.7879@filer.marasystems.com>
 <4122EADA.7030501@jg555.com> <Pine.LNX.4.61.0408182057060.23105@filer.marasystems.com>
 <4123AD42.8050803@jg555.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developer <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jim Gifford <maillist@jg555.com>
In-Reply-To: <4123AD42.8050803@jg555.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 18 Aug 2004, Jim Gifford wrote:

> So would the proper course of action to be to remove the kernel directory 
> from the iptables Makefile? or is there more to it.

Make it optional in the Makefile and make sure include/linux/netfilter* is 
up to date.

There is still value in allowing iptables to compile using the kernel 
headers, especially so during development of a new extensions but also to 
better match the kernel tree.

Regards
Henrik
