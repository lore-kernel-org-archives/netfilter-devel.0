From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Re[2]: DoS on kernel 2.4.27+ -j LOG (fwd)
Date: Sat, 15 Jan 2005 09:31:31 +0100
Message-ID: <1105777891.3391.11.camel@localhost.localdomain>
References: <Pine.LNX.4.61.0411270340420.15105@filer.marasystems.com>
	<Pine.LNX.4.61.0501141722040.11870@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Crazy AMD K7 <snort2004@mail.ru>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	ebtables-devel@lists.sourceforge.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0501141722040.11870@filer.marasystems.com>
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

Op vr, 14-01-2005 te 17:31 +0100, schreef Henrik Nordstrom:
> On Sat, 27 Nov 2004, Crazy AMD K7 wrote:
> 
> 
> > Code;  c022dcdc <ip_sabotage_out+2c/110>
> > 00000000 <_EIP>:
> > Code;  c022dcdc <ip_sabotage_out+2c/110>   <=====
> >   0:   66 83 79 10 08            cmpw   $0x8,0x10(%ecx)   <=====
> > Code;  c022dce1 <ip_sabotage_out+31/110>
> >   5:   75 1d                     jne    24 <_EIP+0x24> c022dd00 
> > <ip_sabotage_out+50/110>
> 
> 
> I am now also experiencing this exact same problem, and it seems a handful
> other people also experience this problem.
> 
> Have you found any additional clues to what may be causing this?


The fix is already available. I haven't updated the 2.4 patch yet
because DaveM hasn't included the fix yet in 2.6. Hmm, I just checked
Linus' tree and the fix is there. Expect a new patch later today...

You can find the fix at
http://ebtables.sourceforge.net/fixbrnf.diff

cheers,
Bart
