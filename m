From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] priv_data (formerly entry_data)
Date: Wed, 21 Jun 2006 03:04:38 +0200
Message-ID: <44989B26.8070704@trash.net>
References: <200606050029.08602.max@nucleus.it>
	<200606210203.33209.max@nucleus.it> <44989321.2000106@trash.net>
	<200606210245.26564.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200606210245.26564.max@nucleus.it>
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

Massimiliano Hofer wrote:
> On Wednesday 21 June 2006 2:30 am, Patrick McHardy wrote:
> 
> 
>>I think this should be done somewhere in x_tables. I think I would
>>rename xt_check_match to xt_init_match, put the allocation there
>>and finally rename ->checkentry to ->init .. the name doesn't really
>>fit anymore since people started doing real initialization in there,
>>and changing prototypes is a good opportunity for fixing that.
> 
> 
> I was wandering why it was duplicated between IPv4 and IPv6.

Do you mean the check_match functions and the ->checkentry calls?
The only reason is because they use a different type for the "ip"
argument.

> Are these changes planned for 2.6.18?

I was hoping you could do it while you're changing this stuff ..
I'd like to avoid touching all >30 files twice for a related
change.
