From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] peer_pid checking in ip_queue
Date: Wed, 24 Mar 2004 01:47:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4060DAB3.7010400@trash.net>
References: <Pine.LNX.4.44.0403240106490.15222-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>,  netfilter-devel@lists.netfilter.org,
 Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
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

Henrik Nordstrom wrote:
> On Tue, 23 Mar 2004, Patrick McHardy wrote:
> 
> 
>>It can happen if peer_pid is checked outside the locked section on one
>>CPU and changed on another at the same time. I don't consider it
>>important, as the exact point in time at which the first packet will be
>>received is non-deterministic for userspace anyway.
> 
> 
> What about when the user program closes? How bad it is to have read the 
> pid and then there is no userspace there?

It's no problem, netlink_unicast checks for existance of the socket,
which will be gone with the reader. If no socket is found it returns
-ECONNREFUSED.

Regards
Patrick


> 
> Regards
> Henrik
> 
