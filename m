From: Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH pom-ng] H.225 parser for h323-conntrack-nat
Date: Mon, 04 Apr 2005 22:01:31 +0800
Message-ID: <20050404215535.022F.LARK@linux.net.cn>
References: <Pine.LNX.4.58.0504040852460.12853@blackhole.kfki.hu>
	<20050404091035.GB28490@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050404091035.GB28490@roonstrasse.net>
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

Hi Max Kellermann,

It is very good news for me.

Please read back to my mail titled as "Need help on 2.6.11 and pom-ng
HEAD"

I want to make it works under 2.6.11 or 2.6.12. I really need your help
to finish it in time.

I will spend a day (ideally) to look into the new conntrack
infrastructure, and then I will spend time on every conntrack involved.
If the old code works, I think it is not very hard to port them to new
infrastructure. provided that new infrastruture is stable and good.

On Mon, 4 Apr 2005 11:10:35 +0200, Max Kellermann <max@duempel.org> wrote:

> Hi all,
> 
> back from vacation now.
> 
> On 2005/04/04 10:07, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > > Jozsef: what do you think of that patch? h.323 helper is your code,
> > > after all.
> > 
> > Max does the right thing. And as he completes the helper with the H.245
> > parser, we could finally consider to push the helper into the
> > kernel. :-)
> 
> Jozsef, thanks for confirming my patches. The H.225 parser works for
> the clients I tested, but needs more work, because it *may* break
> other clients (no ASN.1-PER parser, just q'n'd).
> 
> I have already written a lean H.245 parser which is working for me. It
> aims to parse the ASN.1-PER correctly, but it has grown more complex
> than I had expected. I will release it after I have spent more time on
> cleanup, review and testing.
> 
> Security is my goal #1; what we need least is a remote kernel hole
> (other ASN.1 parsers had holes in the past). This is the most complex
> conntrack helper until now. It has to undergo much more review before
> we can recommend it for the mainstream kernel.
> 
> Once the H.245 parser is finished, the H.225 parser will be rewritten
> using my low-level ASN.1-PER parser library.
> 
> Max
> 



-- 
  lark
