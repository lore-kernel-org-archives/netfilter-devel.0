From: Rob Sterenborg <rob@sterenborg.info>
Subject: Re: [ANNOUNCEMENT] ipset-3.2
Date: Sat, 22 Aug 2009 21:30:55 +0200
Message-ID: <1250969455.12729.4.camel@kushiel.sterenborg.org>
References: <alpine.DEB.2.00.0908211609150.6879@blackhole.kfki.hu>
	 <alpine.LSU.2.00.0908212012250.24079@fbirervta.pbzchgretzou.qr>
	 <alpine.DEB.2.00.0908221527190.7819@blackhole.kfki.hu>
	 <alpine.LSU.2.00.0908221549540.11168@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.0908221549540.11168@fbirervta.pbzchgretzou.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2009-08-22 at 15:57 +0200, Jan Engelhardt wrote:
> Ah right. CentOS. Should have known. The platform where you can't
> deploy any modules, because during their backport spree, they failed
> to realize that external modules do rely on, say, < 2.6.22 _not_
> having skb_*_header(), but skb->nh. I've given up on them.
> 
> But thanks for the reminder. :)

Since, as far as I understood, Centos is supposed to be a free and as
much as possible binary compatible replacement for RHEL, does this also
go for RHEL or is this behaviour Centos specific?


Rob


