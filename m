From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: TTL patch buggy?
Date: Wed, 7 Jan 2004 17:16:51 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401071709030.4717-100000@filer.marasystems.com>
References: <1073426586.15282.13.camel@jasiiitosh.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
In-Reply-To: <1073426586.15282.13.camel@jasiiitosh.nexusmgmt.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 6 Jan 2004, John A. Sullivan III wrote:

> Ugh!! I'll have to see if I can find it.  I'm sure I deleted it.  It was
> just an obscure reference to a bug in TTL but was not specific.  We are
> planning to not only use the TTL patch in ISCS to create stealth
> firewalls but also to secure communications between internal and DMZ
> systems by allowing admins to set TTL on a per service basis to allow
> the DMZ <-> Internal flow to only have enough life to live on the site
> and not to be set anywhere else on the Internet.  We think this is a
> pretty interesting feature and hence are keen on the TTL patch working. 

Take care to never increase the TTL value however.

There is no technical problems from artificially decreasing the TTL, but 
increasing should never be done unless you are 200% sure on what you are 
doing (and even then you should not).

The TTL target is dangerous in the sense that it allows the packet ttl to
be set freely with no restrictions. But if combined with a "-m ttl
--ttl-gt NEWVALUE" then you should be safe.

Harald: What do you think about making the patch civilised and restricting
the TTL to be set to lower values only eleminating the need of the above
safeguard match? (simply change "new_ttl != iph->ttl" to "new_ttl < 
iph->ttl")

Regards
Henrik
