From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Introducing the Change API
Date: Fri, 17 Dec 2004 18:26:43 +0100
Message-ID: <41C316D3.1090604@trash.net>
References: <41B236F6.9090405@eurodev.net> <41B36E59.5020800@trash.net>
	<20041216124049.GF10165@sunbeam.de.gnumonks.org>
	<41C26E97.8000805@trash.net>
	<20041217080854.GC11436@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041217080854.GC11436@sunbeam.de.gnumonks.org>
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

>On Fri, Dec 17, 2004 at 06:28:55AM +0100, Patrick McHardy wrote:
>  
>
>>I would like to give it some cleanup first. Since it doesn't need to
>>deal with ipchains compatibility there is a lot possible cleanup.
>>I will probably do this in the next couple of weeks.
>>    
>>
>
>What kind of cleanup are you planning?  the provisions in conntrack are
>not that big for the compat stuff... it's more the provisions in nat
>(which we don't have yet for nf_conntrack).
>
Hmm I haven't looked into it very deeply yet, but I would like to kill
the nf_conntrack_standalone file and remove unneeded EXPORT_SYMBOLs.
I would also like to make naming more consistent and get rid of these
horrible long function names (nf_conntrack_do_something) by using the
nf_ct_ prefix everywhere.

>I'm willing to put some effort into this.  The question is:  Do we
>really need this cleanup before the merge, or can we do it afterwards?
>
>I mean, it seems to be stable - and it's not any more unclean than the
>current ip_conntrack code.  And we'll mark it as EXPERIMENTAL first
>anyway, so we have more freedom to play with it ;)
>  
>
Yes, but it's just less overhead doing this in your own tree than
submitting patches for all cleanups.

Regards
Patrick
