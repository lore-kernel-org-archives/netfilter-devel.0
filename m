From: Jvalencia <tigrezno@log01.org>
Subject: Re: How to limit the rate of the TCP connections from a subnet?
Date: Mon, 8 Nov 2004 11:56:09 +0000
Message-ID: <20041108115609.6c95213a.tigrezno@log01.org>
References: <MHEFLEOMPIPCIFEKLNIPEEGGCAAA.lu.peng.louis@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <MHEFLEOMPIPCIFEKLNIPEEGGCAAA.lu.peng.louis@163.com>
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


> 
> Hi, all,
> 
>       I want to limit the rate of the TCP connections of every single ip from a specific subnet, but i can't find a good way to do that.
> 

You can always use a simple script to generate a list of iptable rules for the specified subnet. A simple bash "for" can do it.
