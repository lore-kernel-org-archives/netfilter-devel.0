From: Eduardo Costa <ecosta@tpk.com.br>
Subject: Re: using libipq to create a router
Date: Tue, 23 Sep 2003 22:45:54 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F70CD22.3020606@tpk.com.br>
References: <Pine.LNX.4.44.0309240330140.5618-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0309240330140.5618-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

So, what happens if I want to NAT a trivial protocol, like HTTP ?

BTW, is there any "hello world" example for conntrack ? I've played 
creating kernel modules pretty easy, but the documentation about 
creating new routing nat targets are poor. The only good examples are 
'masquerade' and 'redirect', but they lack comments.

Thanks,
Eduardo Costa

Henrik Nordstrom wrote:

>You can't NAT non-trivial protocols via libipq unless you are implementing
>the full conntrack+nat in your application and not using the kernel
>conntrack/nat support at all (must not be loaded into the kernel). Any NAT
>done via libipq does not play well together with conntrack and the
>iptables nat engine is completely unaware of your packet modifications.
>
>For NAT together with iptables conntrack/nat you really need to use kernel
>modules in the nat iptable.
>
>Regards
>Henrik
>
>
>
>  
>
