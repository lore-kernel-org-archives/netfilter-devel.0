From: Jason Huang <u9067580@cis.nctu.edu.tw>
Subject: Re: how to delete a piece of rule in iptables?
Date: Thu, 19 Dec 2002 09:09:10 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E011C36.5000108@cis.nctu.edu.tw>
References: <200212181230.UAA02960@email.whu.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>,
        "bobowd@sohu.com" <bobowd@sohu.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: bobo <boboaq@163.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

bobo =CC=E1=B5=BD:

>             i have insert some rules to iptables firewall.now,i would=20
>like to delete it  .
>but i only know to use iptalbes -L to empty them.
>but it lead to delete all the rules in it.
>how to do ??
>
>
>
> =20
>
This address is for developer, your question should be post in user
mailinglist.


The "-L" option will list all rules, use belows to flush it and use "man
iptables" to see more.
iptables -F
iptables -F -t nat
iptables -F -t mangle

iptables -X
iptables -X nat
iptables -X mangle

/Jason
