From: "Alan Stead" <alan@stead.com>
Subject: RE: getting PID and task name from sk_buff
Date: Thu, 24 Feb 2005 07:55:28 -0800
Message-ID: <DEEDILHNOLKHPLJKLINBOEFIJMAC.alan@stead.com>
References: <20050224133027.GB5056@oknodo.bof.de>
Reply-To: alan@stead.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: codeslinger@gmail.com, netfilter-devel@lists.netfilter.org
To: "Patrick Schaaf" <bof@bof.de>
In-Reply-To: <20050224133027.GB5056@oknodo.bof.de>
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

> When you need per-process accounting of network traffic, the correct layer
> would be in the socket I/O syscalls themselves. I think the LSM framework
> could provide the right hooks to do that.

If the accounting of network traffic is done in the socket I/O syscalls,
would this "count" traffic that might get filtered out by ip_tables?

I am new to all this, but am finding it very exciting to learn so much!
Thanks for the responses!
Alan
