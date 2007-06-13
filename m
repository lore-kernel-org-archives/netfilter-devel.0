From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Follow packets in rules
Date: Wed, 13 Jun 2007 21:43:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706132138050.7396@blackhole.kfki.hu>
References: <466FB176.7040306@netfilter.org>
	<twig.1181752139.4605@bugmachine.ca> <467020F6.2050906@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467020F6.2050906@trash.net>
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

On Wed, 13 Jun 2007, Patrick McHardy wrote:

> Samuel Jean wrote:
>> There was the TRACE target born for this purpose a couple years ago.
>>
>> http://svn.netfilter.org/cgi-bin/viewcvs.cgi/branches/patch-o-matic-ng/linux-2.6.11/TRACE/?rev=3680
>>
>> It sure will require a bit of hacking for recent kernels.
>>
>> Pablo, Patrick --
>>
>> Is this an interesting feature that worths merging in mainline, or
>> patch-o-matic at least ?
>
> It would be interesting for the kernel if it can be done in a
> non-intrusive way. I can't remember what the old patches exactly
> did, but I believe it was kind of a hack.

It was just a little bit of hack ;-). I could not find the patch lying 
around here, fortunately there is an old copy from the patch-o-matic era
in svn:

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/old_stuff/netfilter/trunk/patch-o-matic/extra/TRACE.patch?rev=3069

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
