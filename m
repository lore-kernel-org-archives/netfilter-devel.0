From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [patch] conntrack tool: Fix loading of protocol helpers
Date: Wed, 28 Mar 2007 01:24:00 +0200
Message-ID: <4609A790.8020303@netfilter.org>
References: <200703161751.08498.thomas.jarosch@intra2net.com>
	<20070316201552.ugc8wof8g5twc0c0@intranator.m.i2n>
	<45FE629D.5040701@netfilter.org>
	<200703261646.41321.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200703261646.41321.thomas.jarosch@intra2net.com>
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

Thomas Jarosch wrote:
>> I'd prefer some examples directly hardcoded to the manpage since test.sh
>> is not distributed inside a release package, so this could get people
>> confused. So, would you resend me a patch with some examples? Thanks!
> 
> What about renaming test.sh to example.sh and include it
> in the normal distribution?

Hm, I don't like it either. Think of packaged versions provided by
vendors, they would have to put the script somewhere in the directory
tree. I still prefer the examples hardcoded in the manpage. Actually, I
usually like finding examples in manpages :)

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
