From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip_conntrack_ftp segfault
Date: Tue, 01 Feb 2005 14:24:47 +0100
Message-ID: <41FF831F.30407@trash.net>
References: <41D99B6B.6050601@cookinglinux.org> <41DA715D.2080704@eurodev.net>
	<41DAE455.9090207@cookinglinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
To: Nicolas Bouliane <nib@cookinglinux.org>
In-Reply-To: <41DAE455.9090207@cookinglinux.org>
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

Nicolas Bouliane wrote:

>>> This patch fix two bugs (when DEBUGP is defined):
>>> o The var `data` doesn't exist, hence gcc complains.
>>> o It segfault because we print an integer with `%s`.
>>
>
> Signed-off-by: Nicolas Bouliane <nib@cookinglinux.org>

Applied, thanks.

Regards
Patrick
