From: pablo@correo.eurodev.net
Subject: Re: socket() call in iptables?
Date: Wed, 7 Jan 2004 21:18:09 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3670.212.79.158.153.1073506689.squirrel@eurodev.net>
References: <008901c3d536$13a35f50$0e25fe0a@southpark.ae.poznan.pl>
    <Pine.LNX.4.44.0401071659480.4717-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0401071659480.4717-100000@filer.marasystems.com>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> On Wed, 7 Jan 2004, Maciej Soltysiak wrote:
>
>> And here is the result. Please notice:
>> socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = -1 EPERM (Operation not
>> permitted)
>>
>> [Why is socket() called? Who is calling it, I did not find it anywhere
>> in
>> iptables,
>
> iptables needs to create a socket in order to be able to issue
> getsockopt() calls to the kernel to talk to the iptables kernel modules.
>
> Have you done any harderning of your kernel limiting what kind of socket
> operations root is allowed to perform?

It also uses socket() calls for netlink sockets, ulog and ip_queue use
them to communicate user space process with the kernel. Maybe it could
help you to find the problem.

cheers,

Pablo
