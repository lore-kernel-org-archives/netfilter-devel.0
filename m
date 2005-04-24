From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] Fix ipt_ACCOUNT for large networks - 2nd try
Date: Sun, 24 Apr 2005 18:52:30 +0200
Message-ID: <426BCECE.1060103@trash.net>
References: <200504050948.51387.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
In-Reply-To: <200504050948.51387.thomas.jarosch@intra2net.com>
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

Thomas Jarosch wrote:
> attached is a patch to fix the ACCOUNT target for large networks.
> This time for good ;-) Discard the patch I sent yesterday.

Please resend as attachment, your mailer converted tabs to spaces.

patching file linux/net/ipv4/netfilter/ipt_ACCOUNT.c
Hunk #1 FAILED at 3.
Hunk #2 FAILED at 694.
Hunk #3 FAILED at 713.
Hunk #4 FAILED at 734.
Hunk #5 FAILED at 755.
Hunk #6 FAILED at 776.
Hunk #7 FAILED at 803.
Hunk #8 FAILED at 814.
8 out of 8 hunks FAILED -- saving rejects to file 
linux/net/ipv4/netfilter/ipt_ACCOUNT.c.rej

Regards
Patrick
