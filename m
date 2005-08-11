From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Error compile kernel 2.6.11.7 w/ pptp_conntrack_nat
Date: Thu, 11 Aug 2005 18:41:01 +0200
Message-ID: <42FB7F9D.7080007@gmail.com>
References: <42FA9451.90206@ip3.com> <42FB7449.2090007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <42FB7449.2090007@gmail.com>
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

Jiri Slaby napsal(a):

> In this kernel __ip_conntrack_expect_find isn't implemented, apply 
> ctnetlink patch and compile again.
> Despite, there is a bug, I think there should be

No, it isn't. It is adequate to depend on netfilter.

> select IP_NF_CONNTRACK_NETLINK
> in Kconfig if it uses it.
>

-- 
Jiri Slaby         www.fi.muni.cz/~xslaby
~\-/~      jirislaby@gmail.com      ~\-/~
241B347EC88228DE51EE A49C4A73A25004CB2A10
