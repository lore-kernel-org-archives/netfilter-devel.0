From: Patrick Schaaf <bof@bof.de>
Subject: Re: getting PID and task name from sk_buff
Date: Thu, 24 Feb 2005 14:30:27 +0100
Message-ID: <20050224133027.GB5056@oknodo.bof.de>
References: <DEEDILHNOLKHPLJKLINBOEFHJMAC.alan@stead.com>
	<876ef97a050224052244efa6f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alan@stead.com, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
Content-Disposition: inline
In-Reply-To: <876ef97a050224052244efa6f3@mail.gmail.com>
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

> Check out how the ipt_owner match module does it. However, I think
> that this is not perfect, either. Maybe someone else has a better
> idea?

When you do things at the wrong layer, there is never a perfect solution.

When you need per-process accounting of network traffic, the correct layer
would be in the socket I/O syscalls themselves. I think the LSM framework
could provide the right hooks to do that.

best regards
  Patrick
