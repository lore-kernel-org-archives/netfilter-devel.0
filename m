From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] libnfnetlink new API #2
Date: Tue, 08 Aug 2006 13:08:37 +0200
Message-ID: <44D870B5.8040707@trash.net>
References: <44C63B3F.2090509@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44C63B3F.2090509@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Hi,
> 
> Since I'll be leaving for two weeks, I'd like to put a patch for
> libnfnetlink on the table that I'm currently distributing with
> conntrackd for further discussion. I'd like to see this patch or
> something similar in mainline someday.
> 
> This patch:
> 
> - Fixes error handling that is currently broken, errors are now reported
> via errno so everyone could use perror(...) to get a more detailed
> description to know what is going wrong. Basically the new functions
> return -1 and set errno appropiately.
> 
> - Adds Documentation that comes handy for developers.
> 
> - Introduces replacement for nfnl_listen (nfnl_receive_process) and for
> nfnl_talk (nfnl_send_received_process), both are integrated with the
> nfnl_subsys_handle logic introduced by Harald, that IMHO must be the
> right direction, and set errno appropiately in case of error. These new
> functions obsolete nfnl_listen and nfnl_talk, we can add a clause
> __deprecated to warn programmers without removing them.
> 
> - Iterator API: to loop over a multipart netlink message and process it.
> This gives more control in the message processing. It is similar to
> Harald's nfnl_get_first_msg, nfnl_get_msg_next and nfnl_handle_packet
> set of functions but sets errno and move iterator private information
> out of nfnl_handle. I must confess that in this case I don't like too
> much the idea of providing too many function to do the same but my API
> looks friendlier I think, programmers are familiar with the concept of
> iterators.
> 
> - Introduce assertions to check input data: This can catch up wrong use
> of the API and errors and the application can break "nicer" (if
> breakages would ever be nice...) that segfaulting. I have seen these in
> others libraries.
> 
> In short: I think that we can deprecate old functions (just adding a
> warning in compilation time) and remove them in version 2, I have seen
> this in other libraries: we maintaining an old version 1 for those that
> don't want to move forward some time but provide a clean version 2
> and drop early design errors. BTW, probably the name of some functions
> are ugly, I accept suggestions ;)
> 
> @Patrick: I think that Harald has more in-deep knowledge about the
> libraries but, since he's really busy these days, your impressions on
> this issue can be also worth as well.


Without commenting on deprecating functions (I don't know about that),
the patch looks good to me.


> + * nfnl_send_receive_process - request/response challenge
> + * @h: nfnetlink handler
> + * @nlh: nfnetlink message to be sent
> + *
> + * This function is sends a nfnetlink message to a certain subsystem
> + * and receives the response that is processed by the callback registered
> + * via register_callback(). Note that this function is a replacement for
> + * nfnl_talk, its use is recommended.
> + *
> + * On success, 0 is returned. On error, a negative is returned. If your
> + * does not want to listen to events anymore, then it must return a value
> + * lesser or equal to 0.
> + *
> + * Note that ENOBUFS is returned in case that nfnetlink is exhausted. In
> + * that case is possible that the information requested is incomplete.
> + */
> +int nfnl_send_receive_process(struct nfnl_handle *h, struct nlmsghdr *nlh)
> +{
> +	assert(h);
> +	assert(nlh);
> +
> +	if (nfnl_send(h, nlh) == -1)
> +		return -1;
> +
> +	return nfnl_receive_process(h);
> +}

This doesn't really do what it promises, it will call the callback for
any message it receives, not only a response. We need to start using
sequence numbers before we associate responses with queries.
