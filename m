From: Phil Oester <kernel@linuxace.com>
Subject: Re: Deadlocks
Date: Thu, 17 Jun 2004 08:59:46 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040617155946.GA28564@linuxace.com>
References: <20040609180909.GA11445@linuxace.com> <1087156709.11287.8.camel@ws> <20040615044723.GA16891@linuxace.com> <40CE95DE.9090703@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <40CE95DE.9090703@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Yes, my statement was not clear at all.  What I meant was something like:

cpu 1:
  conntrack helper calls ip_conntrack_expect_related

cpu 2:
  nat helper calls ip_conntrack_change_expect

CPU 2 ends up causing a duplicate expectation, because the nat helper
changed the expectation to match the one created by cpu 1.

I do see duplicate expectations occasionally:

# grep EXP /proc/net/ip_conntrack 
EXPECTING: - use=1 proto=6 src=10.20.116.197 dst=10.20.153.248 sport=0 dport=4309 
EXPECTING: - use=1 proto=6 src=10.20.116.197 dst=10.20.153.248 sport=0 dport=4309 

which may or may not be related to the above.

In any event, I have applied your patch to 2.6.7, and am running it.  Typically
the box would not last more than a couple days, so I'll let you know what 
happens.

Phil

On Tue, Jun 15, 2004 at 08:23:26AM +0200, Patrick McHardy wrote:
> Phil Oester wrote:
> >so the nat helper is changing the expectation -- potentially at the same 
> >time
> >the conntrack helper is calling ip_conntrack_expect.  If the private lock
> >were removed, could this not cause a race condition if the expectation got
> >created just after the nat-helper changed the expectation?  
> 
> I don't understand what you mean. The nat-helper can not change the
> expectation before it's created, and once it's created it can not
> be touched by the conntrack helper anymore. ip_ftp_lock is protecting
> ftp_buffer and ct_ftp_info, so it can be dropped directly after the
> call to find_pattern. The help function in the nat_helper only touches
> the expectation, which is protected by ip_conntrack_lock, so it doesn't
> need ip_ftp_lock lock at all.
