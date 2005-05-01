From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: wow, why does everything presume ethernet? Re: skb->mac.raw,
 when is does it point to ethhdr
Date: Sun, 1 May 2005 22:54:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0505012244340.23014@filer.marasystems.com>
References: <d4r2n4$o39$1@sea.gmane.org>
	<Pine.LNX.4.61.0504290113360.26003@filer.marasystems.com>
	<427258BF.7080405@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <427258BF.7080405@ufomechanic.net>
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

On Fri, 29 Apr 2005, Amin Azez wrote:

> However, to get at a source mac address is still uncertain, maybe I need to 
> dispatch to a different routine or different offsets based on input_dev->type 
> ?

You need to know each and every link layer you need to support.

The link layer part of the packet isn't supposed to be accessed outside of 
the link layer, so this isn't made easy.

> Does anyone know without looking how "ifconfig" works out how to format the 
> mac address?

If I am not wrong it simply hexdumps it with : between the octets. Length 
is known. But there may be special cases for some link layers.. see the 
source to make be sure. iproute just hext dumps it with :.

Regards
Henrik
