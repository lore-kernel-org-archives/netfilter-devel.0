From: "allug4me allug4me" <allug4me@gmail.com>
Subject: Re: SIP ALG - Marking TOS/DSCP
Date: Thu, 12 Apr 2007 21:33:12 +0530
Message-ID: <ceaf8eaa0704120903x7cf064b8x1fbc61acdc39b788@mail.gmail.com>
References: <ceaf8eaa0704102342j5df5a98clc32a7d99c4cb8329@mail.gmail.com>
	<461C90F5.80905@trash.net>
	<ceaf8eaa0704120826w25b2c28cma466c782bb7c764d@mail.gmail.com>
	<ceaf8eaa0704120827n74e3511ar8e7d85b0367f9b2f@mail.gmail.com>
	<461E55D4.9010709@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <461E55D4.9010709@trash.net>
Content-Disposition: inline
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

Thank you very much Patrick for your help.
I'll try 2.6.21

regards,
marc

On 4/12/07, Patrick McHardy <kaber@trash.net> wrote:
> allug4me allug4me wrote:
> > Thank you very much Patrick for your help.
> >
> > Using the commands you provided i was able to mark SIP packets.
> > But for RTP, the marking isn't done. I am not sure about the problem.
> >
> > Is there any way to enable debug messages for sip helper so that it
> > can provide some insight?
>
>
> You can enabled debugging in the source. I'd suggest to try 2.6.21,
> there were a number of problems in the SIP helper that only got
> fixed recently.
>
