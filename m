From: "Julio A. Romero" <julioarr@fisica.uh.cu>
Subject: CONFIG_NF_CT_ACCT is deprecated
Date: Tue, 26 Jul 2011 13:55:02 -0400
Message-ID: <A8D937F560604292AD4B589CCF3D72BF@poweredge1800>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: <netfilter@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Messages produced during the boot sequence of my debian system
(squeeze, linux-image-2.6.32-5-amd64      2.6.32-35)
syslog:


Jul 26 11:47:16 firewall kernel: [   11.465366] ip6_tables: (C) 2000-2006 
Netfilter Core Team
Jul 26 11:47:16 firewall kernel: [   11.563280] ip_tables: (C) 2000-2006 
Netfilter Core Team
Jul 26 11:47:16 firewall kernel: [   11.621776] nf_conntrack version 0.5.0 
(3846 buckets, 15384 max)
Jul 26 11:47:16 firewall kernel: [   11.622349] CONFIG_NF_CT_ACCT is 
deprecated and will be removed soon. Please use
Jul 26 11:47:16 firewall kernel: [   11.622354] nf_conntrack.acct=1 kernel 
parameter, acct=1 nf_conntrack module option or
Jul 26 11:47:16 firewall kernel: [   11.622357] sysctl 
net.netfilter.nf_conntrack_acct=1 to enable it.


What's that? and What should I do at respect? 

