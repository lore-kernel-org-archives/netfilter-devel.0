From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: TCP Connection tracking and SYN/ACK/PSH
Date: Mon, 18 Apr 2005 03:34:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504180316120.4321@filer.marasystems.com>
References: <20050417193718.6a7f0809.gniibe@fsij.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, ukai@debian.or.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: NIIBE Yutaka <gniibe@fsij.org>
In-Reply-To: <20050417193718.6a7f0809.gniibe@fsij.org>
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

On Sun, 17 Apr 2005, NIIBE Yutaka wrote:

> Linux 2.6 cannot connect to (a version of) MELCO Wireless Print
> Server.  It is because MELCO Wireless Print Server responds SYN/ACK/PSH,
> when it gets SYN.  And Linux connection tracking for TCP cannot handle
> SYN/ACK/PSH.

Just a small note to support this: SYN+ACK+PSH is a perfectly valid flags 
combination, even more so if there actually is data enclosed in the 
SYN+ACK (which is valid, only a little odd).

There is not really any good reason why conntrack should care in detail 
about the PSH flag. Most if not all valid flag combinations are good both 
with and without PSH (even SYN).

Regards
Henrik
