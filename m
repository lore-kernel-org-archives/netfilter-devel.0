From: "linkai" <lk_apple@263.net>
Subject: Re: netfilter-devel digest, Vol 1 #1166 - 6 msgs
Date: Sat, 17 Jul 2004 22:18:01 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000a01c46c08$ec05fc90$0600000a@fengtao>
References: <20040704042714.9737.88148.Mailman@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Why not connction track dose not track tcp protocol session wiht seq number?

If it dose not track the tcp seq number, so Hacker maybe spoofing the
session.


----- Original Message ----- 
From: <netfilter-devel-request@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Sent: Sunday, July 04, 2004 12:27 PM
Subject: netfilter-devel digest, Vol 1 #1166 - 6 msgs


> Send netfilter-devel mailing list submissions to
> netfilter-devel@lists.netfilter.org
>
> To subscribe or unsubscribe via the World Wide Web, visit
> https://lists.netfilter.org/mailman/listinfo/netfilter-devel
> or, via email, send a message with subject or body 'help' to
> netfilter-devel-request@lists.netfilter.org
>
> You can reach the person managing the list at
> netfilter-devel-admin@lists.netfilter.org
>
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of netfilter-devel digest..."
>
>
> Today's Topics:
>
>    1. RE: information (Muhammad R. Sami)
>    2. RE: information (Henrik Nordstrom)
>    3. RE: information (Muhammad R. Sami)
>    4. RE: information (Henrik Nordstrom)
>    5. RE: information (Muhammad R. Sami)
>    6. RE: information (Muhammad R. Sami)
>
> --__--__--
>
> Message: 1
> From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
> To: "'Henrik Nordstrom'" <hno@marasystems.com>
> Cc: "'Babar Qaisrani'" <baqb03@student.bth.se>,
>    "'Netfilter List'" <netfilter-devel@lists.netfilter.org>
> Subject: RE: information
> Date: Sat, 3 Jul 2004 11:18:45 +0300
> X-Virus: 1
>
> Yes, I mean to say the verdict. Now I am a bit confused. Is not the
verdict
> enough to tell the kernel what to do with the packets? If yes, then it
does
> not work with me more than once.
>
> Muhammad R. Sami
> Research Assistant,
> Computer Engineering Department
> P.O.Box 354
> King Fahd University of Petroleum & Minerals
> Dhahran 31261
> Saudi Arabia.
> Tel: +96638601423
> Cell: +96657982951
> www.ccse.kfupm.edu.sa/sami
>
> -----Original Message-----
> From: netfilter-devel-admin@lists.netfilter.org
> [mailto:netfilter-devel-admin@lists.netfilter.org] On Behalf Of Henrik
> Nordstrom
> Sent: Saturday, July 03, 2004 4:08 AM
> To: Muhammad R. Sami
> Cc: 'Babar Qaisrani'; Netfilter List
> Subject: RE: information
>
> On Fri, 2 Jul 2004, Muhammad R. Sami wrote:
>
> > I got the libipq/QUEUE part working but the problem is that it only
works
> > for the first time. For example, if I want to drop all icmp packets, it
> > will, but if I change the nfmark from drop to accept and then recompile
my
> > libipq program, it does not work and the dropping policy is maintained.
> Same
> > for the other way around.
>
> Please explain what you refer to by "change the nfmark from drop to
> accept".
>
>
> nfmark does not have a concept of drop/accept, just value.
>
>
>
> Is you perhaps speaking about the verdict set by the userspace telling if
> the packet should be accepted (passed on to next hook) or dropped? This is
> just a verdict and not related to nfmark.
>
> Regards
> Henrik
>
>
>
>
>
>
> --__--__--
>
> Message: 2
> Date: Sat, 3 Jul 2004 10:56:34 +0200 (CEST)
> X-Virus: 1
> From: Henrik Nordstrom <hno@marasystems.com>
> To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
> cc: "'Babar Qaisrani'" <baqb03@student.bth.se>,
>    "'Netfilter List'" <netfilter-devel@lists.netfilter.org>
> Subject: RE: information
>
> On Sat, 3 Jul 2004, Muhammad R. Sami wrote:
>
> > Yes, I mean to say the verdict. Now I am a bit confused. Is not the
verdict
> > enough to tell the kernel what to do with the packets? If yes, then it
does
> > not work with me more than once.
>
> The verdict tells what to do with the packet in this hook
> (PREROUTING/FORWARD/POSTROUTING etc). Only if the verdirct is NF_ACCEPT is
> the packet accepted by this hook.
>
> Why it only works "once" for you I do not know. Maybe if you describe in
> full details what you mean by "once" we can find some hint to what is
> going wrong.
>
> It is only that your talk about nfmark made me a little confused. nfmark
> is not related to the verdict. See the MARK target and/or linux advaced
> routing howto for more info on nfmark in case you want to learn more what
> the nfmark is and how it may be used. But it is not related to your
> problem.
>
> Regards
> Henrik
>
>
>
> --__--__--
>
> Message: 3
> From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
> To: "'Henrik Nordstrom'" <hno@marasystems.com>
> Cc: "'Babar Qaisrani'" <baqb03@student.bth.se>,
>    "'Netfilter List'" <netfilter-devel@lists.netfilter.org>
> Subject: RE: information
> Date: Sat, 3 Jul 2004 12:10:18 +0300
> X-Virus: 1
>
> Thanks for your help, I simply want to QUEUE packets to the libipq
> application and then through verdict accept or drop them. Sorry for
creating
> the confusion by using "nfmark" in my emails. Right now my work does not
> require nfmark at all.
> Now what I mean by "once" is that whenever I queue a specific flow of
packet
> to the libipq program and for example set the verdict to DROP, it works
> fine. But if I change the verdict to ACCEPT and recompile my program, the
> box still drops the packets. On the other hand if I ACCEPT the packets
> first, they will always be accepted even after changing the verdict to
DROP.
> In short, whatever verdict I set the first time seems to be there always
> despite the fact that I change the verdict and recompile the program.
> Regards,
>
> Muhammad R. Sami
> Research Assistant,
> Computer Engineering Department
> P.O.Box 354
> King Fahd University of Petroleum & Minerals
> Dhahran 31261
> Saudi Arabia.
> Tel: +96638601423
> Cell: +96657982951
> www.ccse.kfupm.edu.sa/sami
>
> -----Original Message-----
> From: Henrik Nordstrom [mailto:hno@marasystems.com]
> Sent: Saturday, July 03, 2004 11:57 AM
> To: Muhammad R. Sami
> Cc: 'Babar Qaisrani'; 'Netfilter List'
> Subject: RE: information
>
> On Sat, 3 Jul 2004, Muhammad R. Sami wrote:
>
> > Yes, I mean to say the verdict. Now I am a bit confused. Is not the
> verdict
> > enough to tell the kernel what to do with the packets? If yes, then it
> does
> > not work with me more than once.
>
> The verdict tells what to do with the packet in this hook
> (PREROUTING/FORWARD/POSTROUTING etc). Only if the verdirct is NF_ACCEPT is
> the packet accepted by this hook.
>
> Why it only works "once" for you I do not know. Maybe if you describe in
> full details what you mean by "once" we can find some hint to what is
> going wrong.
>
> It is only that your talk about nfmark made me a little confused. nfmark
> is not related to the verdict. See the MARK target and/or linux advaced
> routing howto for more info on nfmark in case you want to learn more what
> the nfmark is and how it may be used. But it is not related to your
> problem.
>
> Regards
> Henrik
>
>
>
>
>
> --__--__--
>
> Message: 4
> Date: Sat, 3 Jul 2004 14:16:48 +0200 (CEST)
> X-Virus: 1
> From: Henrik Nordstrom <hno@marasystems.com>
> To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
> cc: "'Babar Qaisrani'" <baqb03@student.bth.se>,
>    "'Netfilter List'" <netfilter-devel@lists.netfilter.org>
> Subject: RE: information
>
> On Sat, 3 Jul 2004, Muhammad R. Sami wrote:
>
> > Now what I mean by "once" is that whenever I queue a specific flow of
> > packet to the libipq program and for example set the verdict to DROP, it
> > works fine. But if I change the verdict to ACCEPT and recompile my
> > program, the box still drops the packets.
>
> Have you restarted your application?
>
> Are you positively sure you restarted the recompiled binary?
>
> From where are you invoking the QUEUE target?
>
> What does your ruleset (in iptables) look like?
>
> Regards
> Henrik
>
>
>
> --__--__--
>
> Message: 5
> From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
> To: "Netfilter List" <netfilter-devel@lists.netfilter.org>
> Subject: RE: information
> Date: Sat, 3 Jul 2004 17:33:25 +0300
> X-Virus: 1
>
>
> What do you exactly mean by "restarting". I just recompile my .c file that
> generates a .out file and that's it. Do I have to make an exe or binary
from
> it or what?
> I invoke the QUEUE target from the iptables commands and it looks
something
> like this
>
> iptables -A OUTPUT -p icmp -j QUEUE
>
> Muhammad R. Sami
> Research Assistant,
> Computer Engineering Department
> P.O.Box 354
> King Fahd University of Petroleum & Minerals
> Dhahran 31261
> Saudi Arabia.
> Tel: +96638601423
> Cell: +96657982951
> www.ccse.kfupm.edu.sa/sami
>
> -----Original Message-----
> From: Henrik Nordstrom [mailto:hno@marasystems.com]
> Sent: Saturday, July 03, 2004 3:17 PM
> To: Muhammad R. Sami
> Cc: 'Babar Qaisrani'; 'Netfilter List'
> Subject: RE: information
>
> On Sat, 3 Jul 2004, Muhammad R. Sami wrote:
>
> > Now what I mean by "once" is that whenever I queue a specific flow of
> > packet to the libipq program and for example set the verdict to DROP, it
> > works fine. But if I change the verdict to ACCEPT and recompile my
> > program, the box still drops the packets.
>
> Have you restarted your application?
>
> Are you positively sure you restarted the recompiled binary?
>
> From where are you invoking the QUEUE target?
>
> What does your ruleset (in iptables) look like?
>
> Regards
> Henrik
>
>
>
>
>
> --__--__--
>
> Message: 6
> From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
> To: "'Henrik Nordstrom'" <hno@marasystems.com>
> Cc: "Netfilter List" <netfilter-devel@lists.netfilter.org>
> Subject: RE: information
> Date: Sat, 3 Jul 2004 20:26:55 +0300
> X-Virus: 1
>
> What do you exactly mean by "stopping" because I don't even start
anything,
> I just compile the code and that is it, and that is what I do every time I
> change the code (set_verdict). As far as the iptables rule, I was simply
> testing the rule in the manpage example but for my work I have to queue
> packets at the INPUT.
> Another interesting thing I just faced was that although the
> iptables_filter.o and ip_queue.o files are present in my Netfilter
directory
> (as they were compiled with the kernel), whenever I run the command
modprobe
> iptables_filter and modprobe ip_queue, it says FATAL: module not found.
When
> I run the insmod module name it say "invalid module format". Really
lost!!!
> Regards,
>
> Muhammad R. Sami
> Research Assistant,
> Computer Engineering Department
> P.O.Box 354
> King Fahd University of Petroleum & Minerals
> Dhahran 31261
> Saudi Arabia.
> Tel: +96638601423
> Cell: +96657982951
> www.ccse.kfupm.edu.sa/sami
>
> -----Original Message-----
> From: Henrik Nordstrom [mailto:hno@marasystems.com]
> Sent: Saturday, July 03, 2004 5:46 PM
> To: Muhammad R. Sami
> Subject: RE: information
>
> On Sat, 3 Jul 2004, Muhammad R. Sami wrote:
>
> > What do you exactly mean by "restarting". I just recompile my .c file
that
> > generates a .out file and that's it. Do I have to make an exe or binary
> from
> > it or what?
>
> No, but you have to stop the old binary and start the new one...
>
> > I invoke the QUEUE target from the iptables commands and it looks
> something
> > like this
> >
> > iptables -A OUTPUT -p icmp -j QUEUE
>
> Any other OUTPUT rules before this?
>
> Regards
> Henrik
>
>
>
>
>
>
> --__--__--
>
> _______________________________________________
> netfilter-devel mailing list
> netfilter-devel@lists.netfilter.org
> https://lists.netfilter.org/mailman/listinfo/netfilter-devel
>
>
> End of netfilter-devel Digest
>
