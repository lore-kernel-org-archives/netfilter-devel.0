From: Pablo Neira <pablo@eurodev.net>
Subject: Re: "No buffer space available" upon ipq_read
Date: Thu, 29 Jul 2004 14:08:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4108E8B2.1070305@eurodev.net>
References: <20040729104449.GA2202@rie.rie.priv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Christian Riechmann <riechmann@fgan.de>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040729104449.GA2202@rie.rie.priv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Christian Riechmann wrote:

>	Which buffer is meant ? 
>  
>

there's a buffer in kernel space, if I remember well, when it gets full 
the socket flag overrun is set, that's why you get that error when you 
try to read() in user space.

>and
>	Which are some reasons for this error situation ?
>  
>

kernel has sent more messages than it can storage in the buffer.

>I use iptables- 1.2.9 and I am pretty sure, that all packets read into
>user space are verdicted. The user space program does not expand its used
>memory the more it runs.
>  
>

This is netlink related, note that libipq is built on top of netlink 
sockets so it inherits this limitation.

you could fix that setting a bigger buffer via sysctl:

echo 524280 > /proc/sys/net/core/rmem_default
echo 524280 > /proc/sys/net/core/rmem_max
echo 524280 > /proc/sys/net/core/wmem_default
echo 524280 > /proc/sys/net/core/wmem_max

regards,
Pablo
