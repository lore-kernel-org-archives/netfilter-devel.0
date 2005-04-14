From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: About matching (also was: Multiple Targets)
Date: Thu, 14 Apr 2005 08:56:18 +0000
Message-ID: <425E3032.2060409@outerspace.dyndns.org>
References: <20050413152307.0312.LARK@linux.net.cn>
	<425CEFE3.2010200@rtij.nl>	<20050413182822.0317.LARK@linux.net.cn>
	<425CFFE0.1000803@rtij.nl>	<20050413112518.GB22865@oknodo.bof.de>	<Pine.LNX.4.61.0504140315010.16405@filer.marasystems.com>
	<7174b1e40504140101b5138e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick Schaaf <bof@bof.de>,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ben La Monica <ben.lamonica@gmail.com>
In-Reply-To: <7174b1e40504140101b5138e0@mail.gmail.com>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting Ben La Monica on 2005-04-14 08:01 UTC:

> I actually started working on a patch, but then someone mentioned that
> it had to be binary compatible with the current iptables. The problem
> being that RETURN is a special case. The --up N option is only like 15
> lines of code if nobody minds the fact that you'll need to use a newer
> version of the iptables binary and newer kernel. Since RETURN is just
> an ipt_standard_target like DROP or ACCEPT.

I think I'd rather decide on the calling side how up to go instead of on
the return side.

> Also, concerning the multiple targets for one match, what about a
> module that did something like this:
> 
> iptables -I INPUT -p tcp -s 10.0.0.0/24 -j MULTIPLE --mjump ULOG
> --ulog-prefix "bad" --mjump REJECT --reject-with tcp-reset
> 
> And then the MULTIPLE target would actually create the targets for
> ULOG and REJECT, put them in a linked list, execute them in the order
> received, and then use the last value to return to iptables with the
> verdict.

Interesting idea.. but I think I would still prefer to just write
support for multiple targets, e.g.

iptables ... -j MARK --set-mark 10 -j LOG --log-prefix "foo" -j ACCEPT

The structures currently hold exactly one target, I think it wouldn't be
too hard extending that to have multiple targets instead, just like
there already is support for multiple matches. I think it might even be
easier to implement this than to make targets work properly from a
"MULTIPLE" target.. but that's just my guess :)

Maybe one could use some unused bit in the structures to indicate that
multiple targets are in use in order to remain binary compatible..

> Anyway, if you have any input regarding this, I can try to write it
> this weekend.

Good luck :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCXjAwxyF48ZTvn+4RAtekAKChHmHI23Am8BaiAI2zYOQQB/mvogCg17EX
IVypyxHSJvVjbBQJdHzoPk4=
=pGSr
-----END PGP SIGNATURE-----
