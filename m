From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ip_conntrack table full problem
Date: Mon, 21 Mar 2005 18:03:18 +0100
Message-ID: <200503211803.18918.thomas.jarosch@intra2net.com>
References: <200503141647.42299.thomas.jarosch@intra2net.com>
	<200503211513.59943.thomas.jarosch@intra2net.com>
	<20050321162147.GA14696@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050321162147.GA14696@linuxace.com>
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

Phil,

> > /proc/slabinfo:
> > ip_conntrack       16263  16272    320 1356 1356    1
>
> Yes, you're leaking conntracks somewhere.  Any possibility of testing
> a somewhat newer kernel than 2.4.21?  This may have already been
> fixed.

Thank you for your response.
Unfortunately I cannot update to a newer kernel soon.

Would it be possible to dump the internal conntrack tables
once the error occurs? Then we would at least know what
is filling the table up. Is there some kind of debug macro
I could add before the printk("conntrack table full") code?

Or a more aggressive solution:
Flush the complete conntrack table once the error occurs.
This would kill all running connections, but the machine
would still be reachable afterwards.

Any other ideas?

I'll try to reproduce the problem in a test environment,
but it will be hard to narrow the cause down.

Thomas
