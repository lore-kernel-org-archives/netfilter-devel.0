From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: MARK targets all non-terminating
Date: Mon, 8 Jan 2007 08:56:46 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0701080850340.31801@blackhole.kfki.hu>
References: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>
	<459AA3B2.4010008@shorewall.net>
	<Pine.LNX.4.61.0701070254230.27682@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Tom Eastep <teastep@shorewall.net>, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0701070254230.27682@yvahk01.tjqt.qr>
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

On Sun, 7 Jan 2007, Jan Engelhardt wrote:

> I was about to extend the kernel and iptables to support something along the
> lines of
>
>  iptables -t mangle -A POSTROUTING -j MARK --mark 117 --terminate
>
> but then faced the problem of what verdict to return in xt_MARK when
> --terminate is given. NF_DROP? No, that could possibly interfere
> with the default chain policy. Same goes for NF_ACCEPT. NF_STOLEN,
> NF_QUEUE and NF_STOP do not seem to be the right ones either. We'd
> need some sort of NF_EXIT in ipt_do_table, which essentially jumps
> right out of all user-defined chains to the end of the table to hit
> the default policy.

Why should the processing be continued? If the packet is to be marked then 
it's highly unlikley it should at the same time be dropped. So in my 
opinion a simple NF_ACCEPT would be a perfect return value.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
