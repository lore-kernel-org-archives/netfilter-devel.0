From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Reset conntrack...
Date: Sat, 4 Dec 2004 15:44:20 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412041543230.14126@filer.marasystems.com>
References: <41AF92B1.30802@anduras.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <41AF92B1.30802@anduras.de>
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

On Thu, 2 Dec 2004, Sven Anders wrote:

> Is it possible to reset the conntrack list or set any entry to the state 
> NEW to force a recheck against new filter rules?

You can use CONNMARK for a similar kind of test instead of looking for 
NEW.

Regards
Henrik
