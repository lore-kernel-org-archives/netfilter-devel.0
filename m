From: hime@engineer.com
Subject: Re: [PATCH] fuzzy.patch and fuzzy6.patch.ipv6
Date: Fri, 02 May 2003 10:25:47 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030502152548.99567.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: cieciwa@alpha.zarz.agh.edu.pl, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: laforge@netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 Hi !


> >     I´m curious about what "unresolved symbols" are those and why, 
> >  by changing the VALUE of a symbolic constant,the problem vanishes...
> 
> Although I do all my development on PowerPC, I have to admit that I
> never tested the fuzzy patch.
> 
> I suppose the unreslved symbols are with regard to floating point
> functions that are not provided by the kernel.
> 

    That is a possibility .

> >  OK . The floating point instructions are eliminated by
> >  applying this patch .
> 
> exactly.  I am not even sure that it was valid to use floating point
> instructions at all.  IIRC, the kernel doesn't save the FPU registers,
> so if we interrupt an userspace process that uses FPU, we will corrupt
> it.  Not sure whether this is still true, and/or this is only valid
> within syscall context.
> 

    OK . Integer arithmetic is better , anyway .

> >  The only problem is relative to truncation errors...
> > I don´t have a PPC to do exaustive tests , but in the simulations that
> > I have made , no discrepancies were detected when computing the final
> > acceptance rates .
> 
> well, the algorithm is going to produce the same results on any
> architecture, independent of PPC or not.


 Yes , but the levels of granularity (in Fuzzy Logic terms) 
could change when doing the changes and the Fuzzy controller
could behave inadequately . 
 As I said before , the changes are (according to my tests) benign -
the controller performed well and , in practice , is the same as the 
original one .

> >  My opinion is that the primary reason for the change is very weird -
> >  "unresolved symbols" - and the solution is even more strange. 
> >  Anyway , I suggest additional investigation about this issue .
> 
> I can easily run a test here on my development machine, it's just the
> lack of time...

 Please , do that if you can , because it´s important to make sure 
that there will be no problems in the future - I would do if 
I could . If your results are good , the patch can be applied .


           Thank you very much .
      
                 Hime .

-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup
