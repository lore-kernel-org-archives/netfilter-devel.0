From: Bryan Duff <bduff@ecessa.com>
Subject: Xtables compile fails.
Date: Wed, 15 Apr 2009 09:07:26 -0500
Message-ID: <49E5EA1E.6060504@astrocorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.astrocorp.com ([64.122.215.18]:21459 "EHLO
	mail.astrocorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbZDOOcH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:32:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.astrocorp.com (Postfix) with ESMTP id 835DD630C2
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2009 09:06:55 -0500 (CDT)
Received: from mail.astrocorp.com ([127.0.0.1])
	by localhost (mail.astrocorp.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u1+iprRNQPOP for <netfilter-devel@vger.kernel.org>;
	Wed, 15 Apr 2009 09:06:54 -0500 (CDT)
Received: from Win2003.astrocorp.com (unknown [192.168.1.146])
	by mail.astrocorp.com (Postfix) with ESMTP id 4841B630C1
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2009 09:06:54 -0500 (CDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 From |(git://xtables-addons.git.sf.net/gitroot/xtables-addons/).|

//snip - xtables git compile
  CC [M]  
/var/tmp/portage/net-firewall/xtables-addons-9999/work/xtables-addons-9999/extensions/xt_TEE.o
  CC [M]  
/var/tmp/portage/net-firewall/xtables-addons-9999/work/xtables-addons-9999/extensions/xt_condition.o
/var/tmp/portage/net-firewall/xtables-addons-9999/work/xtables-addons-9999/extensions/xt_condition.c: 
In function 'condition_mt_check':
/var/tmp/portage/net-firewall/xtables-addons-9999/work/xtables-addons-9999/extensions/xt_condition.c:164: 
error: 'struct proc_dir_entry' has no member named 'owner'
make[4]: *** 
[/var/tmp/portage/net-firewall/xtables-addons-9999/work/xtables-addons-9999/extensions/xt_condition.o] 
Error 1
//end snip

I looked in /usr/src/linux/include/linux/proc_fs.h - and struct module 
*owner is now longer in 2.6.30.

-Bryan
