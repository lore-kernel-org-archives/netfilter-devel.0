From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Re: How to limit the rate of the TCP connections from a subnet?
Date: Mon, 08 Nov 2004 07:01:20 -0500
Message-ID: <418F6010.4050308@cookinglinux.org>
References: <MHEFLEOMPIPCIFEKLNIPEEGGCAAA.lu.peng.louis@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "lu.peng" <lu.peng.louis@163.com>
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

lu.peng wrote:

>Hi, all,
>
>      I want to limit the rate of the TCP connections of every single ip from a specific subnet, but i can't find a good way to do that.
>  
>
So, that's netfilter@lists.netfilter.org question ?

> <>
> I have studied two matches:
> 1, 'connlimit' match
> but unfortunately, 'connlimit' match provide two ways to limit the sum
> of the TCP connections:
> 1) single IP
> 2) whole subnet not every single ip of the subnet
> and most importantly, it can not limit the rate , just limit the sum
> of the TCP connections.
>
> 2, 'limit' matches:
> I can use '-p tcp --syn -m limit --limit 6/m ......' to limit the rate
> of the TCP connections of the whole subnet or single ip. if i want to
> limit the rate of every single ip of the specific subnet, I should set
> a ule for every ip.
> what i want is : only one rule can achieve ---limit the rate of the
> TCP connections of every single ip from a specific subnet.
>
And what about 'recent' match ?
