From: Sam Roberts <vieuxtech@gmail.com>
Subject: is assert() an appropriate substitute for return -1?
Date: Thu, 24 Mar 2011 11:23:04 -0700
Message-ID: <AANLkTikDX+SqxROiZDQZXop_Ooiv9QXZR3JJ66sG2m--@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50648 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab1CXSXF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:23:05 -0400
Received: by vws1 with SMTP id 1so226367vws.19
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2011 11:23:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>From libnfnetlink.c:


 * On success, 0 is returned. On error, -1 is returned and errno is set
 * appropiately.
 */
int nfnl_callback_register(struct nfnl_subsys_handle *ssh,
                           u_int8_t type, struct nfnl_callback *cb)
{
        assert(ssh);
        assert(cb);

        if (type >= ssh->cb_count) {
                errno = EINVAL;
                return -1;
        }

The docs say return -1, the code asserts on two arg checks, and
returns an error for the third.

I found this behaviour when calling nfct_callback_register() on a
handle that was opened with the EXPECT subsystem.

It appears to be the prevalent convention in the code, but I'm binding
the nfct APIs into lua, and would like users of the scripting language
to not have abort()ions on misuse of the API.

I'm not super-keen on checking in my binding code all the conditions
in underlying asserts. And there is no public nfct API to determine
what subsystem the handle was opened on, anyhow, so I can't easily
check.

Is it worth supplying patches?

Cheers,
Sam
