From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: REPOST: nfnetlink / ctnetlink / iptables2 questions
Date: Sat, 18 Dec 2004 11:17:45 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412181111530.27672@filer.marasystems.com>
References: <41C3C4B3.2060003@ipom.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Dibowitz <phil@ipom.com>
In-Reply-To: <41C3C4B3.2060003@ipom.com>
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

On Fri, 17 Dec 2004, Phil Dibowitz wrote:

> At the very least, libnfnetlink requires nfnetlink.h, which I would have 
> thought was part of libnfnetlink, but it appears it's not.

It is included as part of the required nfnetlink-ctnetlink kernel patch.

Regards
Henrik
