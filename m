From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Introducing the Change API
Date: Fri, 17 Dec 2004 06:28:55 +0100
Message-ID: <41C26E97.8000805@trash.net>
References: <41B236F6.9090405@eurodev.net> <41B36E59.5020800@trash.net>
	<20041216124049.GF10165@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041216124049.GF10165@sunbeam.de.gnumonks.org>
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

>On Sun, Dec 05, 2004 at 09:23:53PM +0100, Patrick McHardy wrote:
>
>  
>
>>I think that depends on what we want to do with ip_conntrack once
>>nf_conntrack is merged. Since I really don't feel like keeping
>>three codebases in sync (ip_conntrack 2.4 + 2.6 and nf_conntrack),
>>I would prefer to remove it. If we do this, it doesn't make much
>>sense to add further features to it. But I'm not sure what Harald's
>>and Krisztian's plans are for ct_sync, so they might disagree with me.
>>    
>>
>
>I think we should move to nf_conntrack ASAP.  All new
>code/features/API's should be developed on top of nf_conntrack.  We
>really should put ip_conntrack into a maintainance-only mode once
>nf_conntrack becomes mainline.
>  
>
Agreed.

>Actually I only want to do some nf_conntrack vs. ip_conntrack
>benchmarking, which I never got aroun doing up to now :(  With a little
>luck, I can do this over the weekend.  If the results are acceptable,
>nf_conntrack will be submitted maybe as soon as 2.6.11. 
>  
>
I would like to give it some cleanup first. Since it doesn't need to
deal with ipchains compatibility there is a lot possible cleanup.
I will probably do this in the next couple of weeks.

Regards
Patrick
