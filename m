From: Pablo Neira <pablo@eurodev.net>
Subject: Re: netfilter hook not working with fragments
Date: Thu, 10 Feb 2005 23:06:00 +0100
Message-ID: <420BDAC8.3080300@eurodev.net>
References: <19c901c50f35$a4afb8b0$a610a8c0@niche>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
To: Michael Varga <mike.varga@cavium.com>
In-Reply-To: <19c901c50f35$a4afb8b0$a610a8c0@niche>
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

Michael Varga wrote:

>Hi,
>
>I wrote a NF_IP_PRE_ROUTING hook to capture packets
>for an IPSec implimentation.
>
>Is there a way to make netfilter assemble fragments before=20
>recieving them in my netfilter hook?
>  
>

If you use a kernel 2.4, you won't see any fragments since netfilter 
assembles them before hitting NF_IP_PRE_PREROUTING. On the other hand, 
if your box runs a kernel 2.6,  assemble them by yourself. Have a look 
at skb_linearize. Previously check that it's non linear with 
skb_is_non_linear.

http://lxr.linux.no/source/include/linux/skbuff.h#L1041
http://lxr.linux.no/source/include/linux/skbuff.h#L655

Since you get packets from interrupt context, make sure you pass the 
GFP_ATOMIC flag to skb_linearize.

--
Pablo
