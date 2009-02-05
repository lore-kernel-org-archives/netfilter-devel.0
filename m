From: Husnu Demir <hdemir@metu.edu.tr>
Subject: -m state is not working.
Date: Thu, 05 Feb 2009 16:46:20 +0200
Message-ID: <498AFBBC.20608@metu.edu.tr>
Reply-To: hdemir@metu.edu.tr
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090100010503000208050108"
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tenedos.general.services.metu.edu.tr ([144.122.144.162]:40034
	"EHLO tenedos.general.services.metu.edu.tr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbZBEOqW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:46:22 -0500
Received: from [144.122.3.228] (nebula.cc.metu.edu.tr [144.122.3.228])
	by tenedos.general.services.metu.edu.tr (8.13.8/8.13.8) with ESMTP id n15EkIIZ003241
	for <netfilter-devel@vger.kernel.org>; Thu, 5 Feb 2009 16:46:19 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090100010503000208050108
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 7bit

Hi,

I recently compiled new kernel and tried the following;

# iptables -I FORWARD -p tcp -m state --state NEW -j ACCEPT
iptables: Invalid argument


# uname -a
Linux ng-test 2.6.28.3 #4 SMP Thu Feb 5 08:37:37 EST 2009 x86_64 GNU/Linux

# lsmod
Module                  Size  Used by
xt_state                4608  0
nf_conntrack           64424  1 xt_state
iptable_filter          5440  0
ip_tables              19408  1 iptable_filter
x_tables               23432  2 xt_state,ip_tables
ipv6                  251328  22
sr_mod                 17540  0
e1000e                111728  0
..
..

# modinfo xt_state
filename:       /lib/modules/2.6.28.3/kernel/net/netfilter/xt_state.ko
license:        GPL
author:         Rusty Russell <rusty@rustcorp.com.au>
description:    ip[6]_tables connection tracking state match module
alias:          ipt_state
alias:          ip6t_state
vermagic:       2.6.28.3 SMP mod_unload modversions
depends:        x_tables,nf_conntrack

# iptables -V
iptables v1.4.2


Did I forget to add anything? How can I see what is happing?

thanks.

hdemir.


--------------090100010503000208050108
Content-Type: text/x-vcard; charset=utf-8;
 name="hdemir.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hdemir.vcf"

begin:vcard
fn:Husnu Demir
n:Demir;Husnu
email;internet:hdemir@metu.edu.tr
tel;work:+903122103330
tel;fax:+903122103303
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------090100010503000208050108--
