From: Phil Oester <kernel@linuxace.com>
Subject: Re: Adding a rule with invalid interface name
Date: Thu, 16 Sep 2004 08:42:15 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040916154215.GA17503@linuxace.com>
References: <41498850.9000000@rediffmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Swapnil Nagle <swapsn@rediffmail.com>
Content-Disposition: inline
In-Reply-To: <41498850.9000000@rediffmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 16, 2004 at 06:04:24PM +0530, Swapnil Nagle wrote:
> 
> iptables lets me add a rule with invalid interface name :
> 
> # iptables -A FORWARD -i abc -o xyz -j ACCEPT

How is iptables supposed to know that you won't at some point down
the line bring up an interface called 'abc' or 'xyz'?  

Nothing invalid about iptables allowing you to add this rule...

Phil
