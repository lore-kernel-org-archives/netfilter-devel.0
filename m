From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/2] flow match
Date: Wed, 29 Jun 2005 21:18:33 +0200
Message-ID: <42C2F409.4040509@eurodev.net>
References: <20050628234912.GB23662@wsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Josh Samuelson <josamue1@wsc.edu>
In-Reply-To: <20050628234912.GB23662@wsc.edu>
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

Josh Samuelson wrote:
> Greetings all,
> 
> This patch requires Pablo Neira's conntrack event API patch.  It's been
> many months since I've posted, but I've been tracking the changes that
> have been made and making the necessary revisions to the code.
> Thanks Pablo for the heads-up on my silly misuses of the locks,
> hopefully I've got those cleared up. :)  I also added the ability to
> track new and established flows to the module.  Also I used
> Patrick McHardy's iterative state method of looping over the hashes
> for the proc files.  I figured it was high time to submit it again.
> 
> Quoting the man page for the match:
> 
>   This module allows you to match a packet when the specified number of
>   known protocol connections is exceeded.  The matches can be made
>   against generic IP, ICMP, TCP or UDP flow counters.  This match can be
>   used in all tables but raw.

Looks fine, I didn't have time yet to review this stuff in deep though, 
I'm moving to another appartament.

This stuff clearly supersedes `connlimit' that is a bit raw and very 
"limited".

@Patrick: Do you agree to add this to pom-ng?

--
Pablo
