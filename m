From: Matthias Dettling <m-dettling@gmx.de>
Subject: conntrack matching
Date: Tue, 08 Jun 2004 19:31:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40C5F7D4.201@gmx.de>
References: <Pine.LNX.4.44.0405311028450.4215-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0405311028450.4215-100000@filer.marasystems.com>
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

>On Mon, 31 May 2004, Matthias Dettling wrote:
>
>  
>
>>many thanks for your help.
>>This is what I meant, when saying "a patched version" of ipt_conntrack.c.
>>I found your patch on the net and applied it. So my work was only 
>>extending ipt_conntrack.c for matching tracked informations.
>>    
>>
>
>Is this the old patch where I add port matches to ipt_conntrack?
>
>  
>
>>This means that my work depends on your patch because I use the same 
>>functions as your code does. I looked in the current CVS version of 
>>patch-o-matic about your patch as also in the file 
>>patch-o-matic-ng-20040302.tar.bz2 but didn't find it.
>>    
>>
>
>I never got any response from the ipt_conntrack author on these changes.
>
>  
>
>>Because my work needs your patch am I allowed to add your patch to my 
>>patch (of course I would mention your name)?
>>    
>>
>
>Yes.
>
>  
>
>>You gave me the hint for simplifying kernel code storing the port 
>>numbers in network byte order. If I'm right I think that you don't do so 
>>in your patch. Because my work depends strongly on your it would be 
>>awkward to do so. But if it is really better for performance I could 
>>change the whole code in this way.
>>    
>>
>
>If I don't do so then please change my patch by moving the ntohs calls to 
>libipt_conntrack.
>
>  
>
>>If I have created a patch as tarball where should I send this that it 
>>will be included in future releases of patch-o-matic?
>>    
>>
>
>Here to the mailinglist.
>
>Regards
>Henrik
>
>
>  
>
Hello Henrik,

last week I hadn't much time for answering your mail.
But meantime I thought a while about your recommendation to match 
numbers in network byte order.
I think this proposal would be appropriate, if I only would match a 
single port.
But like your patch I also want to match port ranges. And that's the 
problem.
A single compare of two values is independent of the byte order of the 
machine.
It can result either in true or in false (all the same compared by left 
or by right).
A check if a given value is between a range of values needs arithmetic 
operations (>=, <=) which are in my opinion
dependant of the machine's architecture (big-endian or little-endian).
So I think this is the reason why you are also matching in host byte 
order in your patch.
An other solution were ugly #ifdef constructions (to determine wether 
big-endian or little-endian) and then using the
arithmetic operations dependant of the machine's architecture, but I 
think this is bad style.
So I think the way of translating the port numbers from network byte 
order to host byte order in the kernel for matching them
is the best compromise of performance and clean code.
In my opinion your idea to move ntohs calls to libipt_conntrack doesn't 
make sense, because the user input is already in
host byte order. The only possibility would be to use htons in 
libipt_conntrack an then matching in network byte order, but then the 
problems described above occur.
Am I right in this assumptions, what do you think?

Regards
Matthias
