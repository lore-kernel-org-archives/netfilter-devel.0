From: Patrick McHardy <kaber@trash.net>
Subject: Re: kernel crash
Date: Tue, 29 Jan 2008 14:34:55 +0100
Message-ID: <479F2B7F.6040003@trash.net>
References: <479F0419.0057A9.30859@m12-15.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: fenglg <flg2932946@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55163 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019AbYA2Nuy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:50:54 -0500
In-Reply-To: <479F0419.0057A9.30859@m12-15.163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

fenglg wrote:
> netfilter-devel
> 
> I use linux-2.6.18, and there is a bridge with eth0 and eth1. The eth0 and eth1 connetcswitchs which use vlan trunk(802.1q). When i run system some hours, the kernel is crash, anyone can help me. 
>  
> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000010 
>  printing eip:              
> c030f15d        
> *pde = 00000000               
> Oops: 0000 [#1]               
> PREEMPT SMP           
> Modules linked in: ipt_recent_mac ip_nat_ftp ip_conntrack_ftp ip_nat_h323 ip_con                                                                                
> ntrack_h323 ip_nat_irc iptable_nat ip_nat ipt_ipp2p ipsec e1000 e100                                                                    
> CPU:    0         
> EIP:    008 #1)               
> EIP is at br_nf_pre_routing_finish+0x1d/0x340                                             


Could you try 2.6.24?
