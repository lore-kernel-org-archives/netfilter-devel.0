From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Fix LIST_INSERT breakage
Date: Sun, 28 Mar 2004 15:36:58 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040328233658.GA23295@linuxace.com>
References: <20040324010230.GA4144@linuxace.com> <20040328184053.GY7039@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
  Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <20040328184053.GY7039@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

LIST_INSERT takes a 'cmpfn' argument, and is used pre-change:

-	for (__i = (head)->next;				\
-	     !cmpfn((new), (typeof (new))__i) && __i != (head);	\
-	     __i = __i->next);					\

but not post-change:

+	list_for_each(__i, (head))				\
+		if ((new), (typeof (new))__i)			\  <---
+			break;					\

'if (cmpfn((new), ......' is probably what was intended?

But either way, it is unused and thus moot.

Phil

On Sun, Mar 28, 2004 at 08:40:54PM +0200, Harald Welte wrote:
> On Tue, Mar 23, 2004 at 05:02:30PM -0800, Phil Oester wrote:
> > In 2.4.25, this patch was included:
> > 
> > http://linux.bkbits.net:8080/linux-2.4/cset@3fcc5cc99cChx6Q0shnhIlekWT1-5Q?nav=index.html|ChangeSet@-4M
> > 
> > which has a questionable change in LIST_INSERT due to the disappearing
> > cmpfn.  
> 
> Could you be more specific about your objections against that changeset?
