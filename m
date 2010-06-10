From: Mohit Mehta <mohit.mehta@vyatta.com>
Subject: `conntrack -L --src-nat --dst-nat` doesn't work with version 0.9.14
Date: Wed, 9 Jun 2010 17:30:17 -0700 (PDT)
Message-ID: <1795331132.150261276129817743.JavaMail.root@tahiti.vyatta.com>
References: <228485269.150241276129581116.JavaMail.root@tahiti.vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:56761 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410Ab0FJAb5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jun 2010 20:31:57 -0400
In-Reply-To: <228485269.150241276129581116.JavaMail.root@tahiti.vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Everyone,

With previous versions of conntrack [for eg. version 0.9.6]; you could list conntrack entries and have them filtered for both source and destination NAT. This was great for looking at all NAT entries at the same time.

However, it seems that in the current version that doesn't work i.e. you cannot filter entries for both source and destination NAT together. Filtering on either of the two types still works fine. I'm not quite sure about the history of this if any; so can someone point out whether this change was intentional or an oversight?

Thanks,
Mohit
