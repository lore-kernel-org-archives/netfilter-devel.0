From: "ISLERO77.CASA@telefonica.net" <ISLERO77.CASA@telefonica.net>
Subject: Re: [PATCH] Re: RV: Problems installing Netfilter extensions
Date: Fri, 20 Jun 2003 20:02:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <518db4f36e.4f36e518db@teleline.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: filip.sneppe@cronos.be
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

Hi Filip,  
	First, thanks for your help 
 
	I don't know if I'm looking another directory, but in my directory 
/userspace inside the patch-o-matic packet (I'm using 
patch-o-matic-20030107) there is no any INSTALL file, so, when I use 
"make" to build the binaries, I receive the next error message: 
 
	make: *** No targets specified and no makefile found.  Stop. 
 
	Thank you very much 
 
		Juan 
 
>       >                       # make all install 
>       >  
>       >    This last step doesn't work!! When I execute this 
> command in the 
>       > userspace/ subdirectory inside the patch-o-matic  
> directory, It 
> appears 
>       > an error saying that It can't find the "all" option (or 
> something 
>       > similar), I have proved to do "make all" and "make install", 
> but it 
>       > doesn't work anyway 
>       >  
>       >  
>       >         What I'm not doing properly?? 
>       >  
>       Hi Juan, 
>        
>       There appears to be an error in the Netfilter extensions HOWTO. 
>       As you can see from the INSTALL file in the userspace  
> directory,       there is no "make all", only a "make" to build the  
> binaries.        
>       I think the patch below updates the documentation to reflect 
>       this. Thanks for pointing this out. 
>        
>       Regards, 
>       Filip 
>  
