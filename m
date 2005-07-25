From: James Morris <jmorris@redhat.com>
Subject: Netlink connector
Date: Mon, 25 Jul 2005 02:02:10 -0400 (EDT)
Message-ID: <Lynx.SEL.4.62.0507250154000.21934@thoron.boston.redhat.com>
References: <20050723125427.GA11177@rama> <20050723091455.GA12015@2ka.mipt.ru>
	<20050724.191756.105797967.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: johnpol@2ka.mipt.ru, Andrew Morton <akpm@osdl.org>,
	Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, netdev@redhat.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050724.191756.105797967.davem@davemloft.net>
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

On Sun, 24 Jul 2005, David S. Miller wrote:
> From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> Date: Sat, 23 Jul 2005 13:14:55 +0400
>
>> Andrew has no objection against connector and it lives in -mm
>
> A patch sitting in -mm has zero significance.

The significance I think is that Andrew is trying to gently encourage some 
further progress in the area.

I recall some netconf discussion about TIPC over Netlink, or more likely a 
variation thereof, which may be a better way forward.

It's cool stuff http://tipc.sourceforge.net/


- James
-- 
James Morris
<jmorris@redhat.com>
