From: Tony Wan <visual2me@gmail.com>
Subject: does NAT based on iptables support TCP hole punch?
Date: Thu, 11 Jun 2009 11:42:44 +0800
Message-ID: <69b8237b0906102042q647797bdl88e16be088af6f45@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:39666 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbZFKDmm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:42:42 -0400
Received: by qw-out-2122.google.com with SMTP id 5so850534qwd.37
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2009 20:42:44 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

It's said that TCP hole punch does not work if both endpoints come
from 2 sub-networks, whose NAT are both implemented by iptables. I
just want to make sure whether this is true. If so, what type of nat
can iptables work as? full-cone, restricted, port restricted, or
symmetric?

Sorry if it's not appropriate to ask such a question here. Thanks in advance.

-- 
Best regards,
Tony Wan
