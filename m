From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [patch] conntrack tool: Fix loading of protocol helpers
Date: Mon, 19 Mar 2007 11:14:53 +0100
Message-ID: <45FE629D.5040701@netfilter.org>
References: <200703161751.08498.thomas.jarosch@intra2net.com>	<45FACE99.5070702@netfilter.org>
	<20070316201552.ugc8wof8g5twc0c0@intranator.m.i2n>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070316201552.ugc8wof8g5twc0c0@intranator.m.i2n>
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

Hi Thomas,

Thomas Jarosch wrote:
>> Have a look at the script called test.sh under SVN, you can find one
>> there.
> 
> Thanks, that's exactly what I've searched for. I didn't notice it
> because it's called "test.sh". What about the attached patch for the
> manual page? ;-)

I'd prefer some examples directly hardcoded to the manpage since test.sh
is not distributed inside a release package, so this could get people
confused. So, would you resend me a patch with some examples? Thanks!

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
