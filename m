From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: More work on ebtables-compat
Date: Thu, 9 Oct 2014 20:20:19 +0200
Message-ID: <20141009182019.GA24754@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34705 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaJISTC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2014 14:19:02 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

I just pushed some more rework of the initial bootstrap:

http://git.netfilter.org/iptables/log/?h=ebtables-compat-experimental2

Please, rebase your changes upon this.

Basically, this large patch:

http://git.netfilter.org/iptables/commit/?h=ebtables-compat-experimental2&id=215adb8ffadd682aa3fd72c0847f1b154d95c7a7

that introduces the 'struct ebtables_command_state' so this code gets
closer to {ip,ip6,arp}tables-compat. I also introduced a fake
ebt_entry struct.

I believe this will potentially allow us to consolidate more common
code.

Now I think it's a matter of filling the gaps with code that mimics
ebtables.
