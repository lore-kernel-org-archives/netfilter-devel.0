From: Pablo Neira <pablo@eurodev.net>
Subject: Re: it is possible to use inet_addr
Date: Tue, 03 Aug 2004 09:09:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <410F3A36.1060906@eurodev.net>
References: <000a01c4791a$fe672660$a06464c0@kesineni>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kesineni sai pratap <kesineni@woojininc.net>
In-Reply-To: <000a01c4791a$fe672660$a06464c0@kesineni>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

This question is not netfilter related at all, maybe linux-net is a 
better place, anyway...

kesineni sai pratap wrote:

> Hello,
>  
>           Iam changing  netif_receive_skb () function in  in 
> /usr/src/linux/net/core/dev.c.i  unable  to use inet_addr function in 
> netif_receive_skb function.


because that function doesn't exist in kernel space. The kernel is 
written in C but it doesn't implement all the standard C functions 
available in user space.

If you do want to use something that function, you should implement by 
yourself or steal it from elsewhere.

regards,
Pablo
