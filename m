From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: RE: information
Date: Sat, 3 Jul 2004 11:18:45 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407030819.i638JSMX024604@madinah.ccse.kfupm.edu.sa>
References: <Pine.LNX.4.44.0407030306001.22423-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Babar Qaisrani'" <baqb03@student.bth.se>,
   "'Netfilter List'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Henrik Nordstrom'" <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0407030306001.22423-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Yes, I mean to say the verdict. Now I am a bit confused. Is not the verdict
enough to tell the kernel what to do with the packets? If yes, then it does
not work with me more than once. 

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
From: netfilter-devel-admin@lists.netfilter.org
[mailto:netfilter-devel-admin@lists.netfilter.org] On Behalf Of Henrik
Nordstrom
Sent: Saturday, July 03, 2004 4:08 AM
To: Muhammad R. Sami
Cc: 'Babar Qaisrani'; Netfilter List
Subject: RE: information

On Fri, 2 Jul 2004, Muhammad R. Sami wrote:

> I got the libipq/QUEUE part working but the problem is that it only works
> for the first time. For example, if I want to drop all icmp packets, it
> will, but if I change the nfmark from drop to accept and then recompile my
> libipq program, it does not work and the dropping policy is maintained.
Same
> for the other way around. 

Please explain what you refer to by "change the nfmark from drop to 
accept".


nfmark does not have a concept of drop/accept, just value.



Is you perhaps speaking about the verdict set by the userspace telling if
the packet should be accepted (passed on to next hook) or dropped? This is
just a verdict and not related to nfmark.

Regards
Henrik
