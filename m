From: Balint Cristian <rezso@rdsor.ro>
Subject: Re: iptables+2.6-test8-bk4 : Still problems
Date: Sun, 26 Oct 2003 10:52:25 -0500
Sender: sparclinux-owner@vger.kernel.org
Message-ID: <200310261052.25944.rezso@rdsor.ro>
References: <3F9B8A5D.9010803@triaton-webhosting.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
To: Georg Chini <georg.chini@triaton-webhosting.com>,
	sparclinux@vger.kernel.org, netfilter-devel@lists.netfilter.org
In-Reply-To: <3F9B8A5D.9010803@triaton-webhosting.com>
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

On Sunday 26 October 2003 03:48, Georg Chini wrote:

> /usr/local/sbin/iptables -A INPUT -i ppp0 -j ACCEPT
> works, but the corresponding
> /usr/local/sbin/iptables -D INPUT -i ppp0 -j ACCEPT
> does not, again I get "invalid argument".


I object too, a simple "iptables -F" not work, see here:

-------------------------------------------///-------------------------------------
[root@sun root]# iptables -L -n
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
REJECT     tcp  --  0.0.0.0/0            0.0.0.0/0          tcp dpt:631 reject-with tcp-reset

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
[root@sun root]# iptables -F INPUT
iptables: No chain/target/match by that name
[root@sun root]#
------------------------------------////------------------------------------------------------------

	I can add rules even can delete rules, accounting seems to work on rules but only rules FLUSH
don't work.

Using: iptables v1.2.8 + 2.6.0-test8-bk2 + davem.netfilter-compat-patch

cristian


>
> Thanks in advance
>                    Georg Chini
>
> -
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Life in itself has no meaning. 
Life is an opportunity to create meaning.

              \|/ ____ \|/ 
              "@'/ .. \`@" 
              /_| \__/ |_\ 
                 \__U_/ 

