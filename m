From: Jim Gifford <maillist@jg555.com>
Subject: Re: Use of Kernel Headers
Date: Wed, 18 Aug 2004 13:48:42 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4123C0AA.7080708@jg555.com>
References: <4122743A.7020309@jg555.com> <Pine.LNX.4.61.0408180123380.7879@filer.marasystems.com> <4122EADA.7030501@jg555.com> <Pine.LNX.4.61.0408182057060.23105@filer.marasystems.com> <4123AD42.8050803@jg555.com> <Pine.LNX.4.61.0408182200120.23460@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0408182200120.23460@filer.marasystems.com>
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

> On Wed, 18 Aug 2004, Jim Gifford wrote:
>
>> So would the proper course of action to be to remove the kernel 
>> directory from the iptables Makefile? or is there more to it.
>
>
> Make it optional in the Makefile and make sure 
> include/linux/netfilter* is up to date.
>
> There is still value in allowing iptables to compile using the kernel 
> headers, especially so during development of a new extensions but also 
> to better match the kernel tree.
>
> Regards
> Henrik
>
Doesn't patch-o-matic update the ones in iptables-version/include/linux?
    So the the kernel and the iptables are built from the same headers? 
(Is this desired)
   
Or would it benefit iptables to include all the updated headers in 
iptables-version/include/linux?

I don't mean to be pest on this, I just want the best solution possible 
for anyone who uses iptables.

-- 
----
Jim Gifford
maillist@jg555.com
