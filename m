From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables.c changes submitted argv value
Date: Wed, 11 Aug 2004 23:23:28 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408112322410.5470@filer.marasystems.com>
References: <IDEAKKJENKGNPNLKJKODEEAECAAA.listuser@epygi.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sascha <listuser@epygi.de>
In-Reply-To: <IDEAKKJENKGNPNLKJKODEEAECAAA.listuser@epygi.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 11 Aug 2004, Sascha wrote:

> The Problem is i wanna build a deamon with iptables, which load's a static
> ruleset on init.

The recommended method for doing this is using iptables-restore via a pipe 
from your daemon.

Regards
Henrik
