From: "Maciej Soltysiak" <solt@dns.toxicfilms.tv>
Subject: Re: socket() call in iptables?
Date: Wed, 7 Jan 2004 17:43:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <009301c3d53d$6d0f0c90$0e25fe0a@southpark.ae.poznan.pl>
References: <Pine.LNX.4.44.0401071659480.4717-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> iptables needs to create a socket in order to be able to issue
> getsockopt() calls to the kernel to talk to the iptables kernel modules.
> 
> Have you done any harderning of your kernel limiting what kind of socket 
> operations root is allowed to perform?
The person that reported it says, he is using grsecurity with raw_socket
capabilites restricted within chroot.

I did not know that socket() needed to be called. I will recommend removing
that restriction.

> Regards
> Henrik
Maciek
