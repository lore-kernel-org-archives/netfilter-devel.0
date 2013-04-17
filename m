From: Victor Julien <lists@inliniac.net>
Subject: Re: [Nftables RFC] High level library proposal
Date: Wed, 17 Apr 2013 15:52:00 +0200
Message-ID: <516EA900.3080607@inliniac.net>
References: <516EA684.9040209@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Leblond <eric@regit.org>,
	Julien Vehent <julien@linuxwall.info>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:40584 "EHLO
	tulpe.vuurmuur.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966116Ab3DQNxH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:53:07 -0400
In-Reply-To: <516EA684.9040209@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04/17/2013 03:41 PM, Tomasz Bursztyka wrote:
> NFTABLES - High level library proposal
> ======================================
> 
> The goal is to enable applications to get an easy and flexible access to
> nftables netlink's API.
> 
> We have to consider a lot of different use-case, from the application which
> want to manage the whole rule set to the one which will quickly do a
> one-shot
> access.
> 
> I tried to keep the API simple so it will be almost as simple as what
> current
> applications are doing with iptables plus the extra nice stuff nftables
> bring.
> (notifications, transactions mostly...). All complex work should be
> hidden to
> the developer. Thus, it will take a bit of time to get it implemented.w
> 
> Table/chain/rule/set specifications will follow nft format. The library
> will
> not provide backward compatibility to iptables format. The tools which
> access
> existing xtables do it through the iptables tool, so if they want to access
> nftables with backward compatible rule format it will use iptables-nftables
> tool instead. So no need to support iptables format in this library.
> Using this library presented here will be already quite a task, so I guess
> moving towards using nft format as well will not be the hard part anyway.
> 
> I am thinking of taking original nft tool's lexer/parser for the
> statements.
> It's nice, it works, no need to reinvent the wheel. The change will be on
> creating libnftables objects instead.
> 
> To validate the event and nl driver approach I did a PoC which proved it. I
> could create a table and chain, list those... witheither libmnl or
> libnl, and
> glib as the event loop, it just works so it opens compatibility against any
> netlinkaccess library or event loop (libevent, efl...)
> 
> Note: It's just a proposal, so the function names/signature is about to
> change
> most surely. But the basic idea is there.
> 
> 
> API:
> ===
> 
> int nft_init(int flags, struct nft_event_driver *event_driver,
>                                 struct nft_nl_driver nl_driver):
> -> initiate the library.
> 
> Flags:
> NFT_FLAG_NL_SYNC (default): using libmnl (already used by libnftables,
> so no extra dependancy) event_driver and nl_driver are forgotten.
> NFT_FLAG_NL_ASYNC: Same as previous but a event_driver is at least
> mandatory.
> And a nl_driver can be provided to support libnl, others...
> 
> I am thinking of those as well:
> 
> NFT_FLAG_FOLLOW_LOCAL (default): will notice about the locally manipulated
> rules events.
> NFT_FLAG_FOLLOW_GLOBAL: will keep notice about the whole rule set event.
> 
> Return: 0 on success, negative error value instead.
> 
> void nft_exit(void):
> -> exit the library.
> 
> 
> Basic operations:
> ================
> 
> Signature of callback has to be designed further. Event type, handle,
> user data, ...
> 
> int nft_set_notification_callback(nft_notification_callback_f):
> -> notify on nftables event (NFT_FLAG_FOLLOW_* applies)
> 
> int nft_execute_statement(nft_statement_callback_f, void *user_data,
>                                         char *statement_format, ...):
> -> execute statement. Execution flow depends on NFT_FLAG_NL_* of course.
> This could be compared to what is done currently with iptables commands
> thrown through a sub-process. But here, no sub-process, notifications, ...
> 
> 
> Context based:
> =============
> 
> When nft_execute_statement() is nice for one-shot call and forget, some
> applications might want to follow precisely what's happening in a
> long-run on
> nftables rule-set either in general or depending on specific context
> which can
> be plural in same application. One might need to temporarilyset a certain
> number of rules dedicated to a situation. This part of the API will help on
> that.
> 
> From internal execution point of view, it will be transaction based.
> 
> Callback signature will probably follow the same as previous ones, with
> slight difference like adding the context pointer to it.
> 
> struct nft_ctx *nft_ctx_new(nft_context_callback_f)
> -> create a new context.
> 
> int nft_ctx_list(struct nft_ctx *ctx, FILE *out)
> -> list the context's owned statements
> 
> int nft_ctx_enable(struct nft_ctx *ctx)
> -> apply statements previously executed
> 
> int nft_ctx_disable(struct nft_ctx *ctx)
> -> delete statements previously executed
> 
> void nft_ctx_free(struct nft_ctx *ctx)
> -> free the context (do not enable/disable anything here)
> 
> int nft_ctx_execute_statement(struct nft_ctx *ctx,
>                                         char *statement_format, ...)
> -> execute the statement related to given context.
> 
> 
> Listing:
> =======
> 
> int nft_setup_list_driver(int flags,
>                         struct nft_list_driver *driver):
> -> set the output format for listing the statements
> flags:  NFT_LIST_DRIVER_XML (current default format in libnftables)
>         NFT_LIST_DRIVER_JSON (that format idea comes from Julien Vehent)
>         NFT_LIST_DRIVER_EXTERNAL -> driver should be provided (need small
>         modifications in libnftables)
> 
> int nft_list_all(FILE *out)
> 
> We could have specific things like nft_list_by_handle()... not sure if
> it will
> be useful.
> 
> Besides, we could have lower level helpers, like nft_table_new(char
> *table_name) or whatever comes. If relevant, only.
> 
> If you have comments and/or ideas, please go ahead. I am anyway starting to
> implement itnowand I will in parallel create real tools to test it
> according
> to specific use cases.
> 
> 
> @Pablo: could you create a repository on netfilter.org's git? libnft?
> 
> or whatever comes as better name if anybody has a nice proposition
> 
> 

Not sure if it would fit the scope of this library, but as a frontend
developer I would love to have easy access to some sort of "supported
features" call.

In Vuurmuur I currently parse /proc/net/ip_tables_names to see what
tables are supported, /proc/net/ip_tables_matches to see what matches
are supported, etc.

This still isn't enough, because it won't tell me if the SNAT target
will actually support the --random option, so I end up creating a lot of
test rules at startup, just to figure this stuff out.

Then there is also the case of a mismatch between kernel and userland. I
remember one case where the Ubuntu kernel would support a module, but
the shipped iptables wouldn't.

Not sure if all of this is relevant to nftables and I don't have a
proposed solution, but just wanted to bring it up for consideration.

-- 
---------------------------------------------
Victor Julien
http://www.inliniac.net/
PGP: http://www.inliniac.net/victorjulien.asc
---------------------------------------------

