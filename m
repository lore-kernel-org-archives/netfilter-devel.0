From: Patrick McHardy <kaber@trash.net>
Subject: Re: [POSSIBLE PATCH] DECLARE_MUTEX while not in __KERNEL__ (Was:
 Re: [Fwd: RE: Second Request for help!!])
Date: Tue, 8 Feb 2005 07:54:20 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0502080751120.32526@kaber.coreworks.de>
References: <57143.142.169.215.10.1107791547.squirrel@142.169.215.10>
	<4207FF25.1060404@cookinglinux.org> <42080504.2080606@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	jamal <hadi@cyberus.ca>, John Hill <jhill@noach.com>,
	sjean@cookinglinux.org
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42080504.2080606@eurodev.net>
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

On Tue, 8 Feb 2005, Pablo Neira wrote:
> Anyway, I didn't find any client of ipt_mutex. I think it's better if we move 
> it to its original place, ip_tables.c.

Agreed, we already got rid of this in 2.6. I've applied your patch,
thanks.

Regards
Patrick
