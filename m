From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6 0/12]: netfilter update
Date: Tue, 21 Sep 2004 17:18:57 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040921171857.2c720c8e.davem@redhat.com>
References: <414F9DFC.701@trash.net> <20040921143611.6a6e2f60.davem@redhat.com>
	<4150BB62.2060904@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4150BB62.2060904@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 22 Sep 2004 01:38:10 +0200
Patrick McHardy <kaber@trash.net> wrote:

> Done. The updated tree is at the same location.

Thanks, two problems:

1) Please layout the new skbuff.h structure changes more
   intelligently.  Currently the netfilter stuff is:

	pointer
	u32
	pointer
	u32

   and this wastes a lot of space on 64-bitters.

2) There is no way I'm amicable to exporting __tcp_v4_lookup()
   and friends to modules.

   Are you absolutely sure that the existing scheme cannot
   work properly?  I'm talking about relying upon skb->sk
   being sane.

So what I think I'll do is merge in all the changes other
than the ipt_owner.c change by hand into a tree I'll push
to Linus, I'll also fix the layout ordering problem which
I mentioned above in #1

But something has to be done about the ipt_owner.c change, it
isn't going in as-is.
