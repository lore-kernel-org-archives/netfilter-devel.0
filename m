From: Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Thu, 07 Apr 2005 12:17:49 +0800
Message-ID: <20050407120310.02B4.LARK@linux.net.cn>
References: <42540839.8020405@ufomechanic.net> <4254265F.6080607@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4254265F.6080607@eurodev.net>
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

I suggest that we split ctnetlink-nfnetlink into two parts: notification
and manipulation.

The notification part is very useful and supposed to be stable (I mean,
not changing so often) and I think we can make it work once and ever.

The manipulation part, however, is not needed by most of people, and apt
to changing from time to time when the conntrack core changes.

I have a suggestion on the notification part, that we can provide a
/proc/net/netfilter/notification. It is a bit mask that controls what
kinds of notification should be sent.


On Wed, 06 Apr 2005 20:11:43 +0200, Pablo Neira <pablo@eurodev.net> wrote:

> Amin Azez wrote:
> > It appears that pom-ng nfnetlink-ctnetlink-0.13 (ported by Pablo?) 
> > requires ct-event (although this is not listed in the pom-ng dependancies).
> > 
> > Pablo, can you confirm this?
> 
> I've just merged Harald's and my port. You can get it from:
> 
> http://people.netfilter.org/~pablo/patches/nfnetlink-conntrack-0.50-2.6.11/
> 
> --
> Pablo



-- 
  lark
