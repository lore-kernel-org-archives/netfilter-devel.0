From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: socket() call in iptables?
Date: Wed, 7 Jan 2004 17:01:31 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401071659480.4717-100000@filer.marasystems.com>
References: <008901c3d536$13a35f50$0e25fe0a@southpark.ae.poznan.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <008901c3d536$13a35f50$0e25fe0a@southpark.ae.poznan.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 7 Jan 2004, Maciej Soltysiak wrote:

> And here is the result. Please notice:
> socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = -1 EPERM (Operation not permitted)
> 
> [Why is socket() called? Who is calling it, I did not find it anywhere in
> iptables,

iptables needs to create a socket in order to be able to issue
getsockopt() calls to the kernel to talk to the iptables kernel modules.

Have you done any harderning of your kernel limiting what kind of socket 
operations root is allowed to perform?

Regards
Henrik
