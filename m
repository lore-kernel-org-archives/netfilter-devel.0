From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] matching any helper in ipt_helper.c
Date: Fri, 5 Mar 2004 08:14:43 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403050812350.5918-100000@filer.marasystems.com>
References: <Pine.LNX.4.60.0403041821010.21790@dsl093-017-216.msp1.dsl.speakeasy.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthew Strait <quadong@users.sourceforge.net>
In-Reply-To: <Pine.LNX.4.60.0403041821010.21790@dsl093-017-216.msp1.dsl.speakeasy.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 4 Mar 2004, Matthew Strait wrote:

> +       if(info->name[0] == '\0') /* special case meaning "any" */
> +               ret = !info->invert;

This also needs to be done earlier in the "no helper" case. You never get
here if there is no helper so ! any is a no-op.

Regards
Henrik
