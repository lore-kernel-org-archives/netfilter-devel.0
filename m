From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Sat, 22 May 2004 09:04:02 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AF4FC2.1060808@videotron.ca>
References: <Pine.LNX.4.44.0405220040040.28306-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
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

>On Fri, 21 May 2004, Patrick McHardy wrote:
>
>  
>
>>I missed that question. It's probably not neccessary, we will get a
>>small race when zapping conntracks, but according to this comment in
>>unreplied() we already have one anyway.
>>    
>>
>
>What I thought.. a __set_bit should be sufficient here, right?
>
>Is there any good description somewhere on how these memory barriers 
>works and when they are needed, or more precisely what is the difference 
>between set_bit and __set_bit in terms of when/how/why each should be 
>used?
>  
>

Henrick,

    some CPUs can reorder memory accesses in order to optimize bus 
usage.  Compilers can reorder instructions to optimize cache and 
register usage. Memory barriers are used to avoid races when the order 
of execution is important.

    For example, suppose you create a proc file with create_proc_entry() :

myprocfile = create_proc_entry( . . . );
myprocfile->fops = my_driver_proc_fops;
myprocfile->data = &my_data_structure;
.
.
.


    Many people don't check that "data" is not NULL in the file 
operation procedures and that's OK as long as you can make sure that the 
"data" pointer is set BEFORE you set the "fops" pointer...  So, here's 
our example reworked :

myprocfile = create_proc_entry( . . . );
myprocfile->data = &my_data_structure;
myprocfile->fops = my_driver_proc_fops;
.
.
.


    This is much better but still imperfect.  GCC could reorder the 
instructions to better use the cache and/or processor registers.  We 
need to introduce a write memory barrier to GARANTEE that the "data" 
pointer is set BEFORE the "fops" pointer :

myprocfile = create_proc_entry( . . . );
myprocfile->data = &my_data_structure;
wmb();
myprocfile->fops = my_driver_proc_fops;
.
.
.

   In this case, a write memory barriers forbids write accesses to cross 
the barrier in either direction.  That's our garantee that "data" is 
ALWAYS valid inside the file operation procedures...

Regards,

Stephane Ouellette

>But in this case there is many races.. a test_bit followed  by a set_bit 
>is not atomic unles governed by a surrounding lock independent of if 
>there is memory barriers of not around the operations, and the flushing of 
>unconfirmed sessions is inherently racy anyway without strict locking. If 
>there is strict locking then memory barriers in the set_bit should be 
>completely irrelevant. Right?
>
>Regards
>Henrik
>

   

>  
>
