From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [RFC][LIBNFNETLINK 3/3] API changes
Date: Mon, 13 Feb 2006 15:44:05 +0000
Message-ID: <43F0A945.4010902@ufomechanic.net>
References: <43EFAB2A.4030204@eurodev.net>
	<20060213114452.GY4601@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060213114452.GY4601@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Sun, Feb 12, 2006 at 10:39:54PM +0100, Pablo Neira Ayuso wrote:
> 
>>This patch introduces the following changes:
>>
>>a) nfnl_handle_msg: this function completes the message iterator API.
> 
> looks nice to me.
> 
>>b) nfnl_handle_packet: This function is simpler interface to handle a
>>netfilter netlink message. It loops over every message contained in a
>>packet but, in this case, the programmer has no control on the looping
>>process. Moreover, this function now has a done flag that is set under
>>the same circunstances exposed above.
> 
> this change looks also fine to me, but since it changes an existing
> function, it introduces library incompatibility between the users
> (libnetfilter_*) and libnfnetlink.
...
> So how do we proceed?
> 
> I think at the moment, a new release of [most of] the libraries is
> needed due to accumulated bugfixes anyway.  So I'd rather make a
> maintainance release with what we've got now than to introduce API
> changes.  Addidional API (nfnl_communicate, nfnl_handle_msg) is not a
> problem at all.
> 
> As for the only API change (nfnl_handle_packet), I would like to know if
> there is an urgent need for the 'done' flag in any of the users.

AFAIR, done is not required unless we are trying to copy someone else 
api type.

3 types of return values were permitted, <0, 0 and >0, by the function 
which now has "done" added. 0 meant continue, either <0 or >0 meant 
"stop now" and the other meant "stop after all messages in the currently 
read packet", it's hard to see how this doesn't provide what done 
provided; even with 2 values.

Although I submitted that patch that provided the return behaviour, I'm 
not fighting a case, just pointing out that I think this is adequate for 
the time beng.

Sam
