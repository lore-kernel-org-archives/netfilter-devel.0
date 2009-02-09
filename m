From: Patrick McHardy <kaber@trash.net>
Subject: Re: -m state is not working.
Date: Mon, 09 Feb 2009 18:10:34 +0100
Message-ID: <4990638A.1090208@trash.net>
References: <498AFBBC.20608@metu.edu.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: hdemir@metu.edu.tr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59635 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZBIRKh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:10:37 -0500
In-Reply-To: <498AFBBC.20608@metu.edu.tr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Husnu Demir wrote:
> Hi,
> 
> I recently compiled new kernel and tried the following;
> 
> # iptables -I FORWARD -p tcp -m state --state NEW -j ACCEPT
> iptables: Invalid argument
> 
> 
> # uname -a
> Linux ng-test 2.6.28.3 #4 SMP Thu Feb 5 08:37:37 EST 2009 x86_64 GNU/Linux
> 
> # lsmod
> Module                  Size  Used by
> xt_state                4608  0
> nf_conntrack           64424  1 xt_state
> iptable_filter          5440  0
> ip_tables              19408  1 iptable_filter
> x_tables               23432  2 xt_state,ip_tables
> ipv6                  251328  22
> sr_mod                 17540  0
> e1000e                111728  0
> ..
> ..
> 
> # modinfo xt_state
> filename:       /lib/modules/2.6.28.3/kernel/net/netfilter/xt_state.ko
> license:        GPL
> author:         Rusty Russell <rusty@rustcorp.com.au>
> description:    ip[6]_tables connection tracking state match module
> alias:          ipt_state
> alias:          ip6t_state
> vermagic:       2.6.28.3 SMP mod_unload modversions
> depends:        x_tables,nf_conntrack
> 
> # iptables -V
> iptables v1.4.2
> 
> 
> Did I forget to add anything? How can I see what is happing?

I'm guessing you forgot nf_conntrack_ipv4.


