From: "Hime Junior" <hime@engineer.com>
Subject: Re: fuzzy match pseudo-bug
Date: Mon, 09 Sep 2002 09:13:57 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020909141357.57407.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: laforge@gnumonks.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


----- Original Message -----
From: Harald Welte <laforge@gnumonks.org>
Date: Sat, 7 Sep 2002 17:29:09 +0200 
To: "Hime Junior" <hime@engineer.com>
Subject: Re: fuzzy match pseudo-bug

 Dear Harald:

> > 
> >  I don´t think it´s worth to apply a patch to eliminate a space character in
> >  the source code .  After all , the compiler has to cope with this (that is
> >  not a bug in the code) and if it doesn´t , somebody has to correct its
> >  scanner (lexical analyser) .
> 
> You are misunderstanding the problem...
> the '\' _has_ to be at the end of a line, since it is an escape-character
> for the following newline at the end of the line.  If you add a space between
> the \ and the end of line, you are escaping this space character and not 
> the end of line character (\n).
> 

 OK - you are right and I understand that . But my point is not about
how the things are , but how they should be . I don´t wish to bore all of you with unimportant details , but what I suggested was a 
different (and smarter - I think) compiler behavior that , 
after all , just emitted a (undesirable) warning .
 As a compiler writer , I couldn´t resist - I´m sorry...

> >  But , if you think it´s worth to eliminate the space character , it´ll be a
> >  pleasure to send a new file ( ipt_fuzzy.c ) .
> 
> I have modified the ipt_fuzzy.c file by myself.  
> 
    I couldn´t expect better !

    Thanks a lot and congratulations for the excellent job.


                     Hime

-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup
