From: "ISLERO77@telefonica.net" <ISLERO77@telefonica.net>
Subject: Re: Easy question, how to use stdio.h
Date: Tue, 22 Apr 2003 19:14:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <e86cce8bc8.e8bc8e86cc@teleline.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Evrim ULU <evrim@core.gen.tr>,netfilter-devel@lists.netfilter.org
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


Thanks!! 
 
Just another question, I have seen the libipt_multiport.so file (it's the match 
that I'm changing) but I haven't seen any libipt_multiport.c file where I could 
modify to use stdio.h. 
 
How can I modify the multiport match in the user space? 
 
Thanks again 
 
	Juan 
 
----- Mensaje Original ----- 
De: Evrim ULU <evrim@core.gen.tr> 
Fecha: Martes, Abril 22, 2003 8:18 pm 
Asunto: Re: Easy question, how to use stdio.h 
 
> -----BEGIN PGP SIGNED MESSAGE----- 
> Hash: SHA1 
>  
> ISLERO77@telefonica.net wrote: 
>  
> |Hello:   
> |   
> |Maybe my question is very easy, but I'm new developing in Linux.   
> |I'm trying to use fopen, fprintf and fclose in a match, so I'm  
> writting    
> |#include <stdio.h>   
> |but when I compile the kernel and I do    
> |make modules   
> |the system doesn't recognize any of these functions   
> |How can I use them???   
>  
> stdio.h includes glibc functions which are user space  
> implementations.  
> You cannot use them in kernel space. However, some are implemented  
> in  
> kernel space seperately like strncat, strncpy. See kernel headers  
> for  
> more detail. 
>  
> For more information about userspace/kernelspace, see kernelnewbies  
> mailing list. 
>  
> Evrim. 
>  
> | 
> -----BEGIN PGP SIGNATURE----- 
> Version: GnuPG v1.2.1 (GNU/Linux) 
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org 
>  
> iD8DBQE+pYd66+aEfy4lqIARAsOqR+I+Z9+ffKLcV0HhBQjoI= 
> =0m/J 
> -----END PGP SIGNATURE----- 
>  
>  
>  
