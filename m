From: Massimiliano Cuzzoli <mcuzzoli@mbigroup.it>
Subject: Re: Problem with extended-match deletion
Date: Tue, 19 Aug 2003 16:14:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F4230B3.9090808@mbigroup.it>
References: <20030819102424.16725.44717.Mailman@kashyyyk> <012a01c36651$0889f970$010f430a@elite.co.in> <3F422834.3020702@mbigroup.it> <018401c36659$e505a220$010f430a@elite.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sumit Pandya <sumit@elitecore.com>
In-Reply-To: <018401c36659$e505a220$010f430a@elite.co.in>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ok Sumit,
now perhaps I've found my error:
I define:

static struct iptables_match bwcontrol = {
         NULL,
         "bwcontrol",
         NETFILTER_VERSION,
         IPT_ALIGN(sizeof(struct ipt_bwctrl_info)),
-->>>>  IPT_ALIGN(sizeof(struct ipt_bwctrl_info)),
         &help_bwcontrol,
         &init_bwcontrol,
         &parse_bwcontrol,
         &final_check,
         &print_bwcontrol,
         &save_bwcontrol,
         opts
};

Thank you very much!!!

Sumit Pandya wrote:
> I think you have overlooked some text from my previous reply
> 
>>>Are you sure you not changing (void*) matchinfo structure from
> 
> matchentry
> 
>>>function within kernel module?
> 
>     From your reply it seems that bwcontrol_checkentry is doing what I
> doubted. If it is so then in your userland library you need this kind of
> defination
> static
> struct iptables_match bwcontrol = {
>         NULL,
>         "bwcontrol",
>         NETFILTER_VERSION,
>         IPT_ALIGN(sizeof(struct ipt_bwctrl_info)),
>         offsetof(struct ipt_bwctrl_info, original),
>         &help_bwcontrol,
>         &init_bwcontrol,
>         &parse_bwcontrol,
>         &final_check,
>         &print_bwcontrol,
>         &save_bwcontrol,
>         opts
> };
> --Sumit
