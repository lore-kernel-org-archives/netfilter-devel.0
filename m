From: Alan Ezust <ezust@presinet.com>
Subject: Re: remove connections notification by conntrack?
Date: Mon, 25 Sep 2006 10:12:14 -0700
Message-ID: <200609251012.15023.ezust@presinet.com>
References: <200609221359.22676.thezema@gmail.com>
	<4513FA76.1010304@netfilter.org>
	<200609231123.09148.thezema@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Thomas Mader <thezema@gmail.com>, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200609231123.09148.thezema@gmail.com>
Content-Disposition: inline
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

Hi - i'm rather new to this list and trying to learn as much as I can about 
this API. I see that for this particular function, there are no API docs. You 
make reference to "unofficial API docs" on a website, but shouldn't there be 
actual proper doc comments before the function? i.e.

/** @param  this - a reference to a notifier block, which will be used for ???
     @param events - a bitmask - please see ifnetlink.h for the possible 
values
     @param ptr - a pointer to a struct ip_conntrack for the purposes of ???
     @return it seems to return NOTIFY_DONE under every possible exec path.
*/
static int ctnetlink_conntrack_event(struct notifier_block *this,
                                     unsigned long events, void *ptr)




On Saturday 23 September 2006 02:23, Thomas Mader wrote:
> > Use the event API, do not forget to enable it (it's still marked as
> > experimental): have a look at ctnetlink_conntrack_event inside
> > ip_conntrack_netlink.c, that will help I think.
> >
> > Use the unsigned long parameter of your notify function above and wait
> > for the event IPCT_DESTROY.
>
> Now it looks like this:
>
> int ipaddr_conntrack_event(struct notifier_block *this, unsigned long
> events, void *ptr) {
> 	struct ip_conntrack *ct = (struct ip_conntrack *)ptr;
>
> 	if (events == IPCT_DESTROY) {
> 		printk("We have been notified that connection %d was deleted!\n",
> ct->id); }
>
> 	return 0;
> }
