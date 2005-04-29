From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: skb->mac.raw, when is does it point to ethhdr
Date: Fri, 29 Apr 2005 16:52:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504290113360.26003@filer.marasystems.com>
References: <d4r2n4$o39$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <d4r2n4$o39$1@sea.gmane.org>
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

On Thu, 28 Apr 2005, Amin Azez wrote:

> So the question comes up, how do we tell when skb->mac.raw is pointing to an 
> ethernet frame header and when it is pointing to something else?

IIRC You need to look at the link type of the device the packet came from.

Regards
Henrik
