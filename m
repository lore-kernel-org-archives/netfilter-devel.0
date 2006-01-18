From: Holger Eitzenberger <holger@my-eitzenberger.de>
Subject: Re: [PATCH] ULOG] Use better value for 'nlbufsiz'
Date: Wed, 18 Jan 2006 18:07:40 +0100
Message-ID: <20060118170740.GA5661@kruemel.my-eitzenberger.de>
References: <11375984923951-git-send-email-heitzenberger@astaro.com>
	<43CE71FA.1080800@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <43CE71FA.1080800@trash.net>
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

On Wed, Jan 18, 2006 at 05:51:06PM +0100, Patrick McHardy wrote:

> > This patch sets the default value to 3700 and adds some documentation
> > at the top.
> 
> I think we should just use NLMSG_GOODSIZE, which will use the maximum
> amount to fit one page on any architecture.

This sounds reasonable.  I will resend.

/holger
