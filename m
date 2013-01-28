From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/8] build: also use libtool for install stage
Date: Mon, 28 Jan 2013 12:33:51 +0100
Message-ID: <20130128113351.GA15781@1984>
References: <1359056278-27618-1-git-send-email-jengelh@inai.de>
 <1359056278-27618-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40120 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757266Ab3A1Ld6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:33:58 -0500
Content-Disposition: inline
In-Reply-To: <1359056278-27618-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 24, 2013 at 08:37:51PM +0100, Jan Engelhardt wrote:
> The just-built library has DT_RPATH entries to be runnable from
> whereever it is. If we just install that, the distro build systems
> will throw warnings like
> 
> 	(Open Build Service) ERROR: RPATH
> 	"/home/abuild/rpmbuild/BUILD/iptables-1.4.17a/libxtables/.libs"
> 	on /home/abuild/rpmbuild/BUILDROOT/iptables-1.4.17a-0.x86_64/usr/lib64/xtables/libxt_unclean.so
> 	is not allowed
> 
> These RPATH entries are indeed undesired for libraries is in a system
> location, which is why libtool produces another copy of the library on
> installation. The makefile however missed using libtool during
> installation (introduced with commit v1.4.17-1-g68e77a2).
> This patch now resolves this.

I hit this with this patch:

make[1]: ...
libtool: install: warning: relinking `libxt_AUDIT.la'                            
libtool: install: warning: relinking `libxt_CHECKSUM.la'                         
libtool: install: warning: relinking `libxt_CLASSIFY.la'                         
libtool: install: warning: relinking `libxt_CONNMARK.la'                         
libtool: install: warning: relinking `libxt_CONNSECMARK.la'                      
libtool: install: warning: relinking `libxt_CT.la'                               
libtool: install: warning: relinking `libxt_DSCP.la'                             
libtool: install: warning: relinking `libxt_HMARK.la'                            
libtool: install: warning: relinking `libxt_IDLETIMER.la'                        
libtool: install: warning: relinking `libxt_LED.la'   
...
