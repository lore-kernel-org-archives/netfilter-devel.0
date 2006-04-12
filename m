From: Patrick McHardy <kaber@trash.net>
Subject: Re: nth, random and fuzzy match
Date: Wed, 12 Apr 2006 20:57:49 +0200
Message-ID: <443D4DAD.4040908@trash.net>
References: <4435559A.60904@trash.net>
	<20060412084719.GP31616@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060412084719.GP31616@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Thu, Apr 06, 2006 at 07:53:30PM +0200, Patrick McHardy wrote:
> 
>>So my questions to the nth users: is anyone using the nth
>>match in a way that can't be done by just matching on every
>>nth packet with an optional starting point?
> 
> 
> I suggest posting this to the users mailinglist, since the question is
> addressed to users :)

I already decided for myself, the functionality is not affected
by removing the shared counters, it just needs to be used
slightly different in some cases.
