From: Henrik Nordstrom <henrik@marasystems.com>
Subject: Re: DNAT/SNAT and logging
Date: Wed, 21 Jan 2004 10:21:34 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401211018500.4023-100000@filer.marasystems.com>
References: <1074626146.8739.6.camel@ankarloo.got.volvo.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Johan Ankarloo <johan.ankarloo@volvo.com>
In-Reply-To: <1074626146.8739.6.camel@ankarloo.got.volvo.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 20 Jan 2004, Johan Ankarloo wrote:

> is above the actually mangle line, the log target won't know how the
> packet will be mangle. What i need in the log files are something like:
> 
> Original Source 
> Original SourcePort 
> Original Destination 
> Original DestinationPort
> Translated Source 
> Translated SourcePort 
> Translated Destination 
> Translated DestinationPort

Then you need another LOG type target which logs the conntrack information 
rather than the packet information, and on NEW packets you need to have 
this logged after the SNAT rule have been applied.

Maybe ctnetlink can help.

Regards
Henrik
