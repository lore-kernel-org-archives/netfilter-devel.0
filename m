From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Use of Kernel Headers
Date: Sat, 21 Aug 2004 17:13:55 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408211708260.19071@filer.marasystems.com>
References: <4122743A.7020309@jg555.com> <Pine.LNX.4.61.0408180123380.7879@filer.marasystems.com>
 <Pine.LNX.4.58.0408182356030.5432@blackhole.kfki.hu> <4126F018.207@jg555.com>
 <Pine.LNX.4.61.0408211114310.16646@filer.marasystems.com>
 <876ef97a0408210753109a2fc4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jim Gifford <maillist@jg555.com>,
   Netfilter Developer <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
In-Reply-To: <876ef97a0408210753109a2fc4@mail.gmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 21 Aug 2004, Tobias DiPasquale wrote:

> Perhaps a special macro could be used to demarcate the sections of
> kernel headers that are for userspace use (opposite of what __KERNEL__
> does now).

#ifndef __KERNEL__

works well for this purpose.

How the system user headers are composed is of no concern to iptables. 
What iptables need to worry about to solve this issue is to supply it's 
own required headers defining the current iptables kernel interface the 
iptables commands should use, allowing the userspace commands to be built 
without the kernel source.

Regards
Henrik
