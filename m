From: Alexey Toptygin <alexeyt@freeshell.org>
Subject: Re: Reverse the behavior change of -L option?
Date: Mon, 21 Feb 2005 15:02:47 +0000 (UTC)
Message-ID: <Pine.NEB.4.61.0502211502170.23033@ukato.freeshell.org>
References: <421840E5.2F11BB81@iswest.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: gypsy <gypsy@iswest.com>
In-Reply-To: <421840E5.2F11BB81@iswest.com>
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

On Sat, 19 Feb 2005, gypsy wrote:

> Since 1.3.0 none of the scripts I parse the output of 'iptables -nvL'
> works anymore because the order has changed from INPUT FORWARD OUTPUT
> USER to alphabetical.  How do I revert back to the prior behavior?

Change your scripts so that they don't assume any particular table order, 
and this problem will never happen again.

 			Alexey
