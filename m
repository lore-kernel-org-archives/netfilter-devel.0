From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: how to parse options?
Date: Sat, 29 Nov 2003 19:35:44 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311291928460.20615-100000@filer.marasystems.com>
References: <3FBE2337.8090901@tom.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: nicho <fessboy@tom.com>
In-Reply-To: <3FBE2337.8090901@tom.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 Nov 2003, nicho wrote:

> As we know, in kernel there is a structure called multi_range. When we
> do nat, we choose a proper IP from the multi_range, and a proper port if
> necessory. My question is, how multi_range is set into kernel, and how
> option '--to-source' is parsed?

userspace/extensions/libipt_SNAT.c parses the option.

The multi_range is sent as part of the target data when the table ruleset
is installed in the kernel.

>     By the way, I'm confused at getsockopt(... SO_GET_ENTRY...) . As the
> name implies, we want to get entry info from kernel, but why it dose
> copy data from user level to kernel level indeed. What does it do at all?

I don't have a SO_GET_ENTRY in the sources I have... what kernel are you 
using?

Note: The iptables kernel interface are subject to change and should not
be relied upon.  It is better if you call the iptables or
iptables-save/restore commands which is a well defined interface and also 
has the correct infrastructure for building iptables to be installed into 
the kernel.

Regards
Henrik
