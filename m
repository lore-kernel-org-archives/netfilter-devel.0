From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [RFC] ct_sync 0.15 (corrected)
Date: Thu, 19 Aug 2004 18:13:01 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408191811410.5913@filer.marasystems.com>
References: <1092407190.2402.120.camel@nienna.balabit>
 <20040819110646.GJ3921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: KOVACS Krisztian <hidden@balabit.hu>,
   Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>,
   jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040819110646.GJ3921@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 19 Aug 2004, Harald Welte wrote:

> I would just use connmark for now.  Let's make it a CONFIG option
> though, so people can just use connmark without any interference and
> replicate all connections.

With the (conn)mark operations patch discussed recently on netfilter-devel 
it makes sense to use a bitmask for this, masking which bit(s) indicate a 
session should be replicated.

Regards
Henrik
