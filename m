From: Patrick McHardy <kaber@trash.net>
Subject: Re: CONFIG_NETFILTER_DEBUG
Date: Wed, 29 Mar 2006 10:19:47 +0200
Message-ID: <442A4323.2030205@trash.net>
References: <08590A72DC26A54B85632FF97C2C22DA019ED1D6@XCH-NW-5V2.nw.nos.boeing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Spagnolo, Phillip A" <phillip.a.spagnolo@boeing.com>
In-Reply-To: <08590A72DC26A54B85632FF97C2C22DA019ED1D6@XCH-NW-5V2.nw.nos.boeing.com>
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

Spagnolo, Phillip A wrote:
> I have compiled CONFIG_NETFILTER_DEBUG into a Linux 2.6.11 kernel.  I am
> expecting to find a lot of printing in /var/log/messages due to this
> addition, but I find none.  
> 
> Is there something simple that I am missing.  Do I need to do something
> with nf_debug?

CONFIG_NETFILTER_DEBUG only enables a few global debugging options,
most of the files have something like this at their top:

#if 0
#define DEBUGP printk
#else
#define DEBUGP(x)
#endif
