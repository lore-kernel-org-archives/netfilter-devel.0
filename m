From: Patrick Schaaf <bof@bof.de>
Subject: Re: a question about ip_conntrack_max
Date: Thu, 12 Dec 2002 08:21:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021212072143.GA19846@oknodo.bof.de>
References: <F78gEj4v5iJarnJ3kEP000004e7@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: jump lee <zomby_cn@hotmail.com>
Content-Disposition: inline
In-Reply-To: <F78gEj4v5iJarnJ3kEP000004e7@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

(removed Harald Welte from Cc: - I'm sure he's reading the list, anyway)

> i am hacking ip_conntrack.

What is your goal?

> ip_conntrack_max=8*ip_conntrack_htable_size;
> 
> what's the reason of multiplying ip_conntrack_htable_size by 8?

It gives you 8 times as much conntrack entries as you have
conntrack hash buckets.  Isn't 8 a nice number?  What number
would you prefer, and why?  The kernel has to derive ip_conntrack_max
SOMEHOW, and that's the way it does it now. There is another equally
arbitrary choice of ip_conntrack_htable_size, which is calculated
from the amount of memory in your machine. Again, the kernel has to do
SOMETHING in the absence of configuration information.

best regards
  Patrick
