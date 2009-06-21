From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/6] Core changes for better error reporting to
 userspace.
Date: Sun, 21 Jun 2009 15:09:08 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906211505060.12674@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0906202348470.11764@blackhole.kfki.hu> <alpine.LSU.2.00.0906210252050.8096@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:43962 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbZFUNJG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Jun 2009 09:09:06 -0400
In-Reply-To: <alpine.LSU.2.00.0906210252050.8096@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 21 Jun 2009, Jan Engelhardt wrote:

> On Saturday 2009-06-20 23:56, Jozsef Kadlecsik wrote:
> > 
> >+struct xt_error_entry {
> >+	__u8 errcode;
> >+	__u8 match;
> >+	unsigned char data[0];
> >+};
> >+
> >+#define XT_PTR_ERR	(MAX_ERRNO+1)
> >+
> 
> Also, the extensions return a positive non-zero value which is, if I
> paid attention correctly, passed back up to userspace unmodified. Old
> iptables may not expect that anything besides {-Inf..0} at all.

Old iptables won't issue *SO_GET_REPLACE but uses the "old" 
*SO_PUT_REPLACE operation. Also, the positive error-codes are not 
passed back as error codes but carried in the 'struct xt_error_entry' 
structures.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
