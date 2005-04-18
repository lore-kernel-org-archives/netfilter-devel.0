From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Mon, 18 Apr 2005 11:48:05 +0100
Message-ID: <42639065.70809@ufomechanic.net>
References: <424747D5.8060500@eurodev.net>
	<42502B1B.7090309@trash.net>	<42540839.8020405@ufomechanic.net>
	<4254265F.6080607@eurodev.net>	<20050410204542.GT9155@sunbeam.de.gnumonks.org>	<425BE027.1060301@eurodev.net>
	<425BE280.3040904@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <425BE280.3040904@eurodev.net>
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

Pablo Neira wrote:
> Pablo Neira wrote:
> 
>> Harald Welte wrote:
>>
>>> do you mind creating a patch against svn so we can put it into
>>> nfnetlink-ctnetlink/linux-2.6.11 ?
>>
>>
>>
>> Attached two patches against pom-ng:
>>
>> o ctevent-api: conntrack event API
>> o nfnetlink-ctnetlink: nfnetlink + conntrack netlink interface
> 
> oops, sorry, forgot the patches...

Can I just check that nfnetlink-ctnetlink-0.13 and 
nfnetlink-ctnetlink-0.50 in pom-ng-20050404 have been replaced by
pom-ng/nfnetlink and pom-ng/ctnetlink in pom-ng-20050417

Pablo, do they also fully supercede your patches 1-5 at 
http://people.netfilter.org/~pablo/patches/nfnetlink-conntrack-0.50-2.6.11/ 
and that there is nothing new in those?

If so, do you want me to create a pom-ng for the netlink packet counting 
stuff I sent last week, our will you spit that out at an appropriate 
point combined with your pattern defined dumping?

Sam
