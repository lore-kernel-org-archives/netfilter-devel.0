From: Jim Gifford <maillist@jg555.com>
Subject: Re: Use of Kernel Headers
Date: Wed, 18 Aug 2004 12:25:54 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4123AD42.8050803@jg555.com>
References: <4122743A.7020309@jg555.com> <Pine.LNX.4.61.0408180123380.7879@filer.marasystems.com> <4122EADA.7030501@jg555.com> <Pine.LNX.4.61.0408182057060.23105@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0408182057060.23105@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:

> On Tue, 17 Aug 2004, Jim Gifford wrote:
>
>> Ok so we build iptables against the linux-libc-headers, then we then 
>> use patch-o-matic-ng to add new support for psd(insert you own 
>> example). But iptables is set to compile using the 
>> linux-libc-headers, won't the compile fail since it can't find 
>> ipt_psd.h in the linux-libc-headers.
>
>
> Correct.
>
> You then need to build your iptables to your modified Linux kernel 
> headers, or copy include/linux/netfilter_ipv?/* to your iptables 
> include directory.
>
>> If patch-o-matic changes a header, it should also check 
>> /usr/include/linux/netfilter{whatever} and patch that file also so 
>> they are insync with each other.
>
>
> No. This would not work as /usr/include/linux/ does not need to match 
> the kernel you are currently patching.
>
> What would be OK is for pom to modify the iptables include directory.
>
> Regards
> Henrik
>
Thanx Henrik for the reply, there are a lot of people out there trying 
to figure out what do on this issue.

So would the proper course of action to be to remove the kernel 
directory from the iptables Makefile? or is there more to it.

-- 
----
Jim Gifford
maillist@jg555.com
