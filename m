From: Bernd Zeimetz <bernd@zeimetz.de>
Subject: Re: BUG: iptables -j does not work for chains with a length >=28
	(was moe infos...)
Date: Tue, 15 Nov 2005 17:15:31 +0100
Message-ID: <200511151715.32138.bernd@zeimetz.de>
References: <200511150139.51688.bernd@zeimetz.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: 327007@bugs.debian.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200511150139.51688.bernd@zeimetz.de>
Content-Disposition: inline
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

Hi,

> As you can see the bug does not happen for chains
> - with a length <=28
> - with a name containing only numbers
> - with a name beginning with numbers and having less than ~11 letters at
> the end.

this is - of course - not true. I didn't realize that

> iptables -N 123456789012345678yzabcdefgh
> and this works:
> iptables -A FORWARD -j 123456789012345678yzabcdefghij

this happened pretty often while testing.

> set_revision(target->t->u.user.name, target->revision); // iptables.c:2397

What does set_revision really do? Is it still needed?


Thanks,


Bernd
