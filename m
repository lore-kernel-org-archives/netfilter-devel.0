From: Wang Jian <lark@linux.net.cn>
Subject: Re: nfnetlink-ctnetlink working: INSTRUCTIONS
Date: Sat, 16 Apr 2005 07:50:32 +0800
Message-ID: <20050416073637.0352.LARK@linux.net.cn>
References: <20050415142613.033A.LARK@linux.net.cn>
	<42602331.6060706@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42602331.6060706@eurodev.net>
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

Thanks for you information :)

I will look into conntrack-tool.

BTW:

Is there any documentation about ct-event notification API /
libnfnetlink / libctnetlink?

If there is none, I think I can help drafting it. But I need some hints
on the big picture.

On Fri, 15 Apr 2005 22:25:21 +0200, Pablo Neira <pablo@eurodev.net> wrote:

> Wang Jian wrote:
> > Hi Pablo Neira,
> > 
> > The current patches (dated 14-Apr), seems to not emit event messages,
> > such as when new connection is established.
> 
> Hm it works just fine here.
> 
> o The ct-event notification API is ok, try this test:
> http://people.netfilter.org/~pablo/patches/test/ct-event-test.tar.gz
> 
> o Netlink notification works fine as well via:
> http://people.netfilter.org/~pablo/conntrack-tool/
> 
> Try:
> # conntrack -E conntrack
> 
> So I don't see any problem.
> 
> > The only event emitter I find is in ip_conntrack_in()
> > 
> >         if (set_reply && !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status))
> >                 ip_conntrack_event_cache(IPCT_STATUS, *pskb);
> > 
> > set_reply is set to 1 only when the first reply packet seen from server
> > end of a "connection", and !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status)
> > is supposed to be true at the moment. So it will emit event once. But
> > in my test, cntltest doesn't receive this event.
> > 
> > Did I miss something?
> 
> I'll update ctnltest.c soon since it's currently broken. I haven't mind 
> about it so far.
> 
> --
> Pablo



-- 
  lark
