From: Phil Oester <kernel@linuxace.com>
Subject: Re: iptables modification
Date: Wed, 4 Aug 2004 07:42:01 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040804144201.GA29167@linuxace.com>
References: <1091580576.3949.12.camel@ben1.scorpiocc.corp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ben Alabaster <ben@scorpiocc.com>
Content-Disposition: inline
In-Reply-To: <1091580576.3949.12.camel@ben1.scorpiocc.corp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Aug 03, 2004 at 06:49:36PM -0600, Ben Alabaster wrote:
> Hi,
> 
> I need to modify my iptables module so that it will store FQDN's in the
> routing tables but I have no clue where to start.  I will give you an
> example of what I'm trying to do to better help explain.

I think you're better off just running a cron every 5 minutes which 
flushes then repopulates the rules.  Trying to hack netfilter so
it does DNS lookups for every rule hit doesn't sound efficient.

Phil
