From: Pablo Neira <pablo@eurodev.net>
Subject: Re: How to avoid fragmentation
Date: Thu, 27 Oct 2005 14:41:07 +0200
Message-ID: <4360CAE3.6030600@eurodev.net>
References: <435D40ED.1080109@speedy.com.ar> <435D701C.1080501@eurodev.net>
	<435D6030.8000509@speedy.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gervasio Bernal <gervasiobernal@speedy.com.ar>
In-Reply-To: <435D6030.8000509@speedy.com.ar>
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

Hi,

Gervasio Bernal wrote:
> I will show you an example:
> 
> +---------------+	
> |    IP		|	
> |    header 	|	
> |---------------|
> |    TCP	|
> |    header 	|
> |---------------|
> |  My header	|
> |---------------|
> |		|
> |   USER DATA	|
> |		|
> +---------------+
> 
> I calculte the USER DATA checksum and put it in a field of My header.
> If the packet is larger than MTU, it will be fragmented and the checksum
> calculated in My header will be incorrect when I recieve it in the other
> endpoint of the communication.
> 
> There is some form to avoid the fragmentation?

In this case, have a look at skb_checksum()

-- 
Pablo
