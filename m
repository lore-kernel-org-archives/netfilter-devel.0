From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: using connlabel match
Date: Sat, 5 Mar 2016 13:37:20 +0100
Message-ID: <20160305123720.GA2691@salvia>
References: <CAKHNQQF6-3OgGbnF5=Wm46-=d0j80ExwiEVV7Rrm6czLT4YHGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48235 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbcCEMhZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2016 07:37:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7ABFA7400
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Mar 2016 13:37:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6986FDA8FA
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Mar 2016 13:37:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 045F3DA8FB
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Mar 2016 13:37:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQF6-3OgGbnF5=Wm46-=d0j80ExwiEVV7Rrm6czLT4YHGw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Shivani,

On Fri, Mar 04, 2016 at 04:05:24AM +0530, Shivani Bhardwaj wrote:
> Hi Pablo,
> 
> connlabel match never loads. It shows
> iptables v1.6.0: Couldn't load match `connlabel':No such file or directory
> 
> I see this conversation here:
> https://patchwork.ozlabs.org/patch/386215/ and the patch which causes
> this http://git.netfilter.org/iptables/commit/?id=51340f7b6a1103b12d86ef488f7140406d80401e.
> However, Florian sent a patch to deal with this
> http://git.netfilter.org/iptables/commit/?id=825fbda5482a7d5ec5a6619c81fe07ff865c7d6e.
> May be I'm doing it all wrong. I'm not sure how connlabel should be
> used. Could you please clarify?

Please, check that you have libnetfilter_conntrack and by when you
call iptables ./configure it doesn't show that connlabel is enabled.

        WARNING: libnetfilter_conntrack not found, connlabel match will not be built

It would be good to fix this in configure.ac in iptables so the
iptables configuration shows that connlabel support is on/off.

Iptables Configuration:                                                          
  IPv4 support:                         ${enable_ipv4}                           
  IPv6 support:                         ${enable_ipv6}                           
  Devel support:                        ${enable_devel}                          
  IPQ support:                          ${enable_libipq}                         
  Large file support:                   ${enable_largefile}                      
  BPF utils support:                    ${enable_bpfc}                           
  nfsynproxy util support:              ${enable_nfsynproxy}                     
  nftables support:                     ${enable_nftables}                       
                                                                                 
Build parameters:                                                                
  Put plugins into executable (static): ${enable_static}                         
  Support plugins via dlopen (shared):  ${enable_shared}                         
  Installation prefix (--prefix):       ${prefix}                                
  Xtables extension directory:          ${e_xtlibdir}                            
  Pkg-config directory:                 ${e_pkgconfigdir}"  

Would you mind sending a patch for configure.ac in iptables?
