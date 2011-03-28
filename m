From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: is assert() an appropriate substitute for return -1?
Date: Mon, 28 Mar 2011 14:51:15 +0200
Message-ID: <4D908443.6070703@netfilter.org>
References: <AANLkTikDX+SqxROiZDQZXop_Ooiv9QXZR3JJ66sG2m--@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Sam Roberts <vieuxtech@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47793 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab1C1Muq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:50:46 -0400
In-Reply-To: <AANLkTikDX+SqxROiZDQZXop_Ooiv9QXZR3JJ66sG2m--@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24/03/11 19:23, Sam Roberts wrote:
>  From libnfnetlink.c:
>
>
>   * On success, 0 is returned. On error, -1 is returned and errno is set
>   * appropiately.
>   */
> int nfnl_callback_register(struct nfnl_subsys_handle *ssh,
>                             u_int8_t type, struct nfnl_callback *cb)
> {
>          assert(ssh);
>          assert(cb);
>
>          if (type>= ssh->cb_count) {
>                  errno = EINVAL;
>                  return -1;
>          }
>
> The docs say return -1, the code asserts on two arg checks, and
> returns an error for the third.
>
> I found this behaviour when calling nfct_callback_register() on a
> handle that was opened with the EXPECT subsystem.
>
> It appears to be the prevalent convention in the code, but I'm binding
> the nfct APIs into lua, and would like users of the scripting language
> to not have abort()ions on misuse of the API.
>
> I'm not super-keen on checking in my binding code all the conditions
> in underlying asserts. And there is no public nfct API to determine
> what subsystem the handle was opened on, anyhow, so I can't easily
> check.
>
> Is it worth supplying patches?

I read once in the manpages that you can disable assert() macro with NDEBUG.

Is that enough for you?
