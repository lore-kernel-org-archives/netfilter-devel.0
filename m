From: Phil Oester <kernel@linuxace.com>
Subject: Re: TCP Connection tracking and SYN/ACK/PSH
Date: Mon, 18 Apr 2005 16:06:14 -0700
Message-ID: <20050418230614.GA426@linuxace.com>
References: <20050417193718.6a7f0809.gniibe@fsij.org>
	<Pine.LNX.4.61.0504180316120.4321@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, NIIBE Yutaka <gniibe@fsij.org>,
	ukai@debian.or.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0504180316120.4321@filer.marasystems.com>
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

On Mon, Apr 18, 2005 at 03:34:41AM +0200, Henrik Nordstrom wrote:
> Just a small note to support this: SYN+ACK+PSH is a perfectly valid flags 
> combination, even more so if there actually is data enclosed in the 
> SYN+ACK (which is valid, only a little odd).
> 
> There is not really any good reason why conntrack should care in detail 
> about the PSH flag. Most if not all valid flag combinations are good both 
> with and without PSH (even SYN).

Given that nmap's Xmas tree scan uses an invalid PSH flag combination to scan
for open ports, I'd suggest conntrack should care about the flag.

While the particular combination being seen here is likely always harmless,
perhaps netfilter should only allow RFC-defined handshakes as a general
rule.

Phil
