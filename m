From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: Modify skb from match module?
Date: Thu, 17 Feb 2005 08:14:21 -0500
Message-ID: <876ef97a05021705149c5180d@mail.gmail.com>
References: <4213B519.3080201@evtek.fi>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Juha Heljoranta <juha.heljoranta@evtek.fi>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <4213B519.3080201@evtek.fi>
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

On Wed, 16 Feb 2005 23:03:21 +0200, Juha Heljoranta
<juha.heljoranta@evtek.fi> wrote:
> I would like to associate some information to struct sk_buff *skb so
> that it would be available later while processing packet. But it turns
> out that the skb is const
> 
>     static int match(const struct sk_buff *skb, ...
> 
> Is there any way to modify skb from match module? 

No. As you correctly point out, the sk_buff is constant and thus
unmodifiable. Packets can only be modified by rules in the mangle
table using a target, not a match.

> Or is there another way to store/cache information so that it can be later
> associated to skb.

Potentially, depending on the protocol you need to manipulate, you
could create a conntrack helper that has its own data structure for
storing the information you require. This would allow you to store
data on a per-connection basis. This data would not persist past the
life of the connection, however.

Alternatively, you could create a module that serves only to store the
data that you need and call out to it in your match module in order to
save data about packets you match on. This would allow you to store
data beyond the life of a connection or single packet and also to
aggregate data in more complicated manners. You would then have to
come up with some way to clean this data, however.

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
