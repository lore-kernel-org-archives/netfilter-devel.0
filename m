From: Filip Sneppe <filip.sneppe@cronos.be>
Subject: Re: How to create a .so file
Date: 23 Jun 2003 11:17:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056359879.712.6.camel@xbox>
References: <1907516dc8.16dc819075@teleline.es>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "ISLERO77@telefonica.net" <ISLERO77@telefonica.net>
In-Reply-To: <1907516dc8.16dc819075@teleline.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2003-06-23 at 02:59, ISLERO77@telefonica.net wrote:
> 
> 	Hi, 
>  
> 	When I try to use the mport module, I receive this message: 
>  
> iptables v1.2.5: Couldn't load match `mport':/usr/lib/iptables/libipt_mport.so: 
> cannot open shared object file: No such file or directory 
>  
> Try `iptables -h' or 'iptables --help' for more information. 
>  
> 	How can I create this .so file? 
>  
> 	Regards, 
>  
> 	Juan. 

Hi Juan,

You've patched your kernel with the mport match, but you didn't
recompile your iptables userspace application. Download the
source tarball and compile it with the KERNEL_DIR variable
pointing to the kernel source directory.

Also, watch out for /sbin/iptables & /usr/lib/iptables/...  vs.
/usr/local/sbin/iptables & /usr/local/lib/iptables/...
mismatches when installing the newer iptables version.

Regards,
Filip
