From: Wang Jian <lark@linux.net.cn>
Subject: Re: nfnetlink-ctnetlink working: INSTRUCTIONS
Date: Fri, 15 Apr 2005 14:54:47 +0800
Message-ID: <20050415142613.033A.LARK@linux.net.cn>
References: <20050414175616.0331.LARK@linux.net.cn>
	<425E4403.5010101@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <425E4403.5010101@eurodev.net>
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

Hi Pablo Neira,

The current patches (dated 14-Apr), seems to not emit event messages,
such as when new connection is established.

The only event emitter I find is in ip_conntrack_in()

        if (set_reply && !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status))
                ip_conntrack_event_cache(IPCT_STATUS, *pskb);

set_reply is set to 1 only when the first reply packet seen from server
end of a "connection", and !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status)
is supposed to be true at the moment. So it will emit event once. But
in my test, cntltest doesn't receive this event.

Did I miss something?


On Thu, 14 Apr 2005 12:20:51 +0200, Pablo Neira <pablo@eurodev.net> wrote:

> Wang Jian wrote:
> >>Just eemove `inline' from ip_conntrack_free and ip_conntrack_insert. 
> >>I've just fixed those in the patches, so alternatively you could 
> >>download the patch again. This seems to be something gcc-3.4 related 
> >>since I didn't get such error with gcc-2.95.
> >>
> > 
> > 
> > I remove the inline prefix from include/linux/netfilter_ipv4/ip_conntrack.h,
> > and now it compiles.
> > 
> > But I think 
> > 
> > EXPORT_SYMBOL(ip_conntrack_insert);
> > 
> > is missing in net/ipv4/netfilter/ip_conntrack_standalone.c, isn't it?
> 
> Right, I've just fixed it, thanks.
> 
> --
> Pablo



-- 
  lark
