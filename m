From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: NAT for IPv6 Update
Date: Sat, 22 May 2004 09:24:25 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405220921140.10115-100000@blackhole.kfki.hu>
References: <20040521224419.25928.qmail@web90007.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Natty McButterpants <ipv6natlover@yahoo.com>
In-Reply-To: <20040521224419.25928.qmail@web90007.mail.scd.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 May 2004, Natty McButterpants wrote:

> Just an update, we have UDP getting NAT'ed properly, and hope to have
> TCP done by the weekend.  We may also setup TFTP before releasing the
> code, not sure yet.  Expect a posting of the code sometime within the
> next week.  If you are specifically interested in getting the code,
> email us.  Our primary difficulty has been the way to re-calculate the
> checksum using the in6_addr struct instead of the old 32int, but we
> got it figured out.  Man is this going to upset the IETF or what? :)

I hope this work is based on Yasuyuki Kozakai's nf_conntrack
generalization...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
