From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problem accessing https://my.procurve.com/profile/index.aspx
 (ACK is over the upper bound)
Date: Mon, 02 Jul 2007 20:57:51 +0200
Message-ID: <46894AAF.8060908@trash.net>
References: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>	<Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>	<Pine.LNX.4.64.0707010334080.13212@bizon.gios.gov.pl>	<4688FD1A.4010303@trash.net>
	<Pine.LNX.4.64.0707022017050.25153@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707022017050.25153@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> On Mon, 2 Jul 2007, Patrick McHardy wrote:
>> Krzysztof Oledzki wrote:
>>
>>> Sounds familiar - it seems that there may be a crappy OpenBSD firewall
>>> lurking somewhere along the path. :(
>>
>>
>>
>> Indeed, too bad they apparently don't fix their crap and we're getting
>> at least one report per month about this.
> 
> 
> It seems they finally fixed it in a cvs at end of the Jan 2006 (so late
> - 10 years after sack had been specified in rfc2018):
> http://www.openbsd.org/cgi-bin/cvsweb/src/sys/net/pf.c.diff?r1=1.508&r2=1.509
> 
> 
> AFAIK it first went into 4.0 (released Nov 1, 2006) and also OPENBSD_3_9
> (STABLE "branch" for 3.9) so it is safe to assume that only very new
> installations may be safe. :(
> 
> AFAIK (again) this fix hasn't went into FreeBSD and NetBSD at all. :(
> Oh, crappy...


Thanks for the information.

>>> Additionally, creating TCPOPTSSTRIP target to allow striping specific
>>> tcp option(s) (for example Sack-Permitted from a SYN packet) may also be
>>> usable if it is possible to include this extension in a base kernel.
>>> This may also help with a similar window scaling problem as current
>>> solution requires to add a route on _all_ hosts inside a network.
>>> Working around it on a firewall may be much faster.
>>
>>
>>
>> Feel free to send patches :)
> 
> 
> OK. Will try to cook something. Can I base it on the IPV4OPTSSTRIP there
> is a better example? :)


Its not a great example IIRC, but I don't know of a better one.
