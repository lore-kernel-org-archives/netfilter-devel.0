From: Jonathan Cooper <netfilter@jonc.me.uk>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Fri, 12 Mar 2004 11:39:14 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040312113914.GB1859@finarfin.cooper.xfnet>
References: <20040311160401.GA1565@finarfin.cooper.xfnet> <20040311165037.GA1615@finarfin.cooper.xfnet> <20040311211725.GA11634@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040311211725.GA11634@sch.bme.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

* Kovacs Krisztian <piglet@sch.bme.hu> [2004-03-12 00:04]:
>   Could you try turning CONFIG_IP_NF_NAT_LOCAL on?

I've just tried this, and find I can now fetch pages via the masqueraded
interface from the machine itself, with no occurrences of LIST_DELETE
messages. Fetching pages from my other computer on the masqueraded
network also works.

So this seems to fix the problem. I'll keep the kernel running with debug
on for a bit just in case.

Jonathan.

-- 
Jonathan Cooper        MSN: msn@jonc.me.uk        jonc.me.uk/

A clear concience is usually the sign of a bad memory.
