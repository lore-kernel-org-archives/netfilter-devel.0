From: Patrick McHardy <kaber@trash.net>
Subject: Re: VPN Masq support in new kernel?
Date: Mon, 20 Oct 2003 05:04:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9350A7.9010704@trash.net>
References: <BAY2-F83HXbgp0UcS380000ad32@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Dave B <dragin33@hotmail.com>
In-Reply-To: <BAY2-F83HXbgp0UcS380000ad32@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dave B wrote:

> Hi, i was just wondering if anyone could tell me if VPN Masquerading 
> support would be built into the new 2.6 kernel or not.  If not, do you 
> know where i can find a patch/module that's compatable with 2.6?
>

"VPN Masquerading" or NAT-Traversal is not really related to netfilter, 
however
the 2.6 ipsec implementation has support for NAT-T. That only means you can
make ipsec connections that are masqueraded, not that the box itself 
could do
anything to make masquerading work for other clients using ipsec without 
NAT-T.

Best regards,
Patrick
