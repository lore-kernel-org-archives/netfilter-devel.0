From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Userspace (QUEUE) Filter Verdict Targets, REJECT and TARPIT
Date: Fri, 17 Dec 2004 16:41:24 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412171639190.15793@filer.marasystems.com>
References: <200412171017.21908.gordan@bobich.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gordan Bobic <gordan@bobich.net>
In-Reply-To: <200412171017.21908.gordan@bobich.net>
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

On Fri, 17 Dec 2004, Gordan Bobic wrote:

> Is there a way to set REJECT or TARPIT as targets?

No, only the netfilter primitive targets are available from userspace.

But there is patches allowing you to return a nfmark from your queue 
application, which can then be used in further processing using iptables.

Regards
Henrik
