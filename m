From: Jim Gifford <maillist@jg555.com>
Subject: Re: Use of Kernel Headers
Date: Wed, 18 Aug 2004 14:01:09 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4123C395.8080402@jg555.com>
References: <4122743A.7020309@jg555.com> <Pine.LNX.4.61.0408180123380.7879@filer.marasystems.com> <4122EADA.7030501@jg555.com> <Pine.LNX.4.61.0408182057060.23105@filer.marasystems.com> <4123AD42.8050803@jg555.com> <Pine.LNX.4.61.0408182200120.23460@filer.marasystems.com> <4123C0AA.7080708@jg555.com> <Pine.LNX.4.61.0408182250390.23616@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0408182250390.23616@filer.marasystems.com>
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
>> Doesn't patch-o-matic update the ones in iptables-version/include/linux?
>
>
> Nope.
>
>> So the the kernel and the iptables are built from the same headers? 
>> (Is this desired)
>
>
> Today yes, and probably desired while building with patch-o-matic 
> patches applied.
>
>> Or would it benefit iptables to include all the updated headers in 
>> iptables-version/include/linux?
>
>
> This would make things more clean cut separation between kernel and 
> userspace.
>
> Regards
> Henrik
>
So now what do we do to get these changes made, or is it going to be a 
distro specific thing?

-- 
----
Jim Gifford
maillist@jg555.com
