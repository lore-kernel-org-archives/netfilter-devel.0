From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 20:43:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F942CB6.5060005@trash.net>
References: <Pine.LNX.4.44.0310201133040.23768-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0310201133040.23768-100000@filer.marasystems.com>
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

>On Mon, 20 Oct 2003, Harald Welte wrote:
>  
>
>>again, this seems a shortcoming of the netlink infrastructure.  This
>>would be much better, if we'd actually have a reference to the socket of
>>the userspace process (since table dumps could be unicast anyway...).
>>    
>>
>
>If it is a shortcoming of netlink or a shortcoming of how to reliably dump 
>the content of a large hash buckets can be argued, but I tend to agree 
>with you here.
>
>The dump operation should be connetion oriented with the userspace 
>application, not purely datagram based. The kernel should know for certain 
>if the userspace application terminates a dump operation mid-air.
>

Actually the kernel knows. If the socket is closed cb->done() is called.
However the kernel can not know if userspace still keeps the socket open
but doesn't read anymore. Connection oriented sockets don't help with this.

Best regards,
Patrick
