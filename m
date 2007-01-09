From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_request_find_match
Date: Tue, 09 Jan 2007 11:44:33 +0100
Message-ID: <45A37211.2010000@trash.net>
References: <Pine.LNX.4.61.0612161851180.30896@yvahk01.tjqt.qr>
	<4587D227.1000003@trash.net>
	<Pine.LNX.4.61.0612191405160.24179@yvahk01.tjqt.qr>
	<4587E91A.2020903@trash.net>
	<Pine.LNX.4.61.0612191623490.10396@yvahk01.tjqt.qr>
	<4588F175.8060109@trash.net>
	<Pine.LNX.4.61.0612201009540.26276@yvahk01.tjqt.qr>
	<4588FF92.9050607@trash.net>
	<Pine.LNX.4.61.0612232254110.10087@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0612232254110.10087@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> On Dec 20 2006 10:17, Patrick McHardy wrote:
> 
>>Jan Engelhardt wrote:
>>
>>>>Make sure the user specifies the match on the command line before
>>>>your match. Look at the TCPMSS or REJECT targets for examples for
>>>>this.
>>>
>>>That would mean I'd have to
>>>
>>>  -p tcp -m multiport --dport 1,2,3,4 -m time --time sundays -m 
>>>lotsofothers -j TARGET
>>>  -p udp -m multiport --dport 1,2,3,4 -m time --time sundays -m 
>>>lotsofothers -j TARGET
>>
>>I don't see any match that would depend on an other match in
>>your example. How about your start explaining what you would
>>like to do, ideally with some code.
> 
> 
> Yup, on the spot!
> http://jengelh.hopto.org/f/chaostables/chaostables-0.1.tar.bz2
> (Contains a target, but still something that could use 
> xt_request_find_module.)

That looks a bit silly, you combine matches and targets through
code instead of through the ruleset.

        /* Equivalent to
            -A chaos -m random --average 1 -j REJECT --reject-with
host-unreach
            -A chaos -p tcp -j TARPIT
            -A chaos -j DROP
        */

Just do that ..
