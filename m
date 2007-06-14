From: Patrick McHardy <kaber@trash.net>
Subject: Re: Follow packets in rules
Date: Thu, 14 Jun 2007 15:13:12 +0200
Message-ID: <46713EE8.6060906@trash.net>
References: <466FB176.7040306@netfilter.org>	<twig.1181752139.4605@bugmachine.ca>
	<467020F6.2050906@trash.net>
	<Pine.LNX.4.64.0706132138050.7396@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706132138050.7396@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> On Wed, 13 Jun 2007, Patrick McHardy wrote:
> 
>> It would be interesting for the kernel if it can be done in a
>> non-intrusive way. I can't remember what the old patches exactly
>> did, but I believe it was kind of a hack.
> 
> 
> It was just a little bit of hack ;-). I could not find the patch lying
> around here, fortunately there is an old copy from the patch-o-matic era
> in svn:
> 
> http://svn.netfilter.org/cgi-bin/viewcvs.cgi/old_stuff/netfilter/trunk/patch-o-matic/extra/TRACE.patch?rev=3069


Yeah, it doesn't look too bad. Unfortunately it breaks userspace
compatibility. How about just adding a new match that prints
a user-supplied string for specially marked packets?
