From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.4.x][RFC] enlarge struct ipt_log_info prefix to 62
	bytes
Date: Wed, 22 Dec 2004 12:47:17 +0100
Message-ID: <41C95EC5.6090803@trash.net>
References: <41C6BDC7.8060507@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <41C6BDC7.8060507@tac.ch>
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

Roberto Nibali wrote:

> Concerning netfilter there is one I think others might "benefit" from as 
> well. Here's the patch we're using to enlarge the prefix member of the 
> struct ipt_log_info structure in ipt_LOG.h:
> 
>  struct ipt_log_info {
>         unsigned char level;
>         unsigned char logflags;
> -       char prefix[30];
> +       char prefix[62];
>  };

This breaks binary compatibility, so we can't put it in.
Otherwise I'd agree, 30 byte is kind of small. Maybe it
will be possible with Rusty's and Pablo's work to extend
structures without breaking compatibility.

Regards
Patrick
