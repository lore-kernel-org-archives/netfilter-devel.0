From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: [PTCH 2.5.68] netfilter using Read Copy Update
Date: Tue, 29 Apr 2003 11:58:45 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030429115845.45e48dfa.shemminger@osdl.org>
References: <20030427132413.GP990@sunbeam.de.gnumonks.org>
	<20030428062622.5F0FE2C4D3@lists.samba.org>
	<20030428123009.4cde1e57.shemminger@osdl.org>
	<20030429.012909.26514398.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, laforge@netfilter.org,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20030429.012909.26514398.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 29 Apr 2003 01:29:09 -0700 (PDT)
"David S. Miller" <davem@redhat.com> wrote:

>    From: Stephen Hemminger <shemminger@osdl.org>
>    Date: Mon, 28 Apr 2003 12:30:09 -0700
> 
>    On Mon, 28 Apr 2003 14:24:30 +1000
>    Rusty Russell <rusty@rustcorp.com.au> wrote:
>    
>    > Stephen, it should be simple for you to rework your patch on top of
>    > this one.
>    
>    Revised RCU patch.  Rusty, you forgot to kfree() the info structure
>    if the try_module_get failed.
> 
> Applied, thanks.

Looks like one line got dropped in the patch.

diff -Nru a/net/core/netfilter.c b/net/core/netfilter.c
--- a/net/core/netfilter.c	Tue Apr 29 11:58:04 2003
+++ b/net/core/netfilter.c	Tue Apr 29 11:58:04 2003
@@ -550,6 +550,7 @@
 		 unsigned int verdict)
 {
 	struct list_head *elem = &info->elem->list;
+	struct list_head *i;
 
 	rcu_read_lock();
 
