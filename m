From: Christophe Saout <christophe@saout.de>
Subject: Re: 2.6 IPSEC + SNAT
Date: Wed, 01 Oct 2003 16:56:43 +0200
Sender: linux-net-owner@vger.kernel.org
Message-ID: <1065020203.4745.10.camel@chtephan.cs.pocnet.net>
References: <20031001121648.GA8755@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-net-owner@vger.kernel.org>
To: kuznet@ms2.inr.ac.ru, davem@redhat.com, jmorris@redhat.com,
	linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org
In-Reply-To: <20031001121648.GA8755@gondor.apana.org.au>
List-Id: netfilter-devel.vger.kernel.org

Am Mi, den 01.10.2003 schrieb Herbert Xu um 14:16:

> Any opinions on this would be appreciated.

The "old" frees/wan klips kernel code did it this way: It defined a new
virtual network interface named ipsec0. Then userspace set up routes,
everything that had to be encrypted was sent to ipsec0.

So I could NAT my packets in the POSTROUTING chain of the packets going
to ipsec0. Then they were encrypted and sent to the real device, like
ppp0.

On the other way round I could catch the packets two times, the
encrypted packets with "iptables -t filter -A INPUT -i ppp0 ..." and the
decrypted ones with "iptables -t filter -A INPUT/FORWARD -i ipsec+" (if
a natted packet returns or a subnet was tunneled).

I'm not saying that you must do it the same way, but it was very
flexible.

Would it be possible to run a packet that was encrypted or decrypted
through netfilter a second time? Or how does the current mechanism
generally work (and integrate with routing/filtering), are there some
diagrams or something?

--
Christophe Saout <christophe@saout.de>
Please avoid sending me Word or PowerPoint attachments.
See http://www.fsf.org/philosophy/no-word-attachments.html

