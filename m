From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
Subject: Re: iptables-save saves invalid negative --uid-owner expressions.
Date: Mon, 6 Jan 2003 03:02:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030106020219.GC423@comet.rv-int>
References: <35565.195.97.5.193.1041816667.squirrel@fs.tsaousis.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <35565.195.97.5.193.1041816667.squirrel@fs.tsaousis.gr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 06, 2003 at 03:31:07AM +0200, Costa Tsaousis wrote:

 Hi,

> I believe I have faced another, not-mentioned-in-2002, bug:
> [...]
> then iptables-save gives this:
> 
> -A OUTPUT -d ! 127.0.0.1 -p tcp -m owner --uid-owner !squid -m tcp --dport
> 80 -j DNAT --to-destination 127.0.0.1:3128
> 
> which produces a "user '!squid' not found" error when restored.

It seems to me that no single week passes without any post about this
kind of error (no space before a negation) in some save output module.
Sigh.
I must admit it seems quite strange to me that noone in the coreteam
didn't do that already. (hope I won't hurt anybody's feelings too
much though) ;-)

Would someone who's even more fed up than me with these recurrent
messages have time to audit the whole bunch of existing modules in
the CVS tree and fix this particular kind of problem _once and for all_?

Thanks in advance,

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
