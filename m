From: Patrick Schaaf <bof@bof.de>
Subject: Re: getting PID and task name from sk_buff
Date: Thu, 24 Feb 2005 17:27:09 +0100
Message-ID: <20050224162709.GC5056@oknodo.bof.de>
References: <20050224133027.GB5056@oknodo.bof.de>
	<DEEDILHNOLKHPLJKLINBOEFIJMAC.alan@stead.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: codeslinger@gmail.com, netfilter-devel@lists.netfilter.org,
	Patrick Schaaf <bof@bof.de>
To: Alan Stead <alan@stead.com>
Content-Disposition: inline
In-Reply-To: <DEEDILHNOLKHPLJKLINBOEFIJMAC.alan@stead.com>
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

On Thu, Feb 24, 2005 at 07:55:28AM -0800, Alan Stead wrote:
> > When you need per-process accounting of network traffic, the correct layer
> > would be in the socket I/O syscalls themselves. I think the LSM framework
> > could provide the right hooks to do that.
> 
> If the accounting of network traffic is done in the socket I/O syscalls,
> would this "count" traffic that might get filtered out by ip_tables?

For incoming traffic, it would not count. For outgoing traffic, it would.

Another interesting topic is whether retransmits would count, or not.
And whether header overhead would count, or not.

With a socket layer based approach, neither retransmits, nor header
overhead, would count. For a netfilter based approach, it would be
very hard to not account retransmits.

Decisions, decisions...

best regards
  Patrick
