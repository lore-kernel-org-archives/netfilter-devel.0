From: "Richard" <richard@o-matrix.org>
Subject: RE: check timer active
Date: Sun, 5 Dec 2004 09:26:01 -1000
Message-ID: <EINSTEINObLLAeSQzWA000068c7@einstein.systemmetrics.com>
References: <1102253409.3889.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Krisztian Kovacs'" <hidden@sch.bme.hu>,
	"'Henrik Nordstrom'" <hno@marasystems.com>
In-Reply-To: <1102253409.3889.2.camel@localhost.localdomain>
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

>   Hi,
> 
> On Sat, 2004-12-04 at 15:55 +0100, Henrik Nordstrom wrote:
> > > ct->timeout->list.next != NULL
> > >
> > > test_bit(IPS_CONFIRMED_BIT, &ct->status)
> >
> > The two is at most if not all times equal as all active conntrack
> entries
> > have a timeout of some sort, but maybe it is possible for the timeout to
> > be established before the conntrack becomes confirmed or something..
> 
>   It is definitely possible if you use ct_sync. Replicated entries on
> the slave nodes do not have their timers started, but are in the hash
> tables.
> 

I am writing a new target to manipulate the expire value of a conntrack,
i.e. (ct->timeout.expires). If the expire timeout is not fired, it uses the
timeout value. If it is, it uses jiffies+timeout. In order to check what
state it is at, I'd use "ct->timeout->list.next!=NULL)", right?

Thanks,
Richard
