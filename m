From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: MARK target extension (fwd)
Date: Thu, 21 Oct 2004 15:18:34 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0410211516120.21167@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="Boundary-00=_fO6GBa24FRB2u9g"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-ID: <Pine.LNX.4.61.0410211516150.21167@filer.marasystems.com>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary-00=_fO6GBa24FRB2u9g
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; format=flowed
Content-ID: <Pine.LNX.4.61.0410211516151.21167@filer.marasystems.com>
Content-Disposition: INLINE

Found the CONNMARK mark operations patch by Grzegorz Nosek. It 
appears Grzegorz never sent this to the mailinglist and I assumed he did..

I have not verified the patch in detail, but like the idea.

---------- Forwarded message ----------
Date: Thu, 12 Aug 2004 19:06:39 +0200
From: Grzegorz Nosek <blackfire@metal.art.pl>
To: Patrick McHardy <kaber@trash.net>
Cc: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: MARK target extension

> I don't have much time currently, so that would be great ;)
> I'll fix up the 32/64-bit issue if you send me a patch.
> You can get the latest patches from CVS.
>
> Regards
> Patrick

Hello, most recent versions of markops and connmarkops are attached.

Inside you'll find the diffs and the source tree fragments I used to generate
them (iptables 1.2.9 and linux-2.4.26 with some unrelated patches). Changes
to the kernel part of CONNMARK are minimal but the userspace part has been
rewritten from scratch (based on markops)

I have performed only basic testing (I don't have any real-world CONNMARK
experience so I didn't have a decent test rig) but it seems to work OK.

I modified libipt_MARK.c too to add a one-line fix which turned out to be
necessary in CONNMARK.

The semantic of new CONNMARK is as follows:

The options
--set-mark MARK[/MASK]
--xor-mark VALUE
--and-mark VALUE
--or-mark VALUE
work exactly as in MARK with all this funky state machine, except that they
modify ct->mark value instead of skb->nfmark

The option --save-mark got two optional parameters:
--pkt-mask VALUE
--ct-mask VALUE
They are used to specify which bits from connmark and from nfmark we want to
save in the new nfmark, e.g.
--save-mark --pkt-mask 0xff00 --ct-mask 0xff
would retain bits 0-7 in connmark, replace bits 8-15 with corresponding bits
from nfmark and zero the rest.
--save-mark --pkt-mask 0xff00
would only save bits 8-15 of nfmark into connmark and zero the rest
--save-mark --ct-mask 0xff
would keep the lowest 8 bits of connmark and replace the rest with bits of
nfmark (pkt-mask defaults to ~ct-mask in save mode)
--save-mark
sets the entire connmark to nfmark (no change here) - default pkt-mask=~0,
default ct-mask=0

The option --restore-mark has been modified the same way but the defaults are
different as here the connmark is "more important" to us:
--restore-mark --pkt-mask 0xff00 --ct-mask 0xff
works the same as --save-mark except that it modifies packet's nfmark not
connmark
--restore-mark --pkt-mask 0xff00
would keep bits 8-15 untouched and replace the rest with connmark bits
--restore-mark --ct-mask 0xff
would set the lowest 8 bits to connmark and zero the rest.
--restore-mark
sets the entire nfmark to connmark like in the vanilla version

I tried my best to make the new semantics as DWIM as possible.

I'm looking forward to your comments and suggestions

Regards,
  Grzegorz Nosek
--Boundary-00=_fO6GBa24FRB2u9g
Content-Type: APPLICATION/X-GZIP; NAME="markops+connmarkops.tar.gz"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.61.0410211516152.21167@filer.marasystems.com>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME="markops+connmarkops.tar.gz"

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

--Boundary-00=_fO6GBa24FRB2u9g--
