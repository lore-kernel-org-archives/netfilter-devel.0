From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Mon, 1 Jul 2002 12:11:21 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207011211.21398.hno@marasystems.com>
References: <Pine.LNX.4.33.0207011037260.12444-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0207011037260.12444-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:

> - rewrite the IPT_CONTINUE targets as matches

I am not very fond of this.. besides the order dependency it also has the 
question on how to easily determine what will happen with the packet.. No 
obvious distinction between something that matches packets and something that 
modifies packets or internal system state (conntrack, nfmark, ippools etc..).

> - do nothing: the problem can always be solved by introducing custom
>   chains :-)

Well.. Not really. Consider for example the LOG "target" where one wants to 
use the --log-prefix option to log different cases. Would require a custom 
chain per case which is quite cumbersome. But sure, it is in theory doable 
just as having all rules duplicated in a single chain is.

> > So the question to the Netfilter core team is if it would be OK to add
> > a new option and "module class" to the userspace tools, and have the
> > existing IPT_CONTINUE targets dual-register as both a target and a
> > match. I can try to whip something together if this is seen as
>
> In my opinion the match solution would be better, cleaner.

So your current opinion is that the IPT_CONTINUE targets should be rewritten 
as matches?

Regards
Henrik
