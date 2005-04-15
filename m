From: Pablo Neira <pablo@eurodev.net>
Subject: Re: nfnetlink-ctnetlink working: INSTRUCTIONS
Date: Fri, 15 Apr 2005 22:25:21 +0200
Message-ID: <42602331.6060706@eurodev.net>
References: <20050414175616.0331.LARK@linux.net.cn>
	<425E4403.5010101@eurodev.net>
	<20050415142613.033A.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
In-Reply-To: <20050415142613.033A.LARK@linux.net.cn>
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

Wang Jian wrote:
> Hi Pablo Neira,
> 
> The current patches (dated 14-Apr), seems to not emit event messages,
> such as when new connection is established.

Hm it works just fine here.

o The ct-event notification API is ok, try this test:
http://people.netfilter.org/~pablo/patches/test/ct-event-test.tar.gz

o Netlink notification works fine as well via:
http://people.netfilter.org/~pablo/conntrack-tool/

Try:
# conntrack -E conntrack

So I don't see any problem.

> The only event emitter I find is in ip_conntrack_in()
> 
>         if (set_reply && !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status))
>                 ip_conntrack_event_cache(IPCT_STATUS, *pskb);
> 
> set_reply is set to 1 only when the first reply packet seen from server
> end of a "connection", and !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status)
> is supposed to be true at the moment. So it will emit event once. But
> in my test, cntltest doesn't receive this event.
> 
> Did I miss something?

I'll update ctnltest.c soon since it's currently broken. I haven't mind 
about it so far.

--
Pablo
