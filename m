From: Herve Eychenne <rv@wallfire.org>
Subject: Re: ERROR target in /proc/net/ip_tables_targets
Date: Thu, 27 Nov 2003 06:07:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031127050742.GB2740@eychenne.org>
References: <20031127042854.GE1084@eychenne.org> <Pine.LNX.4.58.0311270536590.30430@gw.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0311270536590.30430@gw.localnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 27, 2003 at 05:53:27AM +0100, Patrick McHardy wrote:

 Hi Patrick,

> On Thu, 27 Nov 2003, Herve Eychenne wrote:

> > Hmmm... well, "\nERROR\n" seems to be an intruder, don't you think?
> > I looked at the code, and this ERROR target seems to be a marker for
> > the beginning of user-chains... but you will agree with me that this
> > implementation detail has absolutely nothing to do in a target listing
> > publicly available to userspace.
> > I would have been happy to write a small patch to fix this, but as I
> > cannot really explain the presence of the preceding '\n' after a quick
> > look, I prefer to leave that "removal" to more experienced people.
> > Thanks in advance.

> The newline comes from the entry in the targets list before
> ipt_error_target, ipt_standard_target. Its name is defined in
> include/linux/netfilter_ipv4/ip_tables.h as "". I made the patch
> which added the ip_{matches,targets}_names files to /proc long ago
> and noticed it back then, but came to the conclusion that hiding
> them wasn't worth the additional code uglyness. The ipt_get_targets
> function uses the existing list macros to walk the targets list,
> these don't support skipping entries. The print function which is
> called for each element is also used for matches and tables, so adding
> code for skipping specific targets in there is also not very nice.
> I would just count it as a minor uglyness and hope for a better way
> to get matches/targets/tables with pkt_tables ;)

Yes, except than when you do a cat /proc/net/ip_tables_targets and
read "ERROR" at the end of the list, you get the strong (and
unpleasant) feeling that something went wrong and that the list may
not be complete (even if _you_ (netfilter developer) know it is).

So (even if I understand your concerns at the time you wrote the
patch) this is IMHO not acceptable.
Please, let's not sacrifice "ignorant" user time and confidence for a
few duplicate lines of kernel code...

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
