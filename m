From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Mon, 18 Apr 2005 12:06:29 +0100
Message-ID: <426394B5.9030401@ufomechanic.net>
References: <424747D5.8060500@eurodev.net>
	<42502B1B.7090309@trash.net>	<42540839.8020405@ufomechanic.net>
	<4254265F.6080607@eurodev.net>
	<20050410204542.GT9155@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050410204542.GT9155@sunbeam.de.gnumonks.org>
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
> On Wed, Apr 06, 2005 at 08:11:43PM +0200, Pablo Neira wrote:
> 
>>Amin Azez wrote:
>>
>>>It appears that pom-ng nfnetlink-ctnetlink-0.13 (ported by Pablo?) requires 
>>>ct-event (although this is not listed in the pom-ng dependancies).
>>>Pablo, can you confirm this?
>>
>>I've just merged Harald's and my port. You can get it from:
>>
>>http://people.netfilter.org/~pablo/patches/nfnetlink-conntrack-0.50-2.6.11/
> 
> 
> do you mind creating a patch against svn so we can put it into
> nfnetlink-ctnetlink/linux-2.6.11 ?
> 
> thanks!

If anyone got a partial reply to this, I apologise. Thunderbird seems to 
abort the NNTP part of the send and then closes the "progress window" 
while it carries on with the SMTP part of the send. All the mad 
"pressing escape" just prevents the sent message from being stored in my 
sent-items folder so I have to start again. AGGH

Anyway, I notice Haralds patch on flow-based-accounting and svn and 
stuff, which answers my question.

Amin
