From: Patrick McHardy <kaber@trash.net>
Subject: Re: p-o-m: nf-log fix
Date: Tue, 10 Aug 2004 14:21:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4118BDC3.5020801@trash.net>
References: <1092136409.2905.357.camel@develbox.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nikola Ciprich <extmaillist@linuxbox.cz>
In-Reply-To: <1092136409.2905.357.camel@develbox.linuxbox.cz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Nikola Ciprich wrote:

>Hi, I think there is small bug in nf-log p'o'm patchset,
>can You please apply following patch: (in case it is correct)
>  
>
Applied, thanks.

Regards
Patrick

>diff -Naur patch-o-matic-ng-20040809/nf-log/linux-2.4.patch
>patch-o-matic-ng-20040809-nf-log_fix/nf-log/linux-2.4.patch
>--- patch-o-matic-ng-20040809/nf-log/linux-2.4.patch    2004-02-19
>12:36:55.000000000 +0100
>+++ patch-o-matic-ng-20040809-nf-log_fix/nf-log/linux-2.4.patch
>2004-08-10 12:07:10.644846287 +0200
>@@ -402,7 +402,7 @@
> +      }
> +
> +      /* if threshold is reached, send message to userspace */
>-+      if (qlen >= loginfo.qthreshold) {
>++      if (ub->qlen >= loginfo.qthreshold) {
> +              if (loginfo.qthreshold > 1)
> +                      nlh->nlmsg_type = NLMSG_DONE;
> +      }
>
>thanks,
>n.
>
>
>  
>
