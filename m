From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: Concurrency issues with the iptables userspace program
	andexitcodes
Date: Thu, 1 Jun 2006 22:16:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0606012200260.27621@ask.diku.dk>
References: <1149153349.28481.15.camel@localhost.localdomain>
	<447F1227.7050900@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <447F1227.7050900@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Thu, 1 Jun 2006, Patrick McHardy wrote:

> Jesper Dangaard Brouer wrote:
>> I have experienced some concurrency issues with the iptables
>> userspace program.  Executing an iptables (write) command while
>> another (write command) is running causes a failure of the command.
>> Well, this is the expected semantics of a non-blocking call, but the
>> issue is how the error situation is reported back.
>>
>> The iptables command detects the situation and reports:
>>  "iptables: Resource temporarily unavailable"
>>
>> With shell exitcode "1".  What annoys me is that the shell exitcode
>> is "1", which is also used for "normal" errors.  This means that my
>> code/scripts needs to parse output from stderr to distinguish it from
>> normal/expected errors.
>>
>> I propose that the exitcode of "Resource temporarily unavailable"
>> error is changed to something unique for this situation.
>
>
> Wouldn't it make more sense to just make sure you don't have iptables
> commands running concurrently?

I already have implemented (f)locks in my code around the iptables 
invocations.  But the problem can still arise when root executes the 
iptables command from the shell. Thus, I still need to handle the 
situation in my code, and a proper exitcode would be nice.

In iptables-standalone.c it would be very easy to simply return the 
errno instead of !res (which always will return 0 or 1).  Would that be a 
feasable solution?

Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------

Someting like:

Index: iptables-standalone.c
===================================================================
--- iptables-standalone.c       (revision 6624)
+++ iptables-standalone.c       (working copy)
@@ -64,9 +64,11 @@
         if (ret)
                 ret = iptc_commit(&handle);

-       if (!ret)
+       if (!ret) {
                 fprintf(stderr, "iptables: %s\n",
                         iptc_strerror(errno));
+               exit(errno);
+       }

         exit(!ret);
  }
