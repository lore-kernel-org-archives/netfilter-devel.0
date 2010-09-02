From: Amir Herzberg <amir.herzberg@gmail.com>
Subject: Resolver behind NetFilter NAT service vulnerable to DNS poisoning attack
Date: Thu, 2 Sep 2010 15:50:08 +0200
Message-ID: <AANLkTikVRqRjzzoRyDQzA0AiO1_kBNYiTwEZ2cLnsxhe@mail.gmail.com>
References: <AANLkTikjFnoh_=PX7YDv18O46JhLFnyXQ9-f2CEumqRd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43925 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0IBNuJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:50:09 -0400
Received: by yxp4 with SMTP id 4so143042yxp.19
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Sep 2010 06:50:08 -0700 (PDT)
In-Reply-To: <AANLkTikjFnoh_=PX7YDv18O46JhLFnyXQ9-f2CEumqRd@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We investigate some issues related to DNS poisoning, and specifically,
an attack that poisons DNS cache, similar to Kaminski's attack, but
that works even if the resolver selects random ports, as long as
resolver is connected to the Internet via NAT. In particular, we
tested the attack for the NetFilter NAT.

For obvious reasons, I prefer at this point to share details only with
developers of NAT devices. If you are such developer, please contact
me and I can send you the details (paper).
Feel also welcome to forward the messages to individuals/forums which
may be relevant (i.e., developers).

I apologize for not being able to promise to respond to requests from
people who are just curious (i.e., not NAT developers). Thanks for
your understanding.
--
Amir Herzberg
Associate Professor, Dept. of Computer Science
Bar Ilan University
http://AmirHerzberg.com



--
Amir Herzberg
Associate Professor, Dept. of Computer Science
Bar Ilan University
http://AmirHerzberg.com
