From: Phil Oester <kernel@linuxace.com>
Subject: Re: ip_conntrack table full problem
Date: Mon, 21 Mar 2005 13:15:37 -0800
Message-ID: <20050321211537.GB15155@linuxace.com>
References: <200503141647.42299.thomas.jarosch@intra2net.com>
	<200503211513.59943.thomas.jarosch@intra2net.com>
	<20050321162147.GA14696@linuxace.com>
	<200503211803.18918.thomas.jarosch@intra2net.com>
	<20050321184105.GA378@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20050321184105.GA378@oknodo.bof.de>
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

On Mon, Mar 21, 2005 at 07:41:06PM +0100, Patrick Schaaf wrote:
> > Would it be possible to dump the internal conntrack tables
> > once the error occurs?
> 
> The interface for such dumping is /proc/net/ip_conntrack, where you
> only find 35 conntracks in your table-full situation. So I would
> strongly doubt that extra "show them all" code would show much
> more than that...

It would show the conntracks which have been removed from ip_conntrack
but not yet destroyed.

Phil
