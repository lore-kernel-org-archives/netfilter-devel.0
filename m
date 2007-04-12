From: Patrick McHardy <kaber@trash.net>
Subject: Re: SIP ALG - Marking TOS/DSCP
Date: Thu, 12 Apr 2007 17:52:52 +0200
Message-ID: <461E55D4.9010709@trash.net>
References: <ceaf8eaa0704102342j5df5a98clc32a7d99c4cb8329@mail.gmail.com>	
	<461C90F5.80905@trash.net>	
	<ceaf8eaa0704120826w25b2c28cma466c782bb7c764d@mail.gmail.com>
	<ceaf8eaa0704120827n74e3511ar8e7d85b0367f9b2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: allug4me allug4me <allug4me@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <ceaf8eaa0704120827n74e3511ar8e7d85b0367f9b2f@mail.gmail.com>
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

allug4me allug4me wrote:
> Thank you very much Patrick for your help.
> 
> Using the commands you provided i was able to mark SIP packets.
> But for RTP, the marking isn't done. I am not sure about the problem.
> 
> Is there any way to enable debug messages for sip helper so that it
> can provide some insight?


You can enabled debugging in the source. I'd suggest to try 2.6.21,
there were a number of problems in the SIP helper that only got
fixed recently.
