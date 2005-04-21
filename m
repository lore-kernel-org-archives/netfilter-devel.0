From: Wang Jian <lark@linux.net.cn>
Subject: Re: A top 10 statistics module?
Date: Thu, 21 Apr 2005 15:12:00 +0800
Message-ID: <20050421145302.03C4.LARK@linux.net.cn>
References: <20050421115819.03C0.LARK@linux.net.cn>
	<16999.19485.501493.784034@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <16999.19485.501493.784034@isis.cs3-inc.com>
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

Hi Don Cohen,


On Wed, 20 Apr 2005 23:45:49 -0700, don-nfil1@isis.cs3-inc.com (Don Cohen) wrote:

> Do you mind if I ask exactly what statistics you really want to
> collect?  I actually have a module that does something very similar.
> If, for instance, you wanted to know which of the IP addresses in 
> your network was used as source or destination address for how many
> packets/bytes over some interval it would tell you.  But it only
> classifies packets into a fixed number of sets, so you could find
> out for IP packets or UDP but not for those to port 80.
> 
>  > And, the kernel has done this once. Do it again in userspace seems to be
>  > a waste?
> First, the kernel need not have done it, second, even if it has,
> this is not so bad if the machine is wasting lots of cycles anyhow.
> 

For my original purpose, the kernel have done it (set nfmark). The
rules that match and set nfmark can be from one to many.

>  > It can be done in user space. But not convenient.
> Lots of things are much more convenient in user space.
> 

I know programming in user space is much simpler. But for this case, it
is not. Kernel space has information that user space should use a lot of
code to get. Then there is a duplication effort here.


>  > This is definitely the original requirement. It can be done in user
>  > space, but not convenient for automation.
> Is this somehow related to the fact that you're specifically trying
> to check things that you already classify in netfilter?
> Otherwise I don't see that automation is easier in the kernel.
> In fact you need something in user space to collect the data from
> the proc file anyhow.

Yes. netfilter rules classify tc class. then, we need to see who is the
top host in this class.

Attach another rule to collect top hosts, and then cat
/proc/net/stat/tophost/classN, we get it.

> 
>  > It should be in realtime.
> The module I have actually does export to /proc where a user space
> program then collects the data.
> 
>  > This, may be good in overhead, but the counter is meaningless then.
>  > Alghouth the top10 is not accurate, the counter should make sense.
> I think the counter does make sense.

the collision may render the counter meaningless when ordering, and it
may be misleading and leads to wrong conclusion.

> Of course, there's no problem at all if you're counting things that
> have relatively small numbers of classes, such as the machines in
> your network.  And my impression is that this is what you want.

Yes, it's what my customer wants to get.

-- 
  lark
