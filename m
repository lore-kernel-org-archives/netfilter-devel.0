From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Idea: Check session source and destination
Date: Sat, 24 Apr 2004 10:43:53 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404241042450.2578-100000@filer.marasystems.com>
References: <E9A8BAAF-951F-11D8-8B09-000A957FD99E@src.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Mike Andersen <mike@src.no>
In-Reply-To: <E9A8BAAF-951F-11D8-8B09-000A957FD99E@src.no>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 23 Apr 2004, Mike Andersen wrote:

> Could it be an idea to implement a check against _session_ source and
> _session_ destination?  Like:
> 
> iptables -A chain -m state --sesion-src <external ip> -J ACCEPT

Already done. See the conntrack match.

> My assumptions here is that the source address in the state table
> _always_ is the one that initiates the session.

Correct. Even on related connections (unless the related connections goes 
to another IP on the initiator side but I know of no such protocols)

Regards
Henrik
