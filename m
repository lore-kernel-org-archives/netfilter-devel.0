From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [RFC][LIBNFNETLINK 3/3] API changes
Date: Tue, 14 Feb 2006 09:18:14 +0000
Message-ID: <43F1A056.8010600@ufomechanic.net>
References: <43EFAB2A.4030204@eurodev.net>	<20060213114452.GY4601@sunbeam.de.gnumonks.org>	<43F0A945.4010902@ufomechanic.net>
	<43F0F65C.7030604@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <43F0F65C.7030604@eurodev.net>
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

Pablo Neira Ayuso wrote:
> Amin Azez wrote:
> 
>>AFAIR, done is not required unless we are trying to copy someone else
>>api type.
>>
>>3 types of return values were permitted, <0, 0 and >0, by the function
>>which now has "done" added. 0 meant continue, either <0 or >0 meant
>>"stop now" and the other meant "stop after all messages in the currently
>>read packet", it's hard to see how this doesn't provide what done
>>provided; even with 2 values.
> 
> 
> Two kind of messages that mean "stop now" can make nfnl_handle_packet
> return 0.
> 
> a) ACK messages: When the client request some information with the
> NLM_F_ACK flag set.
> b) DONE messages: At dumping, the last message received has the
> NLM_F_MULTI flag set (NLMSG_DONE) to notify that the dumping has finished.
> 

I was talking about values returned by the user callback handler that 
can stop the read loop before all messages are exhausted.

Sam
