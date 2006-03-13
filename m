From: Patrick McHardy <kaber@trash.net>
Subject: Re: Knowing tables change
Date: Mon, 13 Mar 2006 15:55:11 +0100
Message-ID: <441587CF.4050203@trash.net>
References: <44155BE4.80001@wengo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sebastien Tricaud <sebastien.tricaud@wengo.fr>
In-Reply-To: <44155BE4.80001@wengo.fr>
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

Sebastien Tricaud wrote:
> Hi folks,
> 
> I would like to know if there is a way to watch for tables alteration.
> 
> I am sure there is a better way than doing "iptables -t table -L" loop
> and compare with previously stored data.

watch -n 1 -d iptables -vxnL :)

> When I look over Internet for possible answers, I can find something
> that would do the job. It seems libpkttnetlink is for this purpose.
> However no developments are latter than 2002. Is it a working stuff and
> nothing has to be improved anymore ?
> 
> At a lower level, I can see libnfnetlink is the low level library I can
> also use for it: there is the following quote -> "provides
> open/close/receive functions only to be used by other libraries
> libctnetlink/libpkttnetlink".

There are no notifications for ruleset updates currently, since
ruleset exchange between kernel and userspace isn't built on
netlink and happens as one atomic operation, so the kernel
doesn't know which rules are new.
