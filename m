From: Jim Gifford <maillist@jg555.com>
Subject: Re: Use of Kernel Headers
Date: Fri, 20 Aug 2004 23:47:52 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4126F018.207@jg555.com>
References: <4122743A.7020309@jg555.com> <Pine.LNX.4.61.0408180123380.7879@filer.marasystems.com> <Pine.LNX.4.58.0408182356030.5432@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
  Netfilter Developer <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0408182356030.5432@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:

>On Wed, 18 Aug 2004, Henrik Nordstrom wrote:
>
>  
>
>>On Tue, 17 Aug 2004, Jim Gifford wrote:
>>
>>    
>>
>>>It has been stated numerous times that userspace programs should not be
>>>compiled against raw kernel headers, but iptables does compile against
>>>userspace headers and breaks this rule. With the advent of the
>>>linux-libc-headers package, should iptables be compiled against the
>>>linux-libc-headers or the raw kernel headers since iptables is a user space
>>>program?
>>>      
>>>
>>This depends on if you build iptables for your custom patched kernel or a
>>standard kernel.
>>
>>For a standard kernel it should be sufficient with linux-libc-headers I
>>think, but it is possible some required linux iptables headers is missing
>>from the iptables package (include/linux/netfilter_ipv[46]/). If
>>you find some missing please report here which files needs to be added
>>from the kernel tree and maybe it can be cleaned up.
>>    
>>
>
>The include/linux tree in the iptables source exists for
>forward-compatibility reasons only. The to-be-submitted new extensions are
>added to the iptables tree, together with their header files and enabled
>for default compilation in the Makefile. Thus when one donwloads/installs
>the next kernel release, there is no need to touch the iptables binary
>because it knows about the new extensions. The definite source of the
>include files is the kernel tree for iptables, which overrides the
>include directory in the userspace source.
>
>  
>
>>>Should patch-o-matic update the headers in the proper location,
>>>/usr/include/linux/netfilter_ipv4 etc?
>>>      
>>>
>>patch-o-matic should always update the kernel source tree and your
>>iptables should then be built to this source tree. This to make sure
>>the view of iptables and your kernel matches. But to be honest it should
>>only be the include/linux/netfilter_ipv[46]/ directories which is required
>>by iptables.
>>    
>>
>
>pom should definitely not update /usr/include/linux because the kernel
>version there can be (usually are) different than in the patched kernel
>source. Also, /usr/include/linux is maintained by the given distribution.
>Next update could simply overwrite patched files, checksumming would fail
>in built-in IDS, etc.
>
>My impression is that netfilter/iptables/pom does not really fit into
>the linux-libc-headers schema. And iptables should compile cleanly on any
>distro, including the ones which do not contain linux-libc-headers.
>
>Best regards,
>Jozsef
>-
>E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
>PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
>Address : KFKI Research Institute for Particle and Nuclear Physics
>          H-1525 Budapest 114, POB. 49, Hungary
>
>  
>
Jozsef,
    I understand you point, and have thought about it quite a bit before 
I replied. Most of the distro's who are distributing 2.6 are using the 
linux-libc-headers or making there own. Currently Linus has stated on 
numerous times that userspace programs should not use the kernel source 
headers.

This all goes back to having true separation between the kernel and 
userspace, I'm starting to think iptables is different in it's situation 
and true separation will never be possible


-- 
----
Jim Gifford
maillist@jg555.com
