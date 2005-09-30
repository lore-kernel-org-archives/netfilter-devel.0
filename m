From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: How to change source port in MASQUERADE mode?
Date: Fri, 30 Sep 2005 13:58:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0509301356110.19019@filer.marasystems.com>
References: <433CC0E0.5060308@ms1.techarea.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Richard Liu <richardliu@ms1.techarea.org>
In-Reply-To: <433CC0E0.5060308@ms1.techarea.org>
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

On Fri, 30 Sep 2005, Richard Liu wrote:

> I want change tuple source port in MASQUERADE module.

--to-ports option to MASQUERADE (or SNAT if not dynamic IP assignment).

> But I want to the src port be changed in some conditions like this.
>                                    src:GA:50000+1000  src:SA:1000
>                                    dst:DA:23               dst:DA:23

Then you simply need rules matching your conditions.

Regards
Henrik
