From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: question about log kernel modules and log of iptables
Date: Mon, 4 Oct 2004 13:59:56 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0410041358140.28418@filer.marasystems.com>
References: <4160C993.000072.19484@m250.163.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?gb2312?B?Z2FpbHlh?= <gailya@163.com>
In-Reply-To: <4160C993.000072.19484@m250.163.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 4 Oct 2004, [gb2312] gailya wrote:

> However, I don't know how iptables generates log messages and how it 
> deals with it.

Normally via the kernel message rinbugger processed by klogd.

There is also the ULOG target which sends log messages via netlink to a 
log deamon of your choice.

> I wonder whether I should alter the log kernel module if 
> I want more detailed info, and how. Anyone can give me some help or 
> hints. Any related information and hints would be appreciated.

See the ipt_LOG.c file for the normal log function. Nothing strange 
there..

Regards
Henrik
