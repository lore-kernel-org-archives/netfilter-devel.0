From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 13/18] Netfilter: Multiport revision with port ranges
 (replaces "mport")
Date: Sun, 09 Jan 2005 23:34:10 +0100
Message-ID: <41E1B162.2010104@eurodev.net>
References: <1104896159.20582.79.camel@localhost.localdomain>	<20050105043027.GA23546@linuxace.com>	<1104904015.20582.91.camel@localhost.localdomain>	<20050108020322.GA11903@linuxace.com>
	<20050108034205.GK8756@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20050108034205.GK8756@eychenne.org>
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

bonjour,

Herve Eychenne wrote:

>>(note: didn't update manpage, but then again, wasn't updated with previous
>>changes)
>>    
>>
>
>Maybe because no one stated what the manpage policy regarding the
>new revision system would be?...
>When adding every successive revision documentation of every
>match/target to the manpage, wouldn't it become severly bloated in the
>end?
>  
>

Hm, I think that the revision infrastructure gives the possibility of 
extending a target/match with some kind of interesting features, 
something that we couldn't do so far. However, I don't encourage the 
release of a new revision every month or something like that.

So, I think that people must have a good reason to extend a 
target/match, and in case that this new revision is considered worthy. I 
would hold it for quite some time in the SVN repository and after that 
push it forward.

If we follow a policy similar to this, the manpages shouldn't get 
bloated so much I guess.

--
Pablo
