From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Port Expectation
Date: Wed, 25 Jun 2003 09:19:41 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0306250918320.7456-100000@blackhole.kfki.hu>
References: <Sea2-F66YluLCTaogxL0000049f@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ricky Foo <blue_pion@hotmail.com>
In-Reply-To: <Sea2-F66YluLCTaogxL0000049f@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 25 Jun 2003, Ricky Foo wrote:

> For this piece of code in ip_nat_ftp.c, why are we change the port to use?
> If your protocol uses the same protocol port number for both the src & dest
> port (in my case always 138 in both direction), I suppose there is no need
> to change the expected port to some other values?
>
> ++++++++++++++++++++++++++++++++++++++++++++++++++
>
>   /* Try to get same port: if not, try to change it. */
>   for (port = ct_ftp_info->port; port != 0; port++)
>   {
> 	newtuple.dst.u.tcp.port = htons(port);
> 	if (ip_conntrack_change_expect(expect, &newtuple) == 0)
> 		break;
>   }

It's required to avoid clashing with a connection already mapped to the
port in question.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
