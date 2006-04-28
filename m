From: Patrick McHardy <kaber@trash.net>
Subject: Re: condition for 2.6.16
Date: Fri, 28 Apr 2006 15:07:26 +0200
Message-ID: <4452138E.7050402@trash.net>
References: <200604201919.19246.max@nucleus.it>
	<200604281246.40488.max@nucleus.it> <4451F745.4070900@trash.net>
	<200604281444.50982.max@nucleus.it>
	<Pine.LNX.4.58.0604281455520.20380@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0604281455520.20380@blackhole.kfki.hu>
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
> On Fri, 28 Apr 2006, Massimiliano Hofer wrote:
> 
> 
>>>How would you achieve O(1) average?
>>
>>Hash. But it adds complexity to the code and unnecessary complexity is a form
>>of ugliness.
> 
> 
> Why don't you choose an array and its indices? Array size could be
> specified by module parameter if the default were not sufficient for
> someone.

I just removed something similar from the nth match :) It used a
hard-coded size, but either way I don't like introducing this
limitation just to work around the small uglyness required to
keep a pointer inside the per-instance match data. We already
have multiple precedents for this.
