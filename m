From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Mon, 1 Jul 2002 14:08:03 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0207011230071.12444-100000@blackhole.kfki.hu>
References: <200207011211.21398.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <200207011211.21398.hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 1 Jul 2002, Henrik Nordstrom wrote:

> > - rewrite the IPT_CONTINUE targets as matches
>
> I am not very fond of this.. besides the order dependency it also has the
> question on how to easily determine what will happen with the packet.. No
> obvious distinction between something that matches packets and something that
> modifies packets or internal system state (conntrack, nfmark, ippools etc..).

Nothing much can be do about order dependecy except the clear
documentation of the feature. When the prestate/raw table will be ready
(oh well, time...) then it'll be a good aid in spotting misconfigured
rules.

I see that the apparent distinction between true matches and matches with
side effect would be lost compared to the case of separated matches,
actions. Hoewer, would it help to the end user if there were a separated
interface to the matches with side-effect (actions)?

What would be the rule for an action name? I fear it would create a
confusion about which module is a match, which one is an action if an
action name would be lowercased.

Something new must be introduced. The question is which one more coherent
*and* more user-friendly.

> > In my opinion the match solution would be better, cleaner.
>
> So your current opinion is that the IPT_CONTINUE targets should be rewritten
> as matches?

This is my current personal opinion. The naming issue of actions really
disturbs me.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
