From: Jan Andrejkovic <jandrejk@gmail.com>
Subject: Fwd: xtables extenstions - Unknown symbol xtnu_register_match/xtnu_unregister_match
Date: Sun, 7 Nov 2010 17:13:30 +0000
Message-ID: <AANLkTinvHR7dwmivcc53JEhUKFkETShZ8_FZNqJ4SwtY@mail.gmail.com>
References: <AANLkTimM06O=DfEjX+i9k1Q8=wp0430jzo=c9dk7n_QA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.214.194]:38774 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab0KGRNa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Nov 2010 12:13:30 -0500
Received: by iwn35 with SMTP id 35so1507620iwn.1
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Nov 2010 09:13:30 -0800 (PST)
In-Reply-To: <AANLkTimM06O=DfEjX+i9k1Q8=wp0430jzo=c9dk7n_QA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi gyus,

I compiled xtables-addons 1.30 on the Fedora12 kernel
2.6.32.23-170.fc12.i686 (./configure make make install)

Once I want to instert the module, I get below errors:

# insmod ./xt_geoip.ko
insmod: error inserting './xt_geoip.ko': -1 Unknown symbol in module
# insmod ./xt_ipv4options.ko
insmod: error inserting './xt_ipv4options.ko': -1 Unknown symbol in module

And dmesg shows:
xt_geoip: Unknown symbol xtnu_register_match
xt_geoip: Unknown symbol xtnu_unregister_match
xt_ipv4options: Unknown symbol xtnu_register_match
xt_ipv4options: Unknown symbol xtnu_unregister_match

Do you please have any hint?

I have also another minor issue - I commented out all the lines but
ipv4options, however all modules were compiled and installed anyway.

Thank you very much,

Jan
