From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Fix hang on netfilter module unload
Date: Tue, 15 Mar 2005 09:23:30 -0800
Message-ID: <20050315172330.GA3130@linuxace.com>
References: <20050315050641.GA334@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@eurodev.net
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050315050641.GA334@linuxace.com>
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

> So we are leaking conntracks for some reason that we must diagnose.

No...the app is leaking skbs.  Since the skb never goes away (at least
until closing the app), the conntrack can thus not go away.  Isn't
it better for us to work around stupid apps like this?  Seems preferable
to not hang the box on iptables restart/unload, eh?

> But this is cheating, of course that the module will unload if we set 
> all refcounts to 1 we won't spin forever in the i_see_dead_people loop 
> but we are leaking somewhere anyway.

Well, again, the admin has asked to unload iptables -- should we unload,
or lockup the box?

Phil
