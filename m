From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/5] [CTNETLINK] Fix expectation mask dumping
Date: Mon, 27 Feb 2006 19:50:06 +0100
Message-ID: <440349DE.2070903@netfilter.org>
References: <44025F8A.6070302@netfilter.org>
	<200602271732.k1RHWOFO025405@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200602271732.k1RHWOFO025405@toshiba.co.jp>
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

Hi Yasuyuki,

Yasuyuki KOZAKAI wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Mon, 27 Feb 2006 03:10:18 +0100
> 
>>This patch introduces the function ctnetlink_exp_dump_mask, that
>>correctly dumps the expectation mask. Such function uses the l3num value
>>from the expectation tuple that is a valid layer 3 protocol number.
>>
>>The value of the l3num mask isn't dumped since it is meaningless from
>>the userspace side.
> 
> At first, this patch seems to be for net-2.6.17. This fix isn't really
> necessary to 2.6.16 ?

Yes, it's necessary.

> I've noticed missing nesting with CTA_EXP_MASK in this function. Please
> apply the attached patch on top of your patch. I tested it with ftp helper,
> ftp server, and telnet with IPv6. And I saw that kernel filled expectation
> mask in CTA_EXP_MASK area.

Thanks a lot Yasuyuki. Annoying that I forgot about this. I'm going to
resend a patch in some hours.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
