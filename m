From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] peer_pid checking in ip_queue
Date: Wed, 24 Mar 2004 01:42:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4060D969.9040900@eurodev.net>
References: <Pine.LNX.4.44.0403240106490.15222-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>,
 netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
 Harald Welte <laforge@netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0403240106490.15222-100000@filer.marasystems.com>
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

Henrik Nordstrom wrote:

>What about when the user program closes? How bad it is to have read the 
>pid and then there is no userspace there?
>  
>
As Patrick pointed out before, netlink is not reliable, so it will drop 
the packets sent to an user space which doesn't exist without 
notification. But if the user space program closes properly, peer_pid 
will be reset. Have a look at ipq_rcv_nl_event and netlink_release. 
AFAIK, if the user space program hangs or dies, kernel will release the 
socket later, so for quite some time netlink will drop packets. Am I right?

regards,
Pablo
