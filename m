From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: RE: information
Date: Sat, 3 Jul 2004 12:10:18 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407030911.i639B1MX025399@madinah.ccse.kfupm.edu.sa>
References: <Pine.LNX.4.44.0407031050250.29271-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Babar Qaisrani'" <baqb03@student.bth.se>,
   "'Netfilter List'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Henrik Nordstrom'" <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0407031050250.29271-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thanks for your help, I simply want to QUEUE packets to the libipq
application and then through verdict accept or drop them. Sorry for creating
the confusion by using "nfmark" in my emails. Right now my work does not
require nfmark at all. 
Now what I mean by "once" is that whenever I queue a specific flow of packet
to the libipq program and for example set the verdict to DROP, it works
fine. But if I change the verdict to ACCEPT and recompile my program, the
box still drops the packets. On the other hand if I ACCEPT the packets
first, they will always be accepted even after changing the verdict to DROP.
In short, whatever verdict I set the first time seems to be there always
despite the fact that I change the verdict and recompile the program. 
Regards,

Muhammad R. Sami 
Research Assistant, 
Computer Engineering Department 
P.O.Box 354 
King Fahd University of Petroleum & Minerals 
Dhahran 31261 
Saudi Arabia. 
Tel: +96638601423 
Cell: +96657982951 
www.ccse.kfupm.edu.sa/sami

-----Original Message-----
From: Henrik Nordstrom [mailto:hno@marasystems.com] 
Sent: Saturday, July 03, 2004 11:57 AM
To: Muhammad R. Sami
Cc: 'Babar Qaisrani'; 'Netfilter List'
Subject: RE: information

On Sat, 3 Jul 2004, Muhammad R. Sami wrote:

> Yes, I mean to say the verdict. Now I am a bit confused. Is not the
verdict
> enough to tell the kernel what to do with the packets? If yes, then it
does
> not work with me more than once. 

The verdict tells what to do with the packet in this hook 
(PREROUTING/FORWARD/POSTROUTING etc). Only if the verdirct is NF_ACCEPT is 
the packet accepted by this hook.

Why it only works "once" for you I do not know. Maybe if you describe in 
full details what you mean by "once" we can find some hint to what is 
going wrong.

It is only that your talk about nfmark made me a little confused. nfmark
is not related to the verdict. See the MARK target and/or linux advaced
routing howto for more info on nfmark in case you want to learn more what
the nfmark is and how it may be used. But it is not related to your 
problem.

Regards
Henrik
