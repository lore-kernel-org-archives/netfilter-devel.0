From: "Fabrice MARIE" <fabrice@fma.homelinux.com>
Subject: Re: Time match problem
Date: Thu, 19 Jun 2003 19:15:23 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <003d01c33654$13b6b680$0207a8c0@endromeda>
References: <20030619100134.5419.qmail@sina.com>
Reply-To: "Fabrice MARIE" <fabrice@fma.homelinux.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello

> Hi,
> When I am using the time match ,I have the following command:
>  iptables -A FORWARD -m time --timestart 08:00 --timestop 18:00  --days
Mon -j ACCEPT
> This works well,but when i delete the rule,I have the following command:
>  iptables -D FORWARD -m time --timestart 08:00 --timestop 18:00  --days
Mon -j ACCEPT
> It does not work,and display:

I'm aware of the problem for quite some time, it's just that I need a bit of
time to fix it...
But I'll do it soon, I promise :)

Cheers,

Fabrice.
--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown
