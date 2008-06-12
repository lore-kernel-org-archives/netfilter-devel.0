From: michael <mteicher@gmail.com>
Subject: iptables 1,4,1 install error
Date: Wed, 11 Jun 2008 22:12:46 -0700
Message-ID: <66c5208e0806112212o47bc2c54l87be5d49b4548834@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:2351 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYFLFMq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2008 01:12:46 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1829193rvb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2008 22:12:46 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Can anyone shed some light on installing iptables1.4.1 on a linux kernel 2.4.34.
make install fails with the following:
Making install in extensions
make[1]: Entering directory `/home/src/iptables-1.4.1/extensions'
install -pm0755 "usr/local/libexec/xtables/";
install: too few arguments
Try `install --help' for more information
make[1]: *** [install] error 1
make[1]: Leaving directory `home/src/iptables-1.4.1/extensions'
make; *** [install-reecursive] Error 1

Thanks,

Michael...
