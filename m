From: Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH pom-ng] H.225 parser for h323-conntrack-nat
Date: Mon, 04 Apr 2005 23:04:44 +0800
Message-ID: <20050404230336.0235.LARK@linux.net.cn>
References: <20050404215535.022F.LARK@linux.net.cn>
	<20050404140639.GA31341@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050404140639.GA31341@roonstrasse.net>
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

I tried it once with 2.6.11 and 2.6.11.6, both failed. But I will try it
again tomorrow.

Thanks.

On Mon, 4 Apr 2005 16:06:39 +0200, Max Kellermann <max@duempel.org> wrote:

> On 2005/04/04 16:01, Wang Jian <lark@linux.net.cn> wrote:
> [...]
> > I want to make it works under 2.6.11 or 2.6.12. I really need your help
> > to finish it in time.
> > 
> > I will spend a day (ideally) to look into the new conntrack
> > infrastructure, and then I will spend time on every conntrack involved.
> > If the old code works, I think it is not very hard to port them to new
> > infrastructure. provided that new infrastruture is stable and good.
> 
> I already ported h323-conntrack-nat to 2.6.11, but my port is hidden
> in an obsolete branch in the pom-ng svn repository. Please grab my
> patch from my home page:
> 
>  http://max.kellermann.name/projects/netfilter/h323.html
> 
> This allows you to use h323-conntrack-nat on 2.6.11. The patches will
> be in the subversion repository soon (as discussed in this thread).
> 
> Max



-- 
  lark
