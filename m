From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] CLASSIFY target
Date: Wed, 09 Apr 2003 01:26:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E935A9C.9030700@trash.net>
References: <3E92F2F8.1020707@trash.net> <1049832299.1318.19.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1049832299.1318.19.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Martin,
thanks for your response,

Martin Josefsson wrote:

>Regarding this patch... iirc, Bert Hubert wrote a similar target a while
>ago and I think he wanted a small change in the core QoS stuff and that
>was voted down, might be something to look into?
>
>I think the discussion took place on the netdev list.
>

Google found a discussion about moving "skb->priority = sk->priority" 
line to
ip_queue_xmit2 to allow netfilter targets to override SO_PRIORITY value of
local sockets. A quick check told me this change was never made, so the
CLASSIFY target is only working correctly in the POST_ROUTING chain, which
is what i have tested. This doesn't seem to affect usage of the target, 
worse
would be if POST_ROUTING didn't work correctly. My suggestion is to
restrict usage to POST_ROUTING chain, this seems like a natural place for
QoS classification. What do you think ?

Thanks,
Patrick
