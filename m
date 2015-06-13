From: "Roberto Santalla Fdez." <roobre@roobre.es>
Subject: Does arptables support adding new extensions dinamically like
 iptables does?
Date: Sat, 13 Jun 2015 02:55:36 +0200
Message-ID: <8138a5d415b532939d43593e8382f92c@roobre.es>
References: <6d5911260a4d58c9a66062858405a03a@roobre.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tenshi.com.es ([62.210.204.61]:44429 "EHLO tenshi.com.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbbFMAzh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 20:55:37 -0400
Received: from mail.tenshi.com.es (tenshi.com.es [62.210.204.61])
	by tenshi.com.es (Postfix) with ESMTPSA id C16E182392
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Jun 2015 02:55:36 +0200 (CEST)
In-Reply-To: <6d5911260a4d58c9a66062858405a03a@roobre.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm currently introducing myself into kernel development, and I decided 
to give building an xtables module a try. I'm trying to write a very 
simple arptable modules which checks whether an ARP requests comes from 
a given IP.

I've built the kernel module and the userspace library, but arptables 
seems to ignore it (module's name is arpway):

     [root@Archpv3]# ~> arptables -F
     [root@Archpv3]# ~> arptables -A INPUT -m arpway -j ACCEPT
     [root@Archpv3]# ~> arptables-save
     *filter
     :INPUT ACCEPT
     :OUTPUT ACCEPT
     :FORWARD ACCEPT
     -A INPUT -j ACCEPT

also, `arptables -m arpway -h` does not print my module's help text.

Just to check, if I change the module's scope to ipv4 (setting 
`xtables_match.family` to `NFPROTO_IPV4`), module's help is successfully 
printed with `iptables -m arpway -h`, and adding the rule and then 
printing it works.

Needless to say, module is successfully complied and `insmod`'ed, and 
userspace library is placed in `/usr/lib/iptables/libxt_arpway.so`.

Am I doing something wrong, or does arptables not support dynamic 
extensions/modules like iptables does?

Regards and thanks in advance, Roberto.
