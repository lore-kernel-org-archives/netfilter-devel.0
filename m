From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Security flaw in Stateful filtering ??????
Date: 06 Jun 2002 19:48:14 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023385694.4894.50.camel@tux>
References: <3CFF9A00.2070805@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>,
	Mikkel Christiansen <mixxel@cs.auc.dk>,
	Mikkel Refsgaard Bech <mrb@cs.auc.dk>,
	Torben Vinther Schmidt <mariachi@cs.auc.dk>,
	Carsten Stiborg <stiborg@cs.auc.dk>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
In-Reply-To: <3CFF9A00.2070805@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2002-06-06 at 19:21, Emmanuel Fleury wrote:

[snip]
> I am just quoting their mail here:
 
[snip again]

> For short:
> - ACK packets are classified as NEW (without opening a connection),
> - Therefore, allowing NEW packets allow all the ACK packets to go
>    through,
> - And consequently, in this setting, you can perform ACK scanning
>    if you just trust the documentation...
> 
> Actually, I don't know what to answer to them. Has somebody any clue to
> explain this ?

Tell them (well  they are probably the ones cc'd :) to read through the
netfilter and netfilter-devel mailinglist archives as there's been
discussions about this.

And tell them that they should look at the conntrack-tcp-nopickup patch
in patch-o-matic. This patch disables the exact thing described here.

I recently mailed a patch against patch-o-matic that improves the
conntrack-tcp-nopickup patch so you can change the behaviour at runtime.

The newest tcp-window-tracking patch also has support for disabling this
type of connection pickup.

If you apply the conntrack-tcp-nopickup patch these ACK's will be marked
as INVALID instead of NEW.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
