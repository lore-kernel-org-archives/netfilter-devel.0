From: Krisztian Kovacs <hidden@sch.bme.hu>
Subject: Re: check timer active
Date: Sun, 05 Dec 2004 14:30:09 +0100
Message-ID: <1102253409.3889.2.camel@localhost.localdomain>
References: <EINSTEINLVbNDN4CxpA000066fb@einstein.systemmetrics.com>
	<Pine.LNX.4.61.0412041554150.14126@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0412041554150.14126@filer.marasystems.com>
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


  Hi,

On Sat, 2004-12-04 at 15:55 +0100, Henrik Nordstrom wrote: 
> > ct->timeout->list.next != NULL
> >
> > test_bit(IPS_CONFIRMED_BIT, &ct->status)
> 
> The two is at most if not all times equal as all active conntrack entries 
> have a timeout of some sort, but maybe it is possible for the timeout to 
> be established before the conntrack becomes confirmed or something..

  It is definitely possible if you use ct_sync. Replicated entries on
the slave nodes do not have their timers started, but are in the hash
tables.

-- 
 Krisztian KOVACS
