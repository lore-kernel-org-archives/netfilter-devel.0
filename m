From: Filip Sneppe <filip.sneppe@cronos.be>
Subject: Re: [PATCH] Re: RV: Problems installing Netfilter extensions
Date: 23 Jun 2003 11:14:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056359685.711.0.camel@xbox>
References: <518db4f36e.4f36e518db@teleline.es>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "ISLERO77.CASA@telefonica.net" <ISLERO77.CASA@telefonica.net>
In-Reply-To: <518db4f36e.4f36e518db@teleline.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2003-06-20 at 20:02, ISLERO77.CASA@telefonica.net wrote: 
> Hi Filip,  
> 	First, thanks for your help 
>  
> 	I don't know if I'm looking another directory, but in my directory 
> /userspace inside the patch-o-matic packet (I'm using 
> patch-o-matic-20030107) there is no any INSTALL file, so, when I use 
> "make" to build the binaries, I receive the next error message: 
>  
> 	make: *** No targets specified and no makefile found.  Stop. 
>  
> 	Thank you very much 
>  
> 		Juan 
>  
Hi Juan, 

Ok, I've just downloaded this pom tarball myself. 
The thing is: if you want to extend the netfilter/iptables 
functionality with new matches and/or new targets, you 
need to patch and recompile both your kernel and 
iptables userspace application. 

AFAIK, the patch-o-matic tarbal you downloaded can only 
be used to patch the kernel, but not the iptables 
userspace application. 

The iptables userspace command is compiled with a simple 

make && make install 

when the KERNEL_DIR variable is set correctly, and the 
kernel is compiled and installed the standard way. 

So, when you want to compile a new iptables program, you 
will need to download the iptables tarball and go from 
there. 

While you're at it, please realize that the patch-o-matic 
tarball you refer to is quite old - if you are using 
a recent kernel (i.e. 2.4.20+), you'll probably be 
better off downloading everything from CVS. 

Regards, 
Filip
