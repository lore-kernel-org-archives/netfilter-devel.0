From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: fisrt post on the list whit a few questions
Date: Fri, 12 Mar 2004 19:31:02 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403121924420.3948-100000@filer.marasystems.com>
References: <20040312172242.24681180EE@smtp.latinmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jorge Garcia <anarkophobia@latinmail.com>
In-Reply-To: <20040312172242.24681180EE@smtp.latinmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 12 Mar 2004, Jorge Garcia wrote:

> Im using netfilter iptables for about 4 months and i really like the
> product, now im reading about the netfilter programming modules that i
> find in a phrack article. The modules dont do ehat is expected to do,
> like in list2.c the program filter input and output interfaces. If i
> want to filter only incoming packets, how do i do that??

I am not familiar with the example source mentioned, but to filter input 
packets you hook into the NF_IP_LOCAL_IN hook (packets accepted locally) 
or NF_IP_PRE_ROUTING hook (packets entering the system from network).

Most people doing filtering uses iptables, where you already have a very 
rich set of filtering capabilities.

> My second question its about security, the security advisories on the
> page are old ones and doesnt work for new kernels.

This is because there has not been a need for any newer advisories, and 
the old ones are already corrected in new kernels..

> I want to know if is there any vulneability more new for testing becouse
> im writing a paper about netfilter security in spanish.

I guess that is a paper about iptables security?

Netfilter is just the framework in the kernel allowing firewalling etc to
access the packets.  iptables is the standard firewall implementation
using the hooks provided by netfilter.

Regards
Henrik
