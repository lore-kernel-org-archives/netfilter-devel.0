From: "ISLERO77.CASA@telefonica.net" <ISLERO77.CASA@telefonica.net>
Subject: Problems installing Netfilter extensions
Date: Fri, 20 Jun 2003 02:38:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <25538242f8.242f825538@teleline.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Language: es
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  
        Hi!!  
  
        I'm trying to install a Netfilter extension, mport, but it doesn't work  
  
        I make all the steps that comes on the Netfilter Extensions HOWTO,  
but, when I try to use the new match, it appears an error saying that it  
doesn't exists the libipt_mport.so file, I have observed that there are the  
ipt_mport.c and ipt_mport.h files, but no this other file.  
  
        I think that the problem is because I can't make the last step explained  
in the documentation, where is written:  
  
                Once your new kernel is installed, you can go ahead and  
compile and install the "iptables" package, from the "userspace/" directory  
as follows:  
  
                        # make all install  
  
        This last step doesn't work!! When I execute this command in the  
userspace/ subdirectory inside the patch-o-matic directory, It appears an  
error saying that It can't find the "all" option (or something similar)  
  
  
        What I'm not doing properly??  
  
  
        Than you very much  
  
