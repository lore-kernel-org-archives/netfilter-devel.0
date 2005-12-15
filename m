From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] ctnetlink port to nf_conntrack take #3
Date: Thu, 15 Dec 2005 03:32:34 +0100
Message-ID: <43A0D5C2.40000@trash.net>
References: <439419A7.7040100@eurodev.net>	<200512090241.jB92fXDR003303@toshiba.co.jp>	<43A0C749.2050901@trash.net>
	<200512150224.jBF2O4Qf011205@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200512150224.jBF2O4Qf011205@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Well, I've found a issue. Current dumping code returns the informations about
> IPv6 connections regardless of the address family in nfctnetlink header
> (nfgenmsg). As a result, conntrack program prints "0.0.0.0 ....."
> 
> A something like filtering with address family might be necessary while
> dumping. Yes, that would be inefficient. One long term solution would be
> conntrack hash per layer 3 protocol.

The filtering sounds fine for now. Dumping already has a large overhead
because the repeated iterations over the entire hash to find out where
to continue after an skb was full, this is not going to make it much
worse. I'm going to fix it up when adding the patch.
