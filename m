From: Patrick McHardy <kaber@trash.net>
Subject: Re: ERROR target in /proc/net/ip_tables_targets
Date: Thu, 27 Nov 2003 05:53:27 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0311270536590.30430@gw.localnet>
References: <20031127042854.GE1084@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20031127042854.GE1084@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Herve,

On Thu, 27 Nov 2003, Herve Eychenne wrote:

> Hmmm... well, "\nERROR\n" seems to be an intruder, don't you think?
> I looked at the code, and this ERROR target seems to be a marker for
> the beginning of user-chains... but you will agree with me that this
> implementation detail has absolutely nothing to do in a target listing
> publicly available to userspace.
> I would have been happy to write a small patch to fix this, but as I
> cannot really explain the presence of the preceding '\n' after a quick
> look, I prefer to leave that "removal" to more experienced people.
> Thanks in advance.

The newline comes from the entry in the targets list before
ipt_error_target, ipt_standard_target. Its name is defined in
include/linux/netfilter_ipv4/ip_tables.h as "". I made the patch
which added the ip_{matches,targets}_names files to /proc long ago
and noticed it back then, but came to the conclusion that hiding
them wasn't worth the additional code uglyness. The ipt_get_targets
function uses the existing list macros to walk the targets list,
these don't support skipping entries. The print function which is
called for each element is also used for matches and tables, so adding
code for skipping specific targets in there is also not very nice.
I would just count it as a minor uglyness and hope for a better way
to get matches/targets/tables with pkt_tables ;)

BTW: At least the "" target should logically be visible to userspace,
many users use it without realizing it by providing no target at all ;)

Best regards,
Patrick

>
>  Herve
>
> --
>  _
> (=B0=3D  Herv=E9 Eychenne
> //)
> v_/_ WallFire project:  http://www.wallfire.org/
>
