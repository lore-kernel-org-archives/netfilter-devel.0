From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH pom-ng] H.225 parser for h323-conntrack-nat
Date: Mon, 4 Apr 2005 16:06:39 +0200
Message-ID: <20050404140639.GA31341@roonstrasse.net>
References: <Pine.LNX.4.58.0504040852460.12853@blackhole.kfki.hu>
	<20050404091035.GB28490@roonstrasse.net>
	<20050404215535.022F.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
Content-Disposition: inline
In-Reply-To: <20050404215535.022F.LARK@linux.net.cn>
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

On 2005/04/04 16:01, Wang Jian <lark@linux.net.cn> wrote:
[...]
> I want to make it works under 2.6.11 or 2.6.12. I really need your help
> to finish it in time.
> 
> I will spend a day (ideally) to look into the new conntrack
> infrastructure, and then I will spend time on every conntrack involved.
> If the old code works, I think it is not very hard to port them to new
> infrastructure. provided that new infrastruture is stable and good.

I already ported h323-conntrack-nat to 2.6.11, but my port is hidden
in an obsolete branch in the pom-ng svn repository. Please grab my
patch from my home page:

 http://max.kellermann.name/projects/netfilter/h323.html

This allows you to use h323-conntrack-nat on 2.6.11. The patches will
be in the subversion repository soon (as discussed in this thread).

Max
