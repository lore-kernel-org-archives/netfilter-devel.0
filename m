From: Wang Jian <lark@linux.net.cn>
Subject: Re[2]: Need help on 2.6.11 and pom-ng HEAD
Date: Fri, 01 Apr 2005 17:04:10 +0800
Message-ID: <20050401165720.01F7.LARK@linux.net.cn>
References: <20050331173635.01D4.LARK@linux.net.cn>
	<20050401070625.GU19835@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050401070625.GU19835@sunbeam.de.gnumonks.org>
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

Hi Harald Welte,

Sigh. Then I have to do it myself? Which tree is the most suitable to
start from? Can you give me some suggestion?

I think it is better to work on a stable API. Then I can try bring
current half ported things to fully ported.

Now I am writing a per flow rate control qdisc. I wish I can finish it
in this week. Then I can put my time on netfilter.

Sigh, it is already Friday. I have only 2 weeks left for beta test, and
alpha stage is not clear yet :(


On Fri, 1 Apr 2005 09:06:25 +0200, Harald Welte <laforge@netfilter.org> wrote:

> On Thu, Mar 31, 2005 at 05:50:24PM +0800, Wang Jian wrote:
> > Beside ordinary conntrack helper, the following things are needed:
> > 
> >  directx8-conntrack-nat
> >  h323-conntrack-nat
> >  ipp2p
> >  mms-conntrack-nat
> >  quake3-conntrack-nat
> >  rtsp-conntrack
> >  nfnetlink-ctnetlink-0.13
> 
> you will have a really long job.  Most of them are neither fully ported
> nor tested.
> -- 
> - Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie



-- 
  lark
