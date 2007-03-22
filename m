From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [BROKEN] ipt_ wrappers for xt_ functions (WAS: Problems
 Compiling Geoip on linux-2.6.21-rc3)
Date: Thu, 22 Mar 2007 17:18:27 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703221712170.9555@yvahk01.tjqt.qr>
References: <200703080637.WAA05730@NickAndBarb.net>
	<twig.1173969394.3980@bugmachine.ca>, <45FA189A.8070605@trash.net>
	<Pine.LNX.4.61.0703212317181.486@yvahk01.tjqt.qr>
	<4602896C.3040404@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Samuel Jean <jix@bugmachine.ca>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Nick Pasich <NewsLetters@NickAndBarb.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4602896C.3040404@trash.net>
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


On Mar 22 2007 14:49, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>>>I'm afraid so. The good news is that I've planned to encapsulate the
>>>tons of (often unused) arguments to match/target functions in a
>>>structure, so future changes at least won't change the function
>>>signatures anymore.
>> 
>> By the way, when doing that, could we change the xt_match->match, 
>> xt_match->checkentry and xt_target->checkentry functions to return bool, 
>> now that it's available?
>
>I guess, although I don't think it will have any effect on the
>generated code.

bool is usually an unsigned 8-bit entity (when it comes to code generation),
int is usually signed 32. (i386) But I guess that's nothing new.


Jan
-- 
