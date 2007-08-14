From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Kernel panic (destroy_conntrack) unloading nf_conntrack_ftp
 before
Date: Tue, 14 Aug 2007 10:16:10 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708141013570.30582@fbirervta.pbzchgretzou.qr>
References: <f9h80e$uoo$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Gelf <thomas@gelf.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <f9h80e$uoo$1@sea.gmane.org>
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


On Aug 10 2007 10:35, Thomas Gelf wrote:
>
> * 2.6.20 "broke" our behaviour as all the nf-thingies have been renamed

Blame your distro for not coping with it. 
Try 2.6.22.2 in the meantime... :)

> * nf_conntrack_ftp has been loaded manually before as a customer
>  complained about having problems with passive ftp

If you want to NAT FTP, you also need nf_nat_ftp.

> Afterwards we did exactly the same thing (also modprobe / rmmod several
> times) on three other servers, all of them running the same kernel,
> shorewall and debian: no problem at all. The only difference was that
> there has probably been no established ftp session.

	Jan
-- 
