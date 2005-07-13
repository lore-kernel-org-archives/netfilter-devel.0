From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Proposed netmap patch
Date: Wed, 13 Jul 2005 12:32:51 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507131231510.14635@yvahk01.tjqt.qr>
References: <57F9959B46E0FA4D8BA88AEDFBE582909ED9@pxtbenexd01.pxt.primeexalia.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Gary W. Smith" <gary@primeexalia.com>
In-Reply-To: <57F9959B46E0FA4D8BA88AEDFBE582909ED9@pxtbenexd01.pxt.primeexalia.com>
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


>I had a need to use NETMAP but found it lacking the OUTPUT chain of the nat 
>filter.  So I added it.  I have been running it for some time and it seems to 
>work great.  Anyways, here is the patch that I used.  I found it useful.

There must have been a reason why it was originally not allowed in the OUTPUT 
chain, but I am not sure.
