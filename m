From: Matthias Dettling <m-dettling@gmx.de>
Subject: Re: Reviewing a piece of code, locking questions
Date: Mon, 31 May 2004 01:33:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40BA6F4E.1050706@gmx.de>
References: <Pine.LNX.4.44.0405290048400.2189-101000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0405290048400.2189-101000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:

>On Fri, 28 May 2004, Matthias Dettling wrote:
>
>  
>
>>Can someone look at the code to see if there are any mistakes? 
>>Especially the parts with locking should be reviewed because I am really 
>>unsure if I have locked properly. Do I need a "WRITE_LOCK" or only a 
>>"READ_LOCK", is "&ip_conntrack_lock" right or need I 
>>"&ip_conntrack_expect_tuple" or even some other locking?
>>    
>>
>
>No obvious errors from what I could tell.
>
>You need a READ_LOCK.
>
>WRITE_LOCK is only needed if you are to modify the ip_conntrack table, 
>which you are obviously not doing.
>
>  
>
>>An other question I have is if it is legal to modifiy the structure 
>>"ipt_conntrack_info" in "ipt_conntrack.h" or could this cause problems 
>>or errors?
>>    
>>
>
>It is legal, but will invalidate binary compatibility with existing 
>iptables binaries having another libipt_conntrack compiled..
>
>  
>
>>I have added 2 arrays with the ports of the related connection for the 
>>matching as also extended the flag fields (see above).
>>    
>>
>
>To simplify the kernel code you could store the ports in network byte 
>order in the match structure.. this way you do not need to translate the 
>port fields while matching in the kernel.
>
>  
>
>>If all should be OK, how can I publish the modification, that it could 
>>be part of later versions of iptables and the kernel, because I think it 
>>could be interesting for others too?
>>    
>>
>
>As a tarball with the files to go into patch-o-matic-ng. This includes 
>both the patching to the kernel and userspace.
>
>  conntrack_port/	(or whatever you want to name your patch)
>	linux.patch	kernel changes
>	iptables.patch	userspace changes
>	info		meta info describing your patch
>	help		short blurb documenting your patch
>
>While you are at it you may want to also merge the other conntrack matches 
>I posted a long time ago.. [attached as a conntrack2 match]
>
>Regards
>Henrik
>  
>
Hello Henrik,

many thanks for your help.
This is what I meant, when saying "a patched version" of ipt_conntrack.c.
I found your patch on the net and applied it. So my work was only 
extending ipt_conntrack.c for matching tracked informations.
This means that my work depends on your patch because I use the same 
functions as your code does. I looked in the current CVS version of 
patch-o-matic about your patch as also in the file 
patch-o-matic-ng-20040302.tar.bz2 but didn't find it.
Because my work needs your patch am I allowed to add your patch to my 
patch (of course I would mention your name)?

You gave me the hint for simplifying kernel code storing the port 
numbers in network byte order. If I'm right I think that you don't do so 
in your patch. Because my work depends strongly on your it would be 
awkward to do so. But if it is really better for performance I could 
change the whole code in this way.

If I have created a patch as tarball where should I send this that it 
will be included in future releases of patch-o-matic?

Best regards
Matthias
