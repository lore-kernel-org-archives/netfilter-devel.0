From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: New to IPSets - Not working as expected
Date: Tue, 20 Jun 2006 11:49:23 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0606201145510.9358@blackhole.kfki.hu>
References: <20060619053646.47093.qmail@web42203.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Manish Jain <jain_m79@yahoo.com>
In-Reply-To: <20060619053646.47093.qmail@web42203.mail.yahoo.com>
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

On Sun, 18 Jun 2006, Manish Jain wrote:

> I want to dump all packets coming from IP 192.168.1.18
> in syslog. For this, I have created following ipset
> and iptable. But it is not working for me. Please
> guide me.
>
> ipset -N test2 ipmap --from 192.168.1.1 --to
> 192.168.255.255
> iptables -A INPUT -m set --set test2 src -j LOG

You created an empty set without adding any element to it. Just add
192.168.1.18 to test2 and the iptables rule will match:

ipset -A test2 192.168.1.18

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
