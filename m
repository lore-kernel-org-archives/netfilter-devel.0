From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 2/2] ipt_hashlimit.c: hash only once
Date: Sun, 20 Feb 2005 15:39:25 +0100
Message-ID: <4218A11D.5060008@eurodev.net>
References: <421428F2.4030404@cookinglinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
To: sjean@cookinglinux.org
In-Reply-To: <421428F2.4030404@cookinglinux.org>
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

Samuel Jean wrote:

> Name: hash only once
> Status: Tested on Linux 2.6.10.
>          Patch against 2.6.11-rc4-bk2
>          Incremental to previous hlist_head patch [1/2]
> Signed-off-by: Samuel Jean <sjean@cookinglinux.org>
>
> Harald: this patch might be crap.
>
> I couldn't find the reason on why we initialize random seed only on 
> first entry.


I posted something similar some time ago, please read:

https://lists.netfilter.org/pipermail/netfilter-devel/2004-April/014969.html

--
Pablo
