From: Thomas De Schampheleire <patrickdepinguin@gmail.com>
Subject: iptables: missing connlabel.conf causes unnecessary error messages
Date: Fri, 5 Sep 2014 10:06:35 +0200
Message-ID: <CAAXf6LW4zfxOMeUO4=UPFUX=0VGjLbM_wKhdb3L7DK4SPBmbhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:61208 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbaIEIG4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:06:56 -0400
Received: by mail-la0-f46.google.com with SMTP id pv20so13472471lab.33
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Sep 2014 01:06:55 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Commit http://git.netfilter.org/iptables/commit/?id=51340f7b6a1103b12d86ef488f7140406d80401e
removed the default /etc/xtables/connlabel.conf file distributed with netfilter.

>From this commit onwards, every call to iptables will show the message:
    cannot open connlabel.conf, not registering 'connlabel' match: No
such file or directory

Creating an empty connlabel.conf file does not really help, the
message now becomes:
    cannot open connlabel.conf, not registering 'connlabel' match: Success

In order to remove the message, we have to specify at least one label,
for example '0 foo'.

I don't think this is correct behavior: even when not using connlabel
at all, iptables will print an error/warning in its default
installation. The only way to remove this warning is to create a dummy
rule.

Moreover, I do not understand the reasoning of the mentioned commit:
what is the problem in respecting sysconfdir? There are so many
applications and libraries that use autoconf and can have
configuration files in a place respecting sysconfdir.

Finally, even if you do not want to provide a default file with the
iptables installation, an empty file (created by the user) should hide
the error message.

What is your view on this?

Thanks,
Thomas
