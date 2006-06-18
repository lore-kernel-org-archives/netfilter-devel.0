From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] Specify nf_queue max length from userspace
Date: Sun, 18 Jun 2006 19:13:11 +0200
Message-ID: <449589A7.10508@netfilter.org>
References: <1150217788.7164.4.camel@porky> <1150218404.5386.2.camel@porky>	
	<4492A5E5.1020308@netfilter.org> <1150579481.20920.15.camel@porky>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1150579481.20920.15.camel@porky>
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

Eric Leblond wrote:
> Hi Pablo,
> 
> On Fri, 2006-06-16 at 14:36 +0200, Pablo Neira Ayuso wrote:
> 
>>Hi Eric,
>>
>>> enum nfqnl_config_mode {
>>>+	NFQNL_COPY_UNSPEC,
>>> 	NFQNL_COPY_NONE,
>>> 	NFQNL_COPY_META,
>>> 	NFQNL_COPY_PACKET,
>>
>>If you have to add new attributes, do it always at the end, in other 
>>words, just before NFQNL_COPY_MAX. Otherwise you're breaking backward 
>>compatibility. See that old binaries use COPY_NONE set to 0, but after 
>>applying your patch COPY_NONE is set to 1. Result: old binaries will no 
>>work with nfnetlink_queue anymore.
> 
> 
> I agree with you on this point. But, as I know that second point was
> also breaking compatibility, I've made the choice to put less
> significant value first. It looks cleaner to me.
> 
> 
>>>@@ -75,6 +76,7 @@ enum nfqnl_config_mode {
>>> struct nfqnl_msg_config_params {
>>> 	u_int32_t	copy_range;
>>> 	u_int8_t	copy_mode;	/* enum nfqnl_config_mode */
>>>+	u_int32_t   queue_maxlen;
>>> } __attribute__ ((packed));
>>
>>Same thing here. If you have to modify this structure, you need to 
>>create a new one called struct nfqnl_msg_config_params2. Since I don't 
>>like this option, I think that the best solution is to add a new 
>>attribute called NFQNL_CFG_QUEUE_MAXLEN.
> 
> 
> I also think this is the cleanest way not to loose binary compatibility.
> But, as you notice it, it's ugly as queue max length is a param. The
> user-basis of libnetfilter_queue is really small for the moment: Only
> about two projects use it. There may be also some unpublished project
> but it should hurt too much to break binary compatibility to have a
> cleaner code.

Actually, this is what happen when you attach kernel and userspace to a 
certain structure. Instead, I think that it is better to split 
structures into fields.

> In fact, I think that having only one attribute and one structure could
> be used in the future to have a function that will be able to set copy
> mode and queue length in one call and one message.

This is not true, you can still implement a function that sets the queue 
length and copy mode with the solution that I proposed.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
