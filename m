From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Maintaining MARKs  on packets throughout the network
Date: Thu, 8 Jul 2004 08:37:03 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407080832490.16639-100000@filer.marasystems.com>
References: <1089249142.40ec9f762049b@webmail.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: sami@ccse.kfupm.edu.sa
In-Reply-To: <1089249142.40ec9f762049b@webmail.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 8 Jul 2004 sami@ccse.kfupm.edu.sa wrote:

> I am sorry if this question has been asked on the list before, but is it
> possible to maintain the mark on packets even when they leave the
> router. I want to recieve packet with the same mark value that was
> assigned to it at the ingress router.

Not unless you can fully replicate the rules deducing the mark to all 
places where the mark is needed.

nfmark is local to the router/server only and not visible within the
packet contents. If you want some kind of packet marks actually visible on
the network you basically have two choices:

  a) Use the TOS/DS field

  b) Write a extension adding a custom IP option carrying the information
you need to preserve about the packet.

Regards
Henrik
