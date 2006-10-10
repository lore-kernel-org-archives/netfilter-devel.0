From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [CTNETLINK] Fix compilation with debugging enabled
Date: Tue, 10 Oct 2006 20:07:53 +0200
Message-ID: <452BE179.6090702@netfilter.org>
References: <452AF2FE.1050606@netfilter.org> <452B25BB.6020909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <452B25BB.6020909@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Two debugging messages inside dump_table refer to variable `id'
>> that is not declared anymore.
> 
> Are you actually using the debugging stuff? Most of the ctnetlink
> debugging looks like a leftover from early development, so unless
> you think its still useful, I would prefer to remove it entirely
> since it makes the code less readable IMO.

Agreed, I'll cook a patch to remove it

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
