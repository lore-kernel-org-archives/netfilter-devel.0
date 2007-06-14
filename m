From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Follow packets in rules
Date: Thu, 14 Jun 2007 16:18:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706141536530.8110@blackhole.kfki.hu>
References: <466FB176.7040306@netfilter.org>
	<twig.1181752139.4605@bugmachine.ca> <467020F6.2050906@trash.net>
	<Pine.LNX.4.64.0706132138050.7396@blackhole.kfki.hu>
	<46713EE8.6060906@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46713EE8.6060906@trash.net>
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

Hi Patrick,

On Thu, 14 Jun 2007, Patrick McHardy wrote:

>> http://svn.netfilter.org/cgi-bin/viewcvs.cgi/old_stuff/netfilter/trunk/patch-o-matic/extra/TRACE.patch?rev=3069
>
> Yeah, it doesn't look too bad. Unfortunately it breaks userspace
> compatibility.

Sigh.

> How about just adding a new match that prints a user-supplied string for 
> specially marked packets?

That'd be hard to use in practice: imagine, you have hundred of rules in 
multiple, multilevel chains. You should have to modify all your rules and 
add meaningful, different log strings to every one of them if you'd need 
to check how given packets traverse the rules.

Also, it'd be about the same as writing a log match. But in longer term 
we'd better support multiple targets instead of a log match.

The "beauty" of the TRACE target is that there is no need to tweak the 
rules: just "mark" the packets (we don't use the standard mark, so we 
cannot clash with any rule) you are interested in to check how they 
traverse the rulesets and that's all. Simple and clean.

An earlier version of the patch did not suffer from backward 
incompatibility: when we hit a marked packet and a matched rule, it 
searched the chain name and computed the rule number internally. But it 
can slow down packet processing if there are many matching rules and large 
number of rules in the chains so I introduced stored rulenumbers. What 
about going back to that approach? Tracing packets should not be 
considered as normal (and thus performance efficient) mode.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
