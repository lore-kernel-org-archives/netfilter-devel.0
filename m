From: "Richard" <richard@o-matrix.org>
Subject: RE: Reset conntrack...
Date: Thu, 2 Dec 2004 13:24:49 -1000
Message-ID: <EINSTEINfIQTrM4PGou00006660@einstein.systemmetrics.com>
References: <41AF92B1.30802@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Sven Anders'" <anders@anduras.de>, <netfilter-devel@lists.netfilter.org>
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

> 
> Hello!
> 
> Is it possible to reset the conntrack list or set any entry to the state
> NEW to force
> a recheck against new filter rules?
> 
> The problem is:
> 
> ~  If I set the (new) filtering rules with the target DROP, I want old
> ~  (existing) connections to be dropped immediatly.
> ~  The global rule '--state RELATED,ESTABLISHED' I set would still allow
> them...
> 
I am in the process to write a TARGET which sets the conntrack expire value.
I am not sure if you set it to zero will immediately drop the connection.
But at least you can set it to 1 and let it drop in 1 second.

https://lists.netfilter.org/pipermail/netfilter-devel/2004-December/017582.h
tml

Richard
